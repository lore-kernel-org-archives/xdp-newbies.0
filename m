Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41708 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbfDRJkP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 Apr 2019 05:40:15 -0400
Received: by mail-lf1-f68.google.com with SMTP id t30so1109766lfd.8
        for <xdp-newbies@vger.kernel.org>; Thu, 18 Apr 2019 02:40:13 -0700 (PDT)
Date: Thu, 18 Apr 2019 12:40:10 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [RFC PATCH 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190418094008.GB27879@khorivan>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
 <20190417174942.11811-4-ivan.khoronzhuk@linaro.org>
 <CAJpBn1y0odvL97-kP5yzKC+tN=fx178nxigfBfDwXhRhPRvDuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJpBn1y0odvL97-kP5yzKC+tN=fx178nxigfBfDwXhRhPRvDuQ@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: grygorii.strashko@ti.com, linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, ilias.apalodimas@linaro.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, aniel@iogearbox.net, John Fastabend <john.fastabend@gmail.com>

On Wed, Apr 17, 2019 at 03:46:56PM -0700, Jakub Kicinski wrote:
>On Wed, 17 Apr 2019 20:49:42 +0300, Ivan Khoronzhuk wrote:
>> Add XDP support based on rx page_pool allocator, one frame per page.
>> This patch was verified with af_xdp and xdp drop. Page pool allocator
>> is used with assumption that only one rx_handler is running
>> simultaneously. DMA map/unmap is reused from page pool despite there
>> is no need to map whole page.
>>
>> Due to specific of cpsw, the same TX/RX handler can be used by 2
>> network devices, so special fields in buffer are added to identify
>> an interface the frame is destined to.
>>
>> XDP prog is common for all channels till appropriate changes are added
>> in XDP infrastructure.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>
>> @@ -902,22 +947,169 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
>>       }
>>  }
>>
>> +static inline int cpsw_tx_submit_xdpf(struct cpsw_priv *priv,
>> +                                   struct xdp_frame *xdpf,
>> +                                   struct cpdma_chan *txch)
>> +{
>> +     struct cpsw_common *cpsw = priv->cpsw;
>> +
>> +     return cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf), xdpf->data,
>> +                              xdpf->len,
>> +                              priv->emac_port + cpsw->data.dual_emac);
>> +}
>> +
>> +static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *frame)
>> +{
>> +     struct cpsw_common *cpsw = priv->cpsw;
>> +     struct cpsw_meta_xdp *xmeta;
>> +     struct cpdma_chan *txch;
>> +     int ret = 0;
>> +
>> +     frame->metasize = sizeof(struct cpsw_meta_xdp);
>> +     xmeta = frame->data - frame->metasize;
>> +     xmeta->ndev = priv->ndev;
>> +     xmeta->ch = 0;
>> +
>> +     txch = cpsw->txv[0].ch;
>> +     ret = cpsw_tx_submit_xdpf(priv, frame, txch);
>> +     if (ret) {
>> +             xdp_return_frame_rx_napi(frame);
>> +             ret = -1;
>> +     }
>> +
>> +     /* If there is no more tx desc left free then we need to
>> +      * tell the kernel to stop sending us tx frames.
>> +      */
>
>So you're using the same TX ring for XDP and stack?  How does that
Yes.

>work?  The stack's TX ring has a lock, and can be used from any CPU,
>while XDP TX rings are per-PCU, no?
Yes and no.
am572 has more queues then CPU num, How I can choose tx queue not based on CPU
num? It's always shared and has to have lock, and cpdma is done in this way.

Here another thing bothering me, I send it to queue 0 always, instead of
taking cpu num. Not sure about this, but I expect to have some tx queue
not bind to cpu and didn't find a way it can be changed dynamically in
redirect.

>
>> +     if (unlikely(!cpdma_check_free_tx_desc(txch))) {
>> +             struct netdev_queue *txq = netdev_get_tx_queue(priv->ndev, 0);
>> +
>> +             netif_tx_stop_queue(txq);
>> +
>> +             /* Barrier, so that stop_queue visible to other cpus */
>> +             smp_mb__after_atomic();
>> +
>> +             if (cpdma_check_free_tx_desc(txch))
>> +                     netif_tx_wake_queue(txq);
>> +     }
>> +
>> +     return ret;
>> +}
>
>> +static struct page_pool *cpsw_create_rx_pool(struct cpsw_common *cpsw)
>> +{
>> +     struct page_pool_params pp_params = { 0 };
>> +
>> +     pp_params.order = 0;
>> +     pp_params.flags = PP_FLAG_DMA_MAP;
>> +
>> +      /* set it to number of descriptors to be cached from init? */
>> +     pp_params.pool_size = descs_pool_size;
>> +     pp_params.nid = NUMA_NO_NODE; /* no numa */
>> +     pp_params.dma_dir = DMA_FROM_DEVICE;
>
>DMA_FROM_DEVICE looks suspicious if you support TX, shouldn't this be
>BIDIRECTIONAL?
Not sure about this. DMA_FROM_DEVICE is used for RX and fits in redirect to
another inf. In case of redirect each dev is using own dma map, but TX, maybe
better to behave in similar way? if no then probably you are right I can't
avoid this with TX case. I need properly test this case for sure, thanks!

>
>> +     pp_params.dev = cpsw->dev;
>> +
>> +     return page_pool_create(&pp_params);
[...]

>> +     new_xmeta->ndev = ndev;
>> +     new_xmeta->ch = ch;
>> +     dma = new_page->dma_addr + CPSW_HEADROOM;
>> +     ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, (void *)dma,
>> +                                    pkt_size, 0);
>>       if (WARN_ON(ret < 0))
>> -             dev_kfree_skb_any(new_skb);
>> +             page_pool_recycle_direct(pool, new_page);
>> +     else
>> +             kmemleak_not_leak(new_xmeta); /* Is it needed? */
>>
>> -     return 0;
>> +     return flush;
>>  }
>
>On a quick scan I don't see DMA syncs, does the DMA driver takes care
>of making sure the DMA sync happens?
In prev. patch to cpdma layer
[RFC PATCH 1/3] net: ethernet: ti: davinci_cpdma: add dma mapped submit

