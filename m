Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:40138 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733307AbfDQWrI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 18:47:08 -0400
Received: by mail-vs1-f66.google.com with SMTP id f22so111559vso.7
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 15:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org> <20190417174942.11811-4-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190417174942.11811-4-ivan.khoronzhuk@linaro.org>
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 17 Apr 2019 15:46:56 -0700
Message-ID: <CAJpBn1y0odvL97-kP5yzKC+tN=fx178nxigfBfDwXhRhPRvDuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] net: ethernet: ti: cpsw: add XDP support
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: grygorii.strashko@ti.com, linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, ilias.apalodimas@linaro.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, aniel@iogearbox.net, John Fastabend <john.fastabend@gmail.com>

On Wed, 17 Apr 2019 20:49:42 +0300, Ivan Khoronzhuk wrote:
> Add XDP support based on rx page_pool allocator, one frame per page.
> This patch was verified with af_xdp and xdp drop. Page pool allocator
> is used with assumption that only one rx_handler is running
> simultaneously. DMA map/unmap is reused from page pool despite there
> is no need to map whole page.
>
> Due to specific of cpsw, the same TX/RX handler can be used by 2
> network devices, so special fields in buffer are added to identify
> an interface the frame is destined to.
>
> XDP prog is common for all channels till appropriate changes are added
> in XDP infrastructure.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

> @@ -902,22 +947,169 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
>       }
>  }
>
> +static inline int cpsw_tx_submit_xdpf(struct cpsw_priv *priv,
> +                                   struct xdp_frame *xdpf,
> +                                   struct cpdma_chan *txch)
> +{
> +     struct cpsw_common *cpsw = priv->cpsw;
> +
> +     return cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf), xdpf->data,
> +                              xdpf->len,
> +                              priv->emac_port + cpsw->data.dual_emac);
> +}
> +
> +static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *frame)
> +{
> +     struct cpsw_common *cpsw = priv->cpsw;
> +     struct cpsw_meta_xdp *xmeta;
> +     struct cpdma_chan *txch;
> +     int ret = 0;
> +
> +     frame->metasize = sizeof(struct cpsw_meta_xdp);
> +     xmeta = frame->data - frame->metasize;
> +     xmeta->ndev = priv->ndev;
> +     xmeta->ch = 0;
> +
> +     txch = cpsw->txv[0].ch;
> +     ret = cpsw_tx_submit_xdpf(priv, frame, txch);
> +     if (ret) {
> +             xdp_return_frame_rx_napi(frame);
> +             ret = -1;
> +     }
> +
> +     /* If there is no more tx desc left free then we need to
> +      * tell the kernel to stop sending us tx frames.
> +      */

So you're using the same TX ring for XDP and stack?  How does that
work?  The stack's TX ring has a lock, and can be used from any CPU,
while XDP TX rings are per-PCU, no?

> +     if (unlikely(!cpdma_check_free_tx_desc(txch))) {
> +             struct netdev_queue *txq = netdev_get_tx_queue(priv->ndev, 0);
> +
> +             netif_tx_stop_queue(txq);
> +
> +             /* Barrier, so that stop_queue visible to other cpus */
> +             smp_mb__after_atomic();
> +
> +             if (cpdma_check_free_tx_desc(txch))
> +                     netif_tx_wake_queue(txq);
> +     }
> +
> +     return ret;
> +}

> +static struct page_pool *cpsw_create_rx_pool(struct cpsw_common *cpsw)
> +{
> +     struct page_pool_params pp_params = { 0 };
> +
> +     pp_params.order = 0;
> +     pp_params.flags = PP_FLAG_DMA_MAP;
> +
> +      /* set it to number of descriptors to be cached from init? */
> +     pp_params.pool_size = descs_pool_size;
> +     pp_params.nid = NUMA_NO_NODE; /* no numa */
> +     pp_params.dma_dir = DMA_FROM_DEVICE;

DMA_FROM_DEVICE looks suspicious if you support TX, shouldn't this be
BIDIRECTIONAL?

> +     pp_params.dev = cpsw->dev;
> +
> +     return page_pool_create(&pp_params);
> +}

