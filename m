Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752761AbeDLPbi (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Apr 2018 11:31:38 -0400
Date: Thu, 12 Apr 2018 17:31:31 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180412173131.49f01252@redhat.com>
In-Reply-To: <20180412145653.GA7172@lst.de>
References: <20180412155029.0324fe58@redhat.com>
        <20180412145123.GA7048@lst.de>
        <20180412145653.GA7172@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, brouer@redhat.com

On Thu, 12 Apr 2018 16:56:53 +0200 Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Apr 12, 2018 at 04:51:23PM +0200, Christoph Hellwig wrote:
> > On Thu, Apr 12, 2018 at 03:50:29PM +0200, Jesper Dangaard Brouer wrote:  
> > > ---------------
> > > Implement support for keeping the DMA mapping through the XDP return
> > > call, to remove RX map/unmap calls.  Implement bulking for XDP
> > > ndo_xdp_xmit and XDP return frame API.  Bulking allows to perform DMA
> > > bulking via scatter-gatter DMA calls, XDP TX need it for DMA
> > > map+unmap. The driver RX DMA-sync (to CPU) per packet calls are harder
> > > to mitigate (via bulk technique). Ask DMA maintainer for a common
> > > case direct call for swiotlb DMA sync call ;-)  
> > 
> > Why do you even end up in swiotlb code?  Once you bounce buffer your
> > performance is toast anyway..  
> 
> I guess that is because x86 selects it as the default as soon as
> we have more than 4G memory. 

I were also confused why I ended up using SWIOTLB (SoftWare IO-TLB),
that might explain it. And I'm not hitting the bounce-buffer case.

How do I control which DMA engine I use? (So, I can play a little)


> That should be solveable fairly easily with the per-device dma ops,
> though.

I didn't understand this part.

I wanted to ask your opinion, on a hackish idea I have...
Which is howto detect, if I can reuse the RX-DMA map address, for TX-DMA
operation on another device (still/only calling sync_single_for_device).

With XDP_REDIRECT we are redirecting between net_device's. Usually
we keep the RX-DMA mapping as we recycle the page. On the redirect to
TX-device (via ndo_xdp_xmit) we do a new DMA map+unmap for TX.  The
question is how to avoid this mapping(?).  In some cases, with some DMA
engines (or lack of) I guess the DMA address is actually the same as
the RX-DMA mapping dma_addr_t already known, right?  For those cases,
would it be possible to just (re)use that address for TX?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
