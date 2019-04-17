Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44300 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733174AbfDQRuO (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 13:50:14 -0400
Received: by mail-lj1-f195.google.com with SMTP id h16so23243930ljg.11
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 10:50:11 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [RFC PATCH 3/3] net: ethernet: ti: cpsw: add XDP support
Date: Wed, 17 Apr 2019 20:49:42 +0300
Message-Id: <20190417174942.11811-4-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: grygorii.strashko@ti.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ilias.apalodimas@linaro.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, ast@kernel.org, aniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Add XDP support based on rx page_pool allocator, one frame per page.
This patch was verified with af_xdp and xdp drop. Page pool allocator
is used with assumption that only one rx_handler is running
simultaneously. DMA map/unmap is reused from page pool despite there
is no need to map whole page.

Due to specific of cpsw, the same TX/RX handler can be used by 2
network devices, so special fields in buffer are added to identify
an interface the frame is destined to.

XDP prog is common for all channels till appropriate changes are added
in XDP infrastructure.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/Kconfig |   1 +
 drivers/net/ethernet/ti/cpsw.c  | 535 ++++++++++++++++++++++++++++----
 2 files changed, 474 insertions(+), 62 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 8b21b40a9fe5..88b95dfed92c 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -66,6 +66,7 @@ config TI_CPSW
 	select TI_DAVINCI_CPDMA
 	select TI_DAVINCI_MDIO
 	select TI_CPSW_ALE
+	select PAGE_POOL
 	select MFD_SYSCON
 	select REGMAP
 	---help---
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 0fd1b3909333..2cd395d012f6 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -13,6 +13,7 @@
  * GNU General Public License for more details.
  */
 
+#include <net/page_pool.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/clk.h>
@@ -38,6 +39,9 @@
 #include <linux/if_vlan.h>
 #include <linux/kmemleak.h>
 #include <linux/sys_soc.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
+#include <linux/filter.h>
 
 #include <linux/pinctrl/consumer.h>
 #include <net/pkt_cls.h>
@@ -456,11 +460,13 @@ struct cpsw_common {
 	int				rx_ch_num, tx_ch_num;
 	int				speed;
 	int				usage_count;
+	struct page_pool		*rx_page_pool;
 };
 
 struct cpsw_priv {
 	struct net_device		*ndev;
 	struct device			*dev;
+	struct bpf_prog			*xdp_prog;
 	u32				msg_enable;
 	u8				mac_addr[ETH_ALEN];
 	bool				rx_pause;
@@ -470,6 +476,7 @@ struct cpsw_priv {
 	int				shp_cfg_speed;
 	int				tx_ts_enabled;
 	int				rx_ts_enabled;
+	struct xdp_rxq_info		xdp_rxq[CPSW_MAX_QUEUES];
 	u32 emac_port;
 	struct cpsw_common *cpsw;
 };
@@ -481,6 +488,10 @@ struct cpsw_stats {
 	int stat_offset;
 };
 
+/* The buf shall include headroom compatible with both skb and xdpf */
+#define CPSW_HEADROOM_NA (max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + NET_IP_ALIGN)
+#define CPSW_HEADROOM	ALIGN(CPSW_HEADROOM_NA, sizeof(unsigned long))
+
 enum {
 	CPSW_STATS,
 	CPDMA_RX_STATS,
@@ -838,24 +849,58 @@ static void cpsw_intr_disable(struct cpsw_common *cpsw)
 	return;
 }
 
+static int cpsw_is_xdpf_handle(void *handle)
+{
+	return (unsigned long)handle & BIT(0);
+}
+
+static void *cpsw_xdpf_to_handle(struct xdp_frame *xdpf)
+{
+	return (void *)((unsigned long)xdpf | BIT(0));
+}
+
+static struct xdp_frame *cpsw_handle_to_xdpf(void *handle)
+{
+	return (struct xdp_frame *)((unsigned long)handle & ~BIT(0));
+}
+
+struct cpsw_meta_xdp {
+	struct net_device *ndev;
+	int ch;
+};
+
 static int cpsw_tx_handler(void *token, int len, int status)
 {
+	struct cpsw_meta_xdp	*xmeta;
+	struct xdp_frame	*xdpf;
+	struct net_device	*ndev;
 	struct netdev_queue	*txq;
-	struct sk_buff		*skb = token;
-	struct net_device	*ndev = skb->dev;
-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
+	struct sk_buff		*skb;
+	int			ch;
+
+	if (cpsw_is_xdpf_handle(token)) {
+		xdpf = cpsw_handle_to_xdpf(token);
+		xmeta = xdpf->data - xdpf->metasize;
+		ndev = xmeta->ndev;
+		ch = xmeta->ch;
+		xdp_return_frame_rx_napi(xdpf);
+	} else {
+		skb = token;
+		ndev = skb->dev;
+		ch = skb_get_queue_mapping(skb);
+		cpts_tx_timestamp(ndev_to_cpsw(ndev)->cpts, skb);
+		dev_kfree_skb_any(skb);
+	}
 
 	/* Check whether the queue is stopped due to stalled tx dma, if the
 	 * queue is stopped then start the queue as we have free desc for tx
 	 */
-	txq = netdev_get_tx_queue(ndev, skb_get_queue_mapping(skb));
+	txq = netdev_get_tx_queue(ndev, ch);
 	if (unlikely(netif_tx_queue_stopped(txq)))
 		netif_tx_wake_queue(txq);
 
-	cpts_tx_timestamp(cpsw->cpts, skb);
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
-	dev_kfree_skb_any(skb);
 	return 0;
 }
 
@@ -902,22 +947,169 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
 	}
 }
 