>  static int cpsw_rx_handler(void *token, int len, int status)
>  {
> -     struct cpdma_chan       *ch;
> -     struct sk_buff          *skb = token;
> -     struct sk_buff          *new_skb;
> -     struct net_device       *ndev = skb->dev;
> -     int                     ret = 0, port;
> -     struct cpsw_common      *cpsw = ndev_to_cpsw(ndev);
> +     struct page             *new_page, *page = token;
> +     struct cpsw_meta_xdp    *new_xmeta, *xmeta = page_address(page);
> +     struct cpsw_common      *cpsw = ndev_to_cpsw(xmeta->ndev);
> +     int                     pkt_size = cpsw->rx_packet_max;
> +     int                     ret = 0, port, ch = xmeta->ch;
> +     struct page_pool        *pool = cpsw->rx_page_pool;
> +     int                     headroom = CPSW_HEADROOM;
> +     struct net_device       *ndev = xmeta->ndev;
> +     int                     flush = 0;
>       struct cpsw_priv        *priv;
> +     struct sk_buff          *skb;
> +     struct xdp_buff         xdp;
> +     dma_addr_t              dma;
>
>       if (cpsw->data.dual_emac) {
>               port = CPDMA_RX_SOURCE_PORT(status);
> -             if (port) {
> +             if (port)
>                       ndev = cpsw->slaves[--port].ndev;
> -                     skb->dev = ndev;
> -             }
>       }
>
>       if (unlikely(status < 0) || unlikely(!netif_running(ndev))) {
> @@ -930,47 +1122,105 @@ static int cpsw_rx_handler(void *token, int len, int status)
>                        * in reducing of the number of rx descriptor in
>                        * DMA engine, requeue skb back to cpdma.
>                        */
> -                     new_skb = skb;
> +                     new_page = page;
> +                     new_xmeta = xmeta;
>                       goto requeue;
>               }
>
>               /* the interface is going down, skbs are purged */
> -             dev_kfree_skb_any(skb);
> +             page_pool_recycle_direct(pool, page);
>               return 0;
>       }
>
> -     new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
> -     if (new_skb) {
> -             skb_copy_queue_mapping(new_skb, skb);
> -             skb_put(skb, len);
> -             if (status & CPDMA_RX_VLAN_ENCAP)
> -                     cpsw_rx_vlan_encap(skb);
> -             priv = netdev_priv(ndev);
> -             if (priv->rx_ts_enabled)
> -                     cpts_rx_timestamp(cpsw->cpts, skb);
> -             skb->protocol = eth_type_trans(skb, ndev);
> -             netif_receive_skb(skb);
> -             ndev->stats.rx_bytes += len;
> -             ndev->stats.rx_packets++;
> -             kmemleak_not_leak(new_skb);
> -     } else {
> +     new_page = cpsw_alloc_page(cpsw);
> +     if (unlikely(!new_page)) {
> +             new_page = page;
> +             new_xmeta = xmeta;
>               ndev->stats.rx_dropped++;
> -             new_skb = skb;
> +             goto requeue;
>       }
> +     new_xmeta = page_address(new_page);
> +
> +     priv = netdev_priv(ndev);
> +     if (priv->xdp_prog) {
> +             xdp_set_data_meta_invalid(&xdp);
> +
> +             if (status & CPDMA_RX_VLAN_ENCAP) {
> +                     xdp.data = (u8 *)xmeta + CPSW_HEADROOM +
> +                                CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> +                     xdp.data_end = xdp.data + len -
> +                                    CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> +             } else {
> +                     xdp.data = (u8 *)xmeta + CPSW_HEADROOM;
> +                     xdp.data_end = xdp.data + len;
> +             }
> +
> +             xdp.data_hard_start = xmeta;
> +             xdp.rxq = &priv->xdp_rxq[ch];
> +
> +             ret = cpsw_run_xdp(priv, &cpsw->rxv[ch], &xdp);
> +             if (ret) {
> +                     if (ret == 2)
> +                             flush = 1;
> +
> +                     goto requeue;
> +             }
> +
> +             /* XDP prog might have changed packet data and boundaries */
> +             len = xdp.data_end - xdp.data;
> +             headroom = xdp.data - xdp.data_hard_start;
> +     }
> +
> +     /* Build skb and pass it to networking stack if XDP off or XDP prog
> +      * returned XDP_PASS
> +      */
> +     skb = build_skb(xmeta, cpsw_rxbuf_total_len(pkt_size));
> +     if (!skb) {
> +             ndev->stats.rx_dropped++;
> +             page_pool_recycle_direct(pool, page);
> +             goto requeue;
> +     }
> +
> +     skb_reserve(skb, headroom);
> +     skb_put(skb, len);
> +     skb->dev = ndev;
> +     if (status & CPDMA_RX_VLAN_ENCAP)
> +             cpsw_rx_vlan_encap(skb);
> +     if (priv->rx_ts_enabled)
> +             cpts_rx_timestamp(cpsw->cpts, skb);
> +     skb->protocol = eth_type_trans(skb, ndev);
> +
> +     /* as cpsw handles one packet per NAPI recycle page before increasing
> +      * refcounter, holding this in page pool cache
> +      */
> +     page_pool_recycle_direct(pool, page);
> +
> +     /* it's decremented by netstack after what can be allocated
> +      * in cpsw_alloc_page()
> +      */
> +     page_ref_inc(page);
> +     netif_receive_skb(skb);
> +
> +     ndev->stats.rx_bytes += len;
> +     ndev->stats.rx_packets++;
>
>  requeue:
>       if (netif_dormant(ndev)) {
> -             dev_kfree_skb_any(new_skb);
> -             return 0;
> +             page_pool_recycle_direct(pool, new_page);
> +             return flush;
>       }
>
> -     ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
> -     ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
> -                             skb_tailroom(new_skb), 0);
> +     new_xmeta->ndev = ndev;
> +     new_xmeta->ch = ch;
> +     dma = new_page->dma_addr + CPSW_HEADROOM;
> +     ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, (void *)dma,
> +                                    pkt_size, 0);
>       if (WARN_ON(ret < 0))
> -             dev_kfree_skb_any(new_skb);
> +             page_pool_recycle_direct(pool, new_page);
> +     else
> +             kmemleak_not_leak(new_xmeta); /* Is it needed? */
>
> -     return 0;
> +     return flush;
>  }

