Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45796 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733164AbfDQRuM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 13:50:12 -0400
Received: by mail-lj1-f196.google.com with SMTP id y6so23235940ljd.12
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 10:50:10 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [RFC PATCH 2/3] net: ethernet: ti: davinci_cpdma: return handler status
Date: Wed, 17 Apr 2019 20:49:41 +0300
Message-Id: <20190417174942.11811-3-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: grygorii.strashko@ti.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ilias.apalodimas@linaro.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, ast@kernel.org, aniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

This change is needed to return flush status of rx handler for
flushing redirected xdp frames after processing channel packets.
Do it as separate patch for simplicity.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw.c          | 25 ++++++++++++-------
 drivers/net/ethernet/ti/davinci_cpdma.c | 33 +++++++++++++++----------
 drivers/net/ethernet/ti/davinci_cpdma.h |  4 +--
 drivers/net/ethernet/ti/davinci_emac.c  | 18 ++++++++------
 4 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index a591583d120e..0fd1b3909333 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -838,7 +838,7 @@ static void cpsw_intr_disable(struct cpsw_common *cpsw)
 	return;
 }
 
-static void cpsw_tx_handler(void *token, int len, int status)
+static int cpsw_tx_handler(void *token, int len, int status)
 {
 	struct netdev_queue	*txq;
 	struct sk_buff		*skb = token;
@@ -856,6 +856,7 @@ static void cpsw_tx_handler(void *token, int len, int status)
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);
+	return 0;
 }
 
 static void cpsw_rx_vlan_encap(struct sk_buff *skb)
@@ -901,7 +902,7 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
 	}
 }
 
-static void cpsw_rx_handler(void *token, int len, int status)
+static int cpsw_rx_handler(void *token, int len, int status)
 {
 	struct cpdma_chan	*ch;
 	struct sk_buff		*skb = token;
@@ -935,7 +936,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 
 		/* the interface is going down, skbs are purged */
 		dev_kfree_skb_any(skb);
-		return;
+		return 0;
 	}
 
 	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
@@ -960,7 +961,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 requeue:
 	if (netif_dormant(ndev)) {
 		dev_kfree_skb_any(new_skb);
-		return;
+		return 0;
 	}
 
 	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
@@ -968,6 +969,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 				skb_tailroom(new_skb), 0);
 	if (WARN_ON(ret < 0))
 		dev_kfree_skb_any(new_skb);
+
+	return 0;
 }
 
 static void cpsw_split_res(struct net_device *ndev)
@@ -1108,7 +1111,8 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 		else
 			cur_budget = txv->budget;
 
-		num_tx += cpdma_chan_process(txv->ch, cur_budget);
+		cpdma_chan_process(txv->ch, &cur_budget);
+		num_tx += cur_budget;
 		if (num_tx >= budget)
 			break;
 	}
@@ -1126,7 +1130,8 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_tx);
 	int num_tx;
 
-	num_tx = cpdma_chan_process(cpsw->txv[0].ch, budget);
+	num_tx = budget;
+	cpdma_chan_process(cpsw->txv[0].ch, &num_tx);
 	if (num_tx < budget) {
 		napi_complete(napi_tx);
 		writel(0xff, &cpsw->wr_regs->tx_en);
@@ -1158,7 +1163,8 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 		else
 			cur_budget = rxv->budget;
 
-		num_rx += cpdma_chan_process(rxv->ch, cur_budget);
+		cpdma_chan_process(rxv->ch, &cur_budget);
+		num_rx += cur_budget;
 		if (num_rx >= budget)
 			break;
 	}
@@ -1176,7 +1182,8 @@ static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
 	int num_rx;
 
-	num_rx = cpdma_chan_process(cpsw->rxv[0].ch, budget);
+	num_rx = budget;
+	cpdma_chan_process(cpsw->rxv[0].ch, &num_rx);
 	if (num_rx < budget) {
 		napi_complete_done(napi_rx, num_rx);
 		writel(0xff, &cpsw->wr_regs->rx_en);
@@ -2916,8 +2923,8 @@ static int cpsw_check_ch_settings(struct cpsw_common *cpsw,
 static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
-	void (*handler)(void *, int, int);
 	struct netdev_queue *queue;
+	cpdma_handler_fn handler;
 	struct cpsw_vector *vec;
 	int ret, *ch, vch;
 
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 96ec1d9d8f47..95221721ac26 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1161,15 +1161,16 @@ bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
 }
 EXPORT_SYMBOL_GPL(cpdma_check_free_tx_desc);
 
-static void __cpdma_chan_free(struct cpdma_chan *chan,
-			      struct cpdma_desc __iomem *desc,
-			      int outlen, int status)
+static int __cpdma_chan_free(struct cpdma_chan *chan,
+			     struct cpdma_desc __iomem *desc,
+			     int outlen, int status)
 {
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
 	struct cpdma_desc_pool		*pool = ctlr->pool;
 	dma_addr_t			buff_dma;
 	int				origlen;
 	uintptr_t			token;
+	int				ret;
 
 	token      = desc_read(desc, sw_token);
 	origlen    = desc_read(desc, sw_len);
@@ -1184,7 +1185,9 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
 	}
 
 	cpdma_desc_free(pool, desc, 1);
-	(*chan->handler)((void *)token, outlen, status);
+	ret = (*chan->handler)((void *)token, outlen, status);
+
+	return ret;
 }
 
 static int __cpdma_chan_process(struct cpdma_chan *chan)
