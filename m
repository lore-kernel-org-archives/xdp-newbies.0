Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42651 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfE0SKu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 May 2019 14:10:50 -0400
Received: by mail-lf1-f66.google.com with SMTP id y13so12649401lfh.9
        for <xdp-newbies@vger.kernel.org>; Mon, 27 May 2019 11:10:49 -0700 (PDT)
Date: Mon, 27 May 2019 21:10:46 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190527181043.GA4246@khorivan>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
 <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
 <20190524135418.5408591e@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190524135418.5408591e@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, Tariq Toukan <tariqt@mellanox.com>

On Fri, May 24, 2019 at 01:54:18PM +0200, Jesper Dangaard Brouer wrote:
>On Thu, 23 May 2019 21:20:35 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> Add XDP support based on rx page_pool allocator, one frame per page.
>> Page pool allocator is used with assumption that only one rx_handler
>> is running simultaneously. DMA map/unmap is reused from page pool
>> despite there is no need to map whole page.
>
>When using page_pool for DMA-mapping, your XDP-memory model must use
>1-page per packet, which you state you do.  This is because
>__page_pool_put_page() fallback mode does a __page_pool_clean_page()
>unmapping the DMA.  Ilias and I are looking at options for removing this
>restriction as Mlx5 would need it (when we extend the SKB to return
>pages to page_pool).
Thank for what you do, it can simplify a lot...

>
>Unfortunately, I've found another blocker for drivers using the DMA
>mapping feature of page_pool.  We don't properly handle the case, where
>a remote TX-driver have xdp_frame's in-flight, and simultaneously the
>sending driver is unloaded and take down the page_pool.  Nothing crash,
>but we end-up calling put_page() on a page that is still DMA-mapped.

Seems so, ... for generic solution, but looks like in case of cpsw there
is no issue due to "like direct" dma map by adding offset, so whether page_pool
dma map or dma map/unmap per rx/xmit, shouldn't be big difference.  Not sure
about all SoCs thought...

Despite of it, for cpsw I keep page_pool while down/up that I'm going to change
in v2.

>
>I'm working on different solutions for fixing this, see here:
> https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool03_shutdown_inflight.org
Hope there will be no changes in page_pool API.

>-- Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