+static inline int cpsw_tx_submit_xdpf(struct cpsw_priv *priv,
+				      struct xdp_frame *xdpf,
+				      struct cpdma_chan *txch)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+
+	return cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf), xdpf->data,
+				 xdpf->len,
+				 priv->emac_port + cpsw->data.dual_emac);
+}
+
+static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *frame)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_meta_xdp *xmeta;
+	struct cpdma_chan *txch;
+	int ret = 0;
+
+	frame->metasize = sizeof(struct cpsw_meta_xdp);
+	xmeta = frame->data - frame->metasize;
+	xmeta->ndev = priv->ndev;
+	xmeta->ch = 0;
+
+	txch = cpsw->txv[0].ch;
+	ret = cpsw_tx_submit_xdpf(priv, frame, txch);
+	if (ret) {
+		xdp_return_frame_rx_napi(frame);
+		ret = -1;
+	}
+
+	/* If there is no more tx desc left free then we need to
+	 * tell the kernel to stop sending us tx frames.
+	 */
+	if (unlikely(!cpdma_check_free_tx_desc(txch))) {
+		struct netdev_queue *txq = netdev_get_tx_queue(priv->ndev, 0);
+
+		netif_tx_stop_queue(txq);
+
+		/* Barrier, so that stop_queue visible to other cpus */
+		smp_mb__after_atomic();
+
+		if (cpdma_check_free_tx_desc(txch))
+			netif_tx_wake_queue(txq);
+	}
+
+	return ret;
+}
+
+static int cpsw_run_xdp(struct cpsw_priv *priv, struct cpsw_vector *rxv,
+			struct xdp_buff *xdp)
+{
+	struct net_device *ndev = priv->ndev;
+	struct xdp_frame *xdpf;
+	struct bpf_prog *prog;
+	int ret = 1;
+	u32 act;
+
+	rcu_read_lock();
+
+	prog = READ_ONCE(priv->xdp_prog);
+	if (!prog) {
+		ret = 0;
+		goto out;
+	}
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+		ret = 0;
+		break;
+	case XDP_TX:
+		xdpf = convert_to_xdp_frame(xdp);
+		if (unlikely(!xdpf))
+			xdp_return_buff(xdp);
+		else
+			cpsw_xdp_tx_frame(priv, xdpf);
+		break;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(ndev, xdp, prog))
+			xdp_return_buff(xdp);
+		else
+			ret = 2;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fall through */
+	case XDP_ABORTED:
+		trace_xdp_exception(ndev, prog, act);
+		/* fall through -- handle aborts by dropping packet */
+	case XDP_DROP:
+		xdp_return_buff(xdp);
+		break;
+	}
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
+static unsigned int cpsw_rxbuf_total_len(unsigned int len)
+{
+	len += CPSW_HEADROOM;
+	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	return SKB_DATA_ALIGN(len);
+}
+
+static struct page_pool *cpsw_create_rx_pool(struct cpsw_common *cpsw)
+{
+	struct page_pool_params pp_params = { 0 };
+
+	pp_params.order = 0;
+	pp_params.flags = PP_FLAG_DMA_MAP;
+
+	 /* set it to number of descriptors to be cached from init? */
+	pp_params.pool_size = descs_pool_size;
+	pp_params.nid = NUMA_NO_NODE; /* no numa */
+	pp_params.dma_dir = DMA_FROM_DEVICE;
+	pp_params.dev = cpsw->dev;
+
+	return page_pool_create(&pp_params);
+}
+
+static struct page *cpsw_alloc_page(struct cpsw_common *cpsw)
+{
+	struct page_pool *pool = cpsw->rx_page_pool;
+	struct page *page;
+	int i = 0;
+
+	do {
+		page = page_pool_dev_alloc_pages(pool);
+		if (!page)
+			return NULL;
+
+		/* skip pages used by skb netstack */
+		if (page_ref_count(page) == 1)
+			break;
+
+		/* it's a pitty, but free page */
+		page_pool_recycle_direct(pool, page);
+	} while (++i < descs_pool_size);
+
+	return page;
+}
+
 static int cpsw_rx_handler(void *token, int len, int status)
 {
-	struct cpdma_chan	*ch;
-	struct sk_buff		*skb = token;
-	struct sk_buff		*new_skb;
-	struct net_device	*ndev = skb->dev;
-	int			ret = 0, port;
-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
+	struct page		*new_page, *page = token;
+	struct cpsw_meta_xdp	*new_xmeta, *xmeta = page_address(page);
+	struct cpsw_common	*cpsw = ndev_to_cpsw(xmeta->ndev);
+	int			pkt_size = cpsw->rx_packet_max;
+	int			ret = 0, port, ch = xmeta->ch;
+	struct page_pool	*pool = cpsw->rx_page_pool;
+	int			headroom = CPSW_HEADROOM;
+	struct net_device	*ndev = xmeta->ndev;
+	int			flush = 0;
 	struct cpsw_priv	*priv;
+	struct sk_buff		*skb;
+	struct xdp_buff		xdp;
+	dma_addr_t		dma;
 
 	if (cpsw->data.dual_emac) {
 		port = CPDMA_RX_SOURCE_PORT(status);
-		if (port) {
+		if (port)
 			ndev = cpsw->slaves[--port].ndev;
-			skb->dev = ndev;
-		}
 	}
 
 	if (unlikely(status < 0) || unlikely(!netif_running(ndev))) {
@@ -930,47 +1122,105 @@ static int cpsw_rx_handler(void *token, int len, int status)
 			 * in reducing of the number of rx descriptor in
 			 * DMA engine, requeue skb back to cpdma.
 			 */
-			new_skb = skb;
+			new_page = page;
+			new_xmeta = xmeta;
 			goto requeue;
 		}
 
 		/* the interface is going down, skbs are purged */
-		dev_kfree_skb_any(skb);
+		page_pool_recycle_direct(pool, page);
 		return 0;
 	}
 
