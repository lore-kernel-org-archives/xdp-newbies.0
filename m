Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60704 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752036AbeDMQtM (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 13 Apr 2018 12:49:12 -0400
Date: Fri, 13 Apr 2018 18:49:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180413164910.GB22904@lst.de>
References: <20180412155029.0324fe58@redhat.com> <20180412145123.GA7048@lst.de> <20180412145653.GA7172@lst.de> <20180412173131.49f01252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180412173131.49f01252@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

On Thu, Apr 12, 2018 at 05:31:31PM +0200, Jesper Dangaard Brouer wrote:
> > I guess that is because x86 selects it as the default as soon as
> > we have more than 4G memory. 
> 
> I were also confused why I ended up using SWIOTLB (SoftWare IO-TLB),
> that might explain it. And I'm not hitting the bounce-buffer case.
> 
> How do I control which DMA engine I use? (So, I can play a little)

At the lowest level you control it by:

 (1) setting the dma_ops pointer in struct device
 (2) if that is NULL by choosing what is returned from
     get_arch_dma_ops()

> 
> 
> > That should be solveable fairly easily with the per-device dma ops,
> > though.
> 
> I didn't understand this part.

What I mean with that is that we can start out setting dma_ops
to dma_direct_ops for everyone on x86 when we start out (that is assuming
we don't have an iommu), and only switching to swiotlb_dma_ops when
actually required by either a dma_mask that can't address all memory,
or some other special cases like SEV or broken bridges.

> I wanted to ask your opinion, on a hackish idea I have...
> Which is howto detect, if I can reuse the RX-DMA map address, for TX-DMA
> operation on another device (still/only calling sync_single_for_device).
> 
> With XDP_REDIRECT we are redirecting between net_device's. Usually
> we keep the RX-DMA mapping as we recycle the page. On the redirect to
> TX-device (via ndo_xdp_xmit) we do a new DMA map+unmap for TX.  The
> question is how to avoid this mapping(?).  In some cases, with some DMA
> engines (or lack of) I guess the DMA address is actually the same as
> the RX-DMA mapping dma_addr_t already known, right?  For those cases,
> would it be possible to just (re)use that address for TX?

You can't in any sensible way without breaking a lot of abstractions.
For dma direct ops that mapping will be the same unless the devices
have different dma_offsets in their struct device, or the architecture
overrides phys_to_dma entirely, in which case all bets are off.
If you have an iommu it depends on which devices are behind the same
iommu.
