Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFIJD (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 6 Jun 2019 04:09:03 -0400
Date: Thu, 6 Jun 2019 10:08:50 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v3 net-next 0/7] net: ethernet: ti: cpsw: Add XDP
 support
Message-ID: <20190606100850.72a48a43@carbon>
In-Reply-To: <20190605.121450.2198491088032558315.davem@davemloft.net>
References: <20190605132009.10734-1-ivan.khoronzhuk@linaro.org>
        <20190605.121450.2198491088032558315.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: ivan.khoronzhuk@linaro.org, grygorii.strashko@ti.com, hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, brouer@redhat.com

On Wed, 05 Jun 2019 12:14:50 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> Date: Wed,  5 Jun 2019 16:20:02 +0300
> 
> > This patchset adds XDP support for TI cpsw driver and base it on
> > page_pool allocator. It was verified on af_xdp socket drop,
> > af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.  
> 
> Jesper et al., please give this a good once over.

The issue with merging this, is that I recently discovered two bug with
page_pool API, when using DMA-mappings, which result in missing
DMA-unmap's.  These bugs are not "exposed" yet, but will get exposed
now with this drivers.  

The two bugs are:

#1: in-flight packet-pages can still be on remote drivers TX queue,
while XDP RX driver manage to unregister the page_pool (waiting 1 RCU
period is not enough).

#2: this patchset also introduce page_pool_unmap_page(), which is
called before an XDP frame travel into networks stack (as no callback
exist, yet).  But the CPUMAP redirect *also* needs to call this, else we
"leak"/miss DMA-unmap.

I do have a working prototype, that fixes these two bugs.  I guess, I'm
under pressure to send this to the list soon...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