-	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
-	if (new_skb) {
-		skb_copy_queue_mapping(new_skb, skb);
-		skb_put(skb, len);
-		if (status & CPDMA_RX_VLAN_ENCAP)
-			cpsw_rx_vlan_encap(skb);
-		priv = netdev_priv(ndev);
-		if (priv->rx_ts_enabled)
-			cpts_rx_timestamp(cpsw->cpts, skb);
-		skb->protocol = eth_type_trans(skb, ndev);
-		netif_receive_skb(skb);
-		ndev->stats.rx_bytes += len;
-		ndev->stats.rx_packets++;
-		kmemleak_not_leak(new_skb);
-	} else {
+	new_page = cpsw_alloc_page(cpsw);
+	if (unlikely(!new_page)) {
+		new_page = page;
+		new_xmeta = xmeta;
 		ndev->stats.rx_dropped++;
-		new_skb = skb;
+		goto requeue;
 	}
+	new_xmeta = page_address(new_page);
+
+	priv = netdev_priv(ndev);
+	if (priv->xdp_prog) {
+		xdp_set_data_meta_invalid(&xdp);
+
+		if (status & CPDMA_RX_VLAN_ENCAP) {
+			xdp.data = (u8 *)xmeta + CPSW_HEADROOM +
+				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+			xdp.data_end = xdp.data + len -
+				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+		} else {
+			xdp.data = (u8 *)xmeta + CPSW_HEADROOM;
+			xdp.data_end = xdp.data + len;
+		}
+
+		xdp.data_hard_start = xmeta;
+		xdp.rxq = &priv->xdp_rxq[ch];
+
+		ret = cpsw_run_xdp(priv, &cpsw->rxv[ch], &xdp);
+		if (ret) {
+			if (ret == 2)
+				flush = 1;
+
+			goto requeue;
+		}
+
+		/* XDP prog might have changed packet data and boundaries */
+		len = xdp.data_end - xdp.data;
+		headroom = xdp.data - xdp.data_hard_start;
+	}
+
+	/* Build skb and pass it to networking stack if XDP off or XDP prog
+	 * returned XDP_PASS
+	 */
+	skb = build_skb(xmeta, cpsw_rxbuf_total_len(pkt_size));
+	if (!skb) {
+		ndev->stats.rx_dropped++;
+		page_pool_recycle_direct(pool, page);
+		goto requeue;
+	}
+
+	skb_reserve(skb, headroom);
+	skb_put(skb, len);
+	skb->dev = ndev;
+	if (status & CPDMA_RX_VLAN_ENCAP)
+		cpsw_rx_vlan_encap(skb);
+	if (priv->rx_ts_enabled)
+		cpts_rx_timestamp(cpsw->cpts, skb);
+	skb->protocol = eth_type_trans(skb, ndev);
+
+	/* as cpsw handles one packet per NAPI recycle page before increasing
+	 * refcounter, holding this in page pool cache
+	 */
+	page_pool_recycle_direct(pool, page);
+
+	/* it's decremented by netstack after what can be allocated
+	 * in cpsw_alloc_page()
+	 */
+	page_ref_inc(page);
+	netif_receive_skb(skb);
+
+	ndev->stats.rx_bytes += len;
+	ndev->stats.rx_packets++;
 
 requeue:
 	if (netif_dormant(ndev)) {
-		dev_kfree_skb_any(new_skb);
-		return 0;
+		page_pool_recycle_direct(pool, new_page);
+		return flush;
 	}
 
-	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
-	ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
-				skb_tailroom(new_skb), 0);
+	new_xmeta->ndev = ndev;
+	new_xmeta->ch = ch;
+	dma = new_page->dma_addr + CPSW_HEADROOM;
+	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, (void *)dma,
+				       pkt_size, 0);
 	if (WARN_ON(ret < 0))
