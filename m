Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfEaQcv (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 May 2019 12:32:51 -0400
Date: Fri, 31 May 2019 18:32:41 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190531183241.255293bc@carbon>
In-Reply-To: <20190531162523.GA3694@khorivan>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
        <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
        <20190531174643.4be8b27f@carbon>
        <20190531162523.GA3694@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, brouer@redhat.com


On Fri, 31 May 2019 19:25:24 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Fri, May 31, 2019 at 05:46:43PM +0200, Jesper Dangaard Brouer wrote:
> >
> >From below code snippets, it looks like you only allocated 1 page_pool
> >and sharing it with several RX-queues, as I don't have the full context
> >and don't know this driver, I might be wrong?
> >
> >To be clear, a page_pool object is needed per RX-queue, as it is
> >accessing a small RX page cache (which protected by NAPI/softirq).  
> 
> There is one RX interrupt and one RX NAPI for all rx channels.

So, what are you saying?

You _are_ sharing the page_pool between several RX-channels, but it is
safe because this hardware only have one RX interrupt + NAPI instance??

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