@@ -1196,13 +1199,14 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	struct cpdma_desc_pool		*pool = ctlr->pool;
 	dma_addr_t			desc_dma;
 	unsigned long			flags;
+	int				ret;
 
 	spin_lock_irqsave(&chan->lock, flags);
 
 	desc = chan->head;
 	if (!desc) {
 		chan->stats.empty_dequeue++;
-		status = -ENOENT;
+		ret = -ENOENT;
 		goto unlock_ret;
 	}
 	desc_dma = desc_phys(pool, desc);
@@ -1211,7 +1215,7 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	outlen	= status & 0x7ff;
 	if (status & CPDMA_DESC_OWNER) {
 		chan->stats.busy_dequeue++;
-		status = -EBUSY;
+		ret = -EBUSY;
 		goto unlock_ret;
 	}
 
@@ -1237,28 +1241,31 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	else
 		cb_status = status;
 
-	__cpdma_chan_free(chan, desc, outlen, cb_status);
-	return status;
+	ret = __cpdma_chan_free(chan, desc, outlen, cb_status);
+	return ret;
 
 unlock_ret:
 	spin_unlock_irqrestore(&chan->lock, flags);
-	return status;
+	return ret;
 }
 
-int cpdma_chan_process(struct cpdma_chan *chan, int quota)
+int cpdma_chan_process(struct cpdma_chan *chan, int *quota)
 {
-	int used = 0, ret = 0;
+	int used = 0, ret = 0, res = 0;
 
 	if (chan->state != CPDMA_STATE_ACTIVE)
 		return -EINVAL;
 
-	while (used < quota) {
+	while (used < *quota) {
 		ret = __cpdma_chan_process(chan);
 		if (ret < 0)
 			break;
+		res += ret;
 		used++;
 	}
-	return used;
+
+	*quota = used;
+	return res;
 }
 EXPORT_SYMBOL_GPL(cpdma_chan_process);
 
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index 20e4d43df6d1..6ae86b1ed23c 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -68,7 +68,7 @@ struct cpdma_chan_stats {
 struct cpdma_ctlr;
 struct cpdma_chan;
 
-typedef void (*cpdma_handler_fn)(void *token, int len, int status);
+typedef int (*cpdma_handler_fn)(void *token, int len, int status);
 
 struct cpdma_ctlr *cpdma_ctlr_create(struct cpdma_params *params);
 int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr);
@@ -88,7 +88,7 @@ int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token, void *data,
 			     int len, int directed);
 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		      int len, int directed);
-int cpdma_chan_process(struct cpdma_chan *chan, int quota);
+int cpdma_chan_process(struct cpdma_chan *chan, int *quota);
 
 int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable);
 void cpdma_ctlr_eoi(struct cpdma_ctlr *ctlr, u32 value);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 57450b174fc4..65211954436f 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -874,7 +874,7 @@ static struct sk_buff *emac_rx_alloc(struct emac_priv *priv)
 	return skb;
 }
 
-static void emac_rx_handler(void *token, int len, int status)
+static int emac_rx_handler(void *token, int len, int status)
 {
 	struct sk_buff		*skb = token;
 	struct net_device	*ndev = skb->dev;
@@ -885,7 +885,7 @@ static void emac_rx_handler(void *token, int len, int status)
 	/* free and bail if we are shutting down */
 	if (unlikely(!netif_running(ndev))) {
 		dev_kfree_skb_any(skb);
-		return;
+		return 0;
 	}
 
 	/* recycle on receive error */
@@ -906,7 +906,7 @@ static void emac_rx_handler(void *token, int len, int status)
 	if (!skb) {
 		if (netif_msg_rx_err(priv) && net_ratelimit())
 			dev_err(emac_dev, "failed rx buffer alloc\n");
-		return;
+		return 0;
 	}
 
 recycle:
@@ -916,9 +916,10 @@ static void emac_rx_handler(void *token, int len, int status)
 	WARN_ON(ret == -ENOMEM);
 	if (unlikely(ret < 0))
 		dev_kfree_skb_any(skb);
+	return 0;
 }
 
-static void emac_tx_handler(void *token, int len, int status)
+static int emac_tx_handler(void *token, int len, int status)
 {
 	struct sk_buff		*skb = token;
 	struct net_device	*ndev = skb->dev;
@@ -931,6 +932,8 @@ static void emac_tx_handler(void *token, int len, int status)
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);
+
+	return 0;
 }
 
 /**
@@ -1251,8 +1254,8 @@ static int emac_poll(struct napi_struct *napi, int budget)
 		mask = EMAC_DM646X_MAC_IN_VECTOR_TX_INT_VEC;
 
 	if (status & mask) {
-		num_tx_pkts = cpdma_chan_process(priv->txchan,
-					      EMAC_DEF_TX_MAX_SERVICE);
+		num_tx_pkts = EMAC_DEF_TX_MAX_SERVICE;
+		cpdma_chan_process(priv->txchan, &num_tx_pkts);
 	} /* TX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_RX_INT_VEC;
@@ -1261,7 +1264,8 @@ static int emac_poll(struct napi_struct *napi, int budget)
 		mask = EMAC_DM646X_MAC_IN_VECTOR_RX_INT_VEC;
 
 	if (status & mask) {
-		num_rx_pkts = cpdma_chan_process(priv->rxchan, budget);
+		num_rx_pkts = budget;
+		cpdma_chan_process(priv->rxchan, &num_rx_pkts);
 	} /* RX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_HOST_INT;
-- 
2.17.1