-		dev_kfree_skb_any(new_skb);
+		page_pool_recycle_direct(pool, new_page);
+	else
+		kmemleak_not_leak(new_xmeta); /* Is it needed? */
 
-	return 0;
+	return flush;
 }
 
 static void cpsw_split_res(struct net_device *ndev)
@@ -1147,7 +1397,7 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 {
 	u32			ch_map;
-	int			num_rx, cur_budget, ch;
+	int			num_rx, cur_budget, ch, flush;
 	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
 	struct cpsw_vector	*rxv;
 
@@ -1163,8 +1413,12 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 		else
 			cur_budget = rxv->budget;
 
-		cpdma_chan_process(rxv->ch, &cur_budget);
+		flush = cpdma_chan_process(rxv->ch, &cur_budget);
 		num_rx += cur_budget;
+
+		if (flush)
+			xdp_do_flush_map();
+
 		if (num_rx >= budget)
 			break;
 	}
@@ -1180,10 +1434,15 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 {
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
-	int num_rx;
+	struct cpsw_vector *rxv;
+	int num_rx, flush;
 
 	num_rx = budget;
-	cpdma_chan_process(cpsw->rxv[0].ch, &num_rx);
+	rxv = &cpsw->rxv[0];
+	flush = cpdma_chan_process(rxv->ch, &num_rx);
+	if (flush)
+		xdp_do_flush_map();
+
 	if (num_rx < budget) {
 		napi_complete_done(napi_rx, num_rx);
 		writel(0xff, &cpsw->wr_regs->rx_en);
@@ -1516,9 +1775,9 @@ static void cpsw_get_ethtool_stats(struct net_device *ndev,
 	}
 }
 
-static inline int cpsw_tx_packet_submit(struct cpsw_priv *priv,
-					struct sk_buff *skb,
-					struct cpdma_chan *txch)
+static inline int cpsw_tx_submit_skb(struct cpsw_priv *priv,
+				     struct sk_buff *skb,
+				     struct cpdma_chan *txch)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 
@@ -1706,33 +1965,39 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 static int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
-	struct sk_buff *skb;
+	struct cpsw_meta_xdp *xmeta;
+	struct page_pool *pool;
+	struct page *page;
 	int ch_buf_num;
 	int ch, i, ret;
+	dma_addr_t dma;
 
+	pool = cpsw->rx_page_pool;
 	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
 		ch_buf_num = cpdma_chan_get_rx_buf_num(cpsw->rxv[ch].ch);
 		for (i = 0; i < ch_buf_num; i++) {
-			skb = __netdev_alloc_skb_ip_align(priv->ndev,
-							  cpsw->rx_packet_max,
-							  GFP_KERNEL);
-			if (!skb) {
-				cpsw_err(priv, ifup, "cannot allocate skb\n");
+			page = cpsw_alloc_page(cpsw);
+			if (!page) {
+				cpsw_err(priv, ifup, "allocate rx page err\n");
 				return -ENOMEM;
 			}
 
-			skb_set_queue_mapping(skb, ch);
-			ret = cpdma_chan_submit(cpsw->rxv[ch].ch, skb,
-						skb->data, skb_tailroom(skb),
-						0);
+			xmeta = page_address(page);
+			xmeta->ndev = priv->ndev;
+			xmeta->ch = ch;
+
+			dma = page->dma_addr + CPSW_HEADROOM;
+			ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, page,
+						       (void *)dma,
+						       cpsw->rx_packet_max, 0);
 			if (ret < 0) {
 				cpsw_err(priv, ifup,
 					 "cannot submit skb to channel %d rx, error %d\n",
 					 ch, ret);
-				kfree_skb(skb);
+				page_pool_recycle_direct(pool, page);
 				return ret;
 			}
-			kmemleak_not_leak(skb);
+			kmemleak_not_leak(xmeta); /* Is it needed? */
 		}
 
 		cpsw_info(priv, ifup, "ch %d rx, submitted %d descriptors\n",
@@ -2154,7 +2419,7 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
 
 	txch = cpsw->txv[q_idx].ch;
 	txq = netdev_get_tx_queue(ndev, q_idx);
-	ret = cpsw_tx_packet_submit(priv, skb, txch);
+	ret = cpsw_tx_submit_skb(priv, skb, txch);
 	if (unlikely(ret != 0)) {
 		cpsw_err(priv, tx_err, "desc submit failed\n");
 		goto fail;
@@ -2684,6 +2949,63 @@ static int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	}
 }
 
+static int cpsw_xdp_prog_setup(struct net_device *ndev, struct bpf_prog *prog)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct bpf_prog *old_prog;
+
+	if (!priv->xdp_prog && !prog)
+		return 0;
+
+	old_prog = xchg(&priv->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	return 0;
+}
+
+static int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return cpsw_xdp_prog_setup(ndev, bpf->prog);
+
+	case XDP_QUERY_PROG:
+		bpf->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
+			     struct xdp_frame **frames, u32 flags)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct xdp_frame *xdpf;
+	int i, drops = 0;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	for (i = 0; i < n; i++) {
+		xdpf = frames[i];
+		if (xdpf->len < CPSW_MIN_PACKET_SIZE) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+			continue;
+		}
+
+		if (cpsw_xdp_tx_frame(priv, xdpf))
+			drops++;
+	}
+
+	return n - drops;
+}
+
 static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_open		= cpsw_ndo_open,
 	.ndo_stop		= cpsw_ndo_stop,
