Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33164 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeDQGTg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Apr 2018 02:19:36 -0400
Date: Mon, 16 Apr 2018 23:19:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180417061931.GB21067@infradead.org>
References: <20180412155029.0324fe58@redhat.com>
 <20180416122706.GA20624@infradead.org>
 <CAKgT0UfUgoc=EDhs-uHShwHQC2P4eRGCn3Bvaen_2NOL17Z3xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfUgoc=EDhs-uHShwHQC2P4eRGCn3Bvaen_2NOL17Z3xA@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jesper Dangaard Brouer <brouer@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

> I'm not sure if I am really a fan of trying to solve this in this way.
> It seems like this is going to be optimizing the paths for one case at
> the detriment of others. Historically mapping and unmapping has always
> been expensive, especially in the case of IOMMU enabled environments.
> I would much rather see us focus on having swiotlb_dma_ops replaced
> with dma_direct_ops in the cases where the device can access all of
> physical memory.

I am definitively not a fan, but IFF indirect calls are such an overhead
it makes sense to avoid it for the common and simple case.  And the
direct mapping is a common case present on just about every
architecture, and it is a very simple fast path that just adds an offset
to the physical address.  So if we want to speed something up, this is
it.

> > -       if (ops->unmap_page)
> > +       if (!dev->is_dma_direct && ops->unmap_page)
> 
> If I understand correctly this is only needed for the swiotlb case and
> not the dma_direct case. It would make much more sense to just
> overwrite the dev->dma_ops pointer with dma_direct_ops to address all
> of the sync and unmap cases.

Yes.

> > +       if (dev->dma_ops == &dma_direct_ops ||
> > +           (dev->dma_ops == &swiotlb_dma_ops &&
> > +            mask == DMA_BIT_MASK(64)))
> > +               dev->is_dma_direct = true;
> > +       else
> > +               dev->is_dma_direct = false;
> 
> So I am not sure this will work on x86. If I am not mistaken I believe
> dev->dma_ops is normally not set and instead the default dma
> operations are pulled via get_arch_dma_ops which returns the global
> dma_ops pointer.

True, for x86 we'd need to check get_arch_dma_ops().

> What you may want to consider as an alternative would be to look at
> modifying drivers that are using the swiotlb so that you could just
> overwrite the dev->dma_ops with the dma_direct_ops in the cases where
> the hardware can support accessing all of physical hardware and where
> we aren't forcing the use of the bounce buffers in the swiotlb.
> 
> Then for the above code you only have to worry about the map calls,
> and you could just do a check against the dma_direct_ops pointer
> instead of having to add a new flag.

That would be the long term plan IFF we go down this route.  For now I
just wanted a quick hack for performance testing.