>
>>  static void cpsw_split_res(struct net_device *ndev)
>
>> @@ -2684,6 +2949,63 @@ static int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
>>       }
>>  }
>>
>> +static int cpsw_xdp_prog_setup(struct net_device *ndev, struct bpf_prog *prog)
>> +{
>> +     struct cpsw_priv *priv = netdev_priv(ndev);
>> +     struct bpf_prog *old_prog;
>> +
>> +     if (!priv->xdp_prog && !prog)
>> +             return 0;
>> +
>> +     old_prog = xchg(&priv->xdp_prog, prog);
>> +     if (old_prog)
>> +             bpf_prog_put(old_prog);
>> +
>> +     return 0;
>> +}
>> +
>> +static int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
>> +{
>> +     struct cpsw_priv *priv = netdev_priv(ndev);
>> +
>> +     switch (bpf->command) {
>> +     case XDP_SETUP_PROG:
>> +             return cpsw_xdp_prog_setup(ndev, bpf->prog);
>> +
>> +     case XDP_QUERY_PROG:
>> +             bpf->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
>
>Consider using xdp_attachment_query() and friends.  This way you'll
>also return the flags.
I will.

>
>> +             return 0;
>> +
>> +     default:
[...]

>> -     cpsw->rxv[0].ch = cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
>> +     cpsw->rxv[0].ch =
>> +         cpdma_chan_create(cpsw->dma, 0, cpsw_rx_handler, 1);
>>       if (IS_ERR(cpsw->rxv[0].ch)) {
>>               dev_err(priv->dev, "error initializing rx dma channel\n");
>>               ret = PTR_ERR(cpsw->rxv[0].ch);
>>               goto clean_dma_ret;
>>       }
>>
>> +     ret = xdp_rxq_info_reg(&priv->xdp_rxq[0], ndev, 0);
>> +     if (ret)
>> +             goto clean_dma_ret;
>> +
>> +     ret = xdp_rxq_info_reg_mem_model(&priv->xdp_rxq[0], MEM_TYPE_PAGE_POOL,
>> +                                      cpsw->rx_page_pool);
>> +     if (ret)
>> +             goto clean_dma_ret;
>> +
>>       ale_params.dev                  = &pdev->dev;
>>       ale_params.ale_ageout           = ale_ageout;
>>       ale_params.ale_entries          = data->ale_entries;
>
>I think you need to unreg the mem model somewhere on the failure path,
>no?
yes, seems so. Thanks.

>
>
>> @@ -3786,6 +4195,7 @@ static int cpsw_probe(struct platform_device *pdev)
>>       pm_runtime_put_sync(&pdev->dev);
>>  clean_runtime_disable_ret:
>>       pm_runtime_disable(&pdev->dev);
>> +     page_pool_destroy(cpsw->rx_page_pool);
>>  clean_ndev_ret:
>>       free_netdev(priv->ndev);
>>       return ret;
>> @@ -3809,6 +4219,7 @@ static int cpsw_remove(struct platform_device *pdev)
>>
>>       cpts_release(cpsw->cpts);
>>       cpdma_ctlr_destroy(cpsw->dma);
>> +     page_pool_destroy(cpsw->rx_page_pool);
>>       cpsw_remove_dt(pdev);
>>       pm_runtime_put_sync(&pdev->dev);
>>       pm_runtime_disable(&pdev->dev);

-- 
Regards,
Ivan Khoronzhuk