@@ -2700,6 +3022,8 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= cpsw_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= cpsw_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc           = cpsw_ndo_setup_tc,
+	.ndo_bpf                = cpsw_ndo_bpf,
+	.ndo_xdp_xmit           = cpsw_ndo_xdp_xmit,
 };
 
 static int cpsw_get_regs_len(struct net_device *ndev)
@@ -2920,6 +3244,57 @@ static int cpsw_check_ch_settings(struct cpsw_common *cpsw,
 	return 0;
 }
 
+static void cpsw_xdp_rxq_unreg(struct cpsw_common *cpsw, int ch)
+{
+	struct cpsw_slave *slave;
+	struct cpsw_priv *priv;
+	int i;
+
+	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
+		if (!slave->ndev)
+			continue;
+
+		priv = netdev_priv(slave->ndev);
+		xdp_rxq_info_unreg(&priv->xdp_rxq[ch]);
+	}
+}
+
+static int cpsw_xdp_rxq_reg(struct cpsw_common *cpsw, int ch)
+{
+	struct cpsw_slave *slave;
+	struct cpsw_priv *priv;
+	int i, ret;
+
+	/* As channels are common for both ports sharing same queues, xdp_rxq
+	 * information also becomes shared and used by every packet on this
+	 * channel. But exch xdp_rxq holds link on netdev, which by the theory
+	 * can have different memory model and so, network device must hold it's
+	 * own set of rxq and thus both netdevs should be prepared
+	 */
+	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
+		if (!slave->ndev)
+			continue;
+
+		priv = netdev_priv(slave->ndev);
+
+		ret = xdp_rxq_info_reg(&priv->xdp_rxq[ch], priv->ndev, ch);
+		if (ret)
+			goto err;
+
+		ret = xdp_rxq_info_reg_mem_model(&priv->xdp_rxq[ch],
+						 MEM_TYPE_PAGE_POOL,
+						 cpsw->rx_page_pool);
+		if (ret)
+			goto err;
+	}
+
+	return ret;
+
+err:
+	cpsw_xdp_rxq_unreg(cpsw, ch);
+	return ret;
+}
+
 static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
