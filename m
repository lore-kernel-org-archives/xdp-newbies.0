Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391271AbfEXLyb (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 24 May 2019 07:54:31 -0400
Date: Fri, 24 May 2019 13:54:18 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190524135418.5408591e@carbon>
In-Reply-To: <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
        <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, brouer@redhat.com, Tariq Toukan <tariqt@mellanox.com>

On Thu, 23 May 2019 21:20:35 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Add XDP support based on rx page_pool allocator, one frame per page.
> Page pool allocator is used with assumption that only one rx_handler
> is running simultaneously. DMA map/unmap is reused from page pool
> despite there is no need to map whole page.

When using page_pool for DMA-mapping, your XDP-memory model must use
1-page per packet, which you state you do.  This is because
__page_pool_put_page() fallback mode does a __page_pool_clean_page()
unmapping the DMA.  Ilias and I are looking at options for removing this
restriction as Mlx5 would need it (when we extend the SKB to return
pages to page_pool).

Unfortunately, I've found another blocker for drivers using the DMA
mapping feature of page_pool.  We don't properly handle the case, where
a remote TX-driver have xdp_frame's in-flight, and simultaneously the
sending driver is unloaded and take down the page_pool.  Nothing crash,
but we end-up calling put_page() on a page that is still DMA-mapped.

I'm working on different solutions for fixing this, see here:
 https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool03_shutdown_inflight.org
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