On a quick scan I don't see DMA syncs, does the DMA driver takes care
of making sure the DMA sync happens?

>  static void cpsw_split_res(struct net_device *ndev)

> @@ -2684,6 +2949,63 @@ static int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>       }
>  }
>
> +static int cpsw_xdp_prog_setup(struct net_device *ndev, struct bpf_prog *prog)
> +{
> +     struct cpsw_priv *priv = netdev_priv(ndev);
> +     struct bpf_prog *old_prog;
> +
> +     if (!priv->xdp_prog && !prog)
> +             return 0;
> +
> +     old_prog = xchg(&priv->xdp_prog, prog);
> +     if (old_prog)
> +             bpf_prog_put(old_prog);
> +
> +     return 0;
> +}
> +
> +static int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
> +{
> +     struct cpsw_priv *priv = netdev_priv(ndev);
> +
> +     switch (bpf->command) {
> +     case XDP_SETUP_PROG:
> +             return cpsw_xdp_prog_setup(ndev, bpf->prog);
> +
> +     case XDP_QUERY_PROG:
> +             bpf->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;

Consider using xdp_attachment_query() and friends.  This way you'll
also return the flags.

> +             return 0;
> +
> +     default:
> +             return -EINVAL;
> +     }
> +}
> +
> +static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
> +                          struct xdp_frame **frames, u32 flags)
> +{
> +     struct cpsw_priv *priv = netdev_priv(ndev);
> +     struct xdp_frame *xdpf;
> +     int i, drops = 0;
> +
> +     if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> +             return -EINVAL;
> +
> +     for (i = 0; i < n; i++) {
> +             xdpf = frames[i];
> +             if (xdpf->len < CPSW_MIN_PACKET_SIZE) {
> +                     xdp_return_frame_rx_napi(xdpf);
> +                     drops++;
> +                     continue;
> +             }
> +
> +             if (cpsw_xdp_tx_frame(priv, xdpf))
> +                     drops++;
> +     }
> +
> +     return n - drops;
> +}
> +
>  static const struct net_device_ops cpsw_netdev_ops = {
>       .ndo_open               = cpsw_ndo_open,
>       .ndo_stop               = cpsw_ndo_stop,
> @@ -2700,6 +3022,8 @@ static const struct net_device_ops cpsw_netdev_ops = {
>       .ndo_vlan_rx_add_vid    = cpsw_ndo_vlan_rx_add_vid,
>       .ndo_vlan_rx_kill_vid   = cpsw_ndo_vlan_rx_kill_vid,
>       .ndo_setup_tc           = cpsw_ndo_setup_tc,
> +     .ndo_bpf                = cpsw_ndo_bpf,
> +     .ndo_xdp_xmit           = cpsw_ndo_xdp_xmit,
>  };
>
>  static int cpsw_get_regs_len(struct net_device *ndev)
> @@ -2920,6 +3244,57 @@ static int cpsw_check_ch_settings(struct cpsw_common *cpsw,
>       return 0;
>  }
>
> +static void cpsw_xdp_rxq_unreg(struct cpsw_common *cpsw, int ch)
> +{
> +     struct cpsw_slave *slave;
> +     struct cpsw_priv *priv;
> +     int i;
> +
> +     for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
> +             if (!slave->ndev)
> +                     continue;
> +
> +             priv = netdev_priv(slave->ndev);
> +             xdp_rxq_info_unreg(&priv->xdp_rxq[ch]);
> +     }
> +}
> +
> +static int cpsw_xdp_rxq_reg(struct cpsw_common *cpsw, int ch)
> +{
> +     struct cpsw_slave *slave;
> +     struct cpsw_priv *priv;
> +     int i, ret;
> +
> +     /* As channels are common for both ports sharing same queues, xdp_rxq
> +      * information also becomes shared and used by every packet on this
> +      * channel. But exch xdp_rxq holds link on netdev, which by the theory
> +      * can have different memory model and so, network device must hold it's
> +      * own set of rxq and thus both netdevs should be prepared
> +      */
> +     for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
> +             if (!slave->ndev)
> +                     continue;
> +
> +             priv = netdev_priv(slave->ndev);
> +
> +             ret = xdp_rxq_info_reg(&priv->xdp_rxq[ch], priv->ndev, ch);
> +             if (ret)
> +                     goto err;
> +
> +             ret = xdp_rxq_info_reg_mem_model(&priv->xdp_rxq[ch],
> +                                              MEM_TYPE_PAGE_POOL,
> +                                              cpsw->rx_page_pool);
> +             if (ret)
> +                     goto err;
> +     }
> +
> +     return ret;
> +
> +err:
> +     cpsw_xdp_rxq_unreg(cpsw, ch);
> +     return ret;
> +}
> +
>  static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx)
>  {
>       struct cpsw_common *cpsw = priv->cpsw;
> @@ -2950,6 +3325,11 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx)
>               if (!vec[*ch].ch)
>                       return -EINVAL;
>
> +             if (rx && cpsw_xdp_rxq_reg(cpsw, *ch)) {
> +                     cpdma_chan_destroy(vec[*ch].ch);
> +                     return -EINVAL;
> +             }
> +
>               cpsw_info(priv, ifup, "created new %d %s channel\n", *ch,
>                         (rx ? "rx" : "tx"));
>               (*ch)++;
> @@ -2958,6 +3338,9 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx)
>       while (*ch > ch_num) {
>               (*ch)--;
>
> +             if (rx)
> +                     cpsw_xdp_rxq_unreg(cpsw, *ch);
> +
>               ret = cpdma_chan_destroy(vec[*ch].ch);
>               if (ret)
>                       return ret;
> @@ -3446,6 +3829,15 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
>       ndev->netdev_ops = &cpsw_netdev_ops;
>       ndev->ethtool_ops = &cpsw_ethtool_ops;
>
> +     ret = xdp_rxq_info_reg(&priv_sl2->xdp_rxq[0], ndev, 0);
> +     if (ret)
> +             return ret;
> +
> +     ret = xdp_rxq_info_reg_mem_model(&priv_sl2->xdp_rxq[0],
> +                                      MEM_TYPE_PAGE_SHARED, NULL);
> +     if (ret)
> +             return ret;
> +
>       /* register the network device */
>       SET_NETDEV_DEV(ndev, cpsw->dev);
>       ret = register_netdev(ndev);
> @@ -3517,6 +3909,12 @@ static int cpsw_probe(struct platform_device *pdev)
>               goto clean_ndev_ret;
>       }
>
> +     cpsw->rx_page_pool = cpsw_create_rx_pool(cpsw);
> +     if (IS_ERR(cpsw->rx_page_pool)) {
> +             dev_err(&pdev->dev, "create rx page pool\n");
> +             goto clean_ndev_ret;
> +     }
> +
>       /*
>        * This may be required here for child devices.
>        */
> @@ -3663,20 +4061,31 @@ static int cpsw_probe(struct platform_device *pdev)
>               cpsw->quirk_irq = 1;
>
>       ch = cpsw->quirk_irq ? 0 : 7;
> -     cpsw->txv[0].ch = cpdma_chan_create(cpsw->dma, ch, cpsw_tx_handler, 0);
> +     cpsw->txv[0].ch =
> +         cpdma_chan_create(cpsw->dma, ch, cpsw_tx_handler, 0);
>       if (IS_ERR(cpsw->txv[0].ch)) {
>               dev_err(priv->dev, "error initializing tx dma channel\n");
>               ret = PTR_ERR(cpsw->txv[0].ch);
>               goto clean_dma_ret;
>       }
>
> -     cpsw->rxv[0].ch = cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
> +     cpsw->rxv[0].ch =
> +         cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
>       if (IS_ERR(cpsw->rxv[0].ch)) {
>               dev_err(priv->dev, "error initializing rx dma channel\n");
>               ret = PTR_ERR(cpsw->rxv[0].ch);
>               goto clean_dma_ret;
>       }
>
> +     ret = xdp_rxq_info_reg(&priv->xdp_rxq[0], ndev, 0);
> +     if (ret)
> +             goto clean_dma_ret;
> +
> +     ret = xdp_rxq_info_reg_mem_model(&priv->xdp_rxq[0], MEM_TYPE_PAGE_POOL,
> +                                      cpsw->rx_page_pool);
> +     if (ret)
> +             goto clean_dma_ret;
> +
>       ale_params.dev                  = &pdev->dev;
>       ale_params.ale_ageout           = ale_ageout;
>       ale_params.ale_entries          = data->ale_entries;

I think you need to unreg the mem model somewhere on the failure path,
no?


> @@ -3786,6 +4195,7 @@ static int cpsw_probe(struct platform_device *pdev)
>       pm_runtime_put_sync(&pdev->dev);
>  clean_runtime_disable_ret:
>       pm_runtime_disable(&pdev->dev);
> +     page_pool_destroy(cpsw->rx_page_pool);
>  clean_ndev_ret:
>       free_netdev(priv->ndev);
>       return ret;
> @@ -3809,6 +4219,7 @@ static int cpsw_remove(struct platform_device *pdev)
>
>       cpts_release(cpsw->cpts);
>       cpdma_ctlr_destroy(cpsw->dma);
> +     page_pool_destroy(cpsw->rx_page_pool);
>       cpsw_remove_dt(pdev);
>       pm_runtime_put_sync(&pdev->dev);
>       pm_runtime_disable(&pdev->dev);