@@ -2950,6 +3325,11 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx)
 		if (!vec[*ch].ch)
 			return -EINVAL;
 
+		if (rx && cpsw_xdp_rxq_reg(cpsw, *ch)) {
+			cpdma_chan_destroy(vec[*ch].ch);
+			return -EINVAL;
+		}
+
 		cpsw_info(priv, ifup, "created new %d %s channel\n", *ch,
 			  (rx ? "rx" : "tx"));
 		(*ch)++;
@@ -2958,6 +3338,9 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx)
 	while (*ch > ch_num) {
 		(*ch)--;
 
+		if (rx)
+			cpsw_xdp_rxq_unreg(cpsw, *ch);
+
 		ret = cpdma_chan_destroy(vec[*ch].ch);
 		if (ret)
 			return ret;
@@ -3446,6 +3829,15 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
 
+	ret = xdp_rxq_info_reg(&priv_sl2->xdp_rxq[0], ndev, 0);
+	if (ret)
+		return ret;
+
+	ret = xdp_rxq_info_reg_mem_model(&priv_sl2->xdp_rxq[0],
+					 MEM_TYPE_PAGE_SHARED, NULL);
+	if (ret)
+		return ret;
+
 	/* register the network device */
 	SET_NETDEV_DEV(ndev, cpsw->dev);
 	ret = register_netdev(ndev);
@@ -3517,6 +3909,12 @@ static int cpsw_probe(struct platform_device *pdev)
 		goto clean_ndev_ret;
 	}
 
+	cpsw->rx_page_pool = cpsw_create_rx_pool(cpsw);
+	if (IS_ERR(cpsw->rx_page_pool)) {
+		dev_err(&pdev->dev, "create rx page pool\n");
+		goto clean_ndev_ret;
+	}
+
 	/*
 	 * This may be required here for child devices.
 	 */
@@ -3663,20 +4061,31 @@ static int cpsw_probe(struct platform_device *pdev)
 		cpsw->quirk_irq = 1;
 
 	ch = cpsw->quirk_irq ? 0 : 7;
-	cpsw->txv[0].ch = cpdma_chan_create(cpsw->dma, ch, cpsw_tx_handler, 0);
+	cpsw->txv[0].ch =
+	    cpdma_chan_create(cpsw->dma, ch, cpsw_tx_handler, 0);
 	if (IS_ERR(cpsw->txv[0].ch)) {
 		dev_err(priv->dev, "error initializing tx dma channel\n");
 		ret = PTR_ERR(cpsw->txv[0].ch);
 		goto clean_dma_ret;
 	}
 
-	cpsw->rxv[0].ch = cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
+	cpsw->rxv[0].ch =
+	    cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
 	if (IS_ERR(cpsw->rxv[0].ch)) {
 		dev_err(priv->dev, "error initializing rx dma channel\n");
 		ret = PTR_ERR(cpsw->rxv[0].ch);
 		goto clean_dma_ret;
 	}
 
+	ret = xdp_rxq_info_reg(&priv->xdp_rxq[0], ndev, 0);
+	if (ret)
+		goto clean_dma_ret;
+
+	ret = xdp_rxq_info_reg_mem_model(&priv->xdp_rxq[0], MEM_TYPE_PAGE_POOL,
+					 cpsw->rx_page_pool);
+	if (ret)
+		goto clean_dma_ret;
+
 	ale_params.dev			= &pdev->dev;
 	ale_params.ale_ageout		= ale_ageout;
 	ale_params.ale_entries		= data->ale_entries;
@@ -3786,6 +4195,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 clean_runtime_disable_ret:
 	pm_runtime_disable(&pdev->dev);
+	page_pool_destroy(cpsw->rx_page_pool);
 clean_ndev_ret:
 	free_netdev(priv->ndev);
 	return ret;
@@ -3809,6 +4219,7 @@ static int cpsw_remove(struct platform_device *pdev)
 
 	cpts_release(cpsw->cpts);
 	cpdma_ctlr_destroy(cpsw->dma);
+	page_pool_destroy(cpsw->rx_page_pool);
 	cpsw_remove_dt(pdev);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.17.1
