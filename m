Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753193AbeDPGCz (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 16 Apr 2018 02:02:55 -0400
Date: Mon, 16 Apr 2018 08:02:50 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180416080244.54a32bde@redhat.com>
In-Reply-To: <1523734166.15648.5.camel@infradead.org>
References: <20180412155029.0324fe58@redhat.com>
        <20180412145123.GA7048@lst.de>
        <20180412145653.GA7172@lst.de>
        <fbcb4cc8-53fb-82cd-bd9d-76c5fdd47918@oracle.com>
        <20180413172611.GA23634@lst.de>
        <1523734166.15648.5.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Tushar Dave <tushar.n.dave@oracle.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, William Tu <u9012063@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, brouer@redhat.com

On Sat, 14 Apr 2018 21:29:26 +0200
David Woodhouse <dwmw2@infradead.org> wrote:

> On Fri, 2018-04-13 at 19:26 +0200, Christoph Hellwig wrote:
> > On Fri, Apr 13, 2018 at 10:12:41AM -0700, Tushar Dave wrote:  
> > > I guess there is nothing we need to do!
> > >
> > > On x86, in case of no intel iommu or iommu is disabled, you end up in
> > > swiotlb for DMA API calls when system has 4G memory.
> > > However, AFAICT, for 64bit DMA capable devices swiotlb DMA APIs do not
> > > use bounce buffer until and unless you have swiotlb=force specified in
> > > kernel commandline.  
> > 
> > Sure.  But that means very sync_*_to_device and sync_*_to_cpu now
> > involves an indirect call to do exactly nothing, which in the workload
> > Jesper is looking at is causing a huge performance degradation due to
> > retpolines.  

Yes, exactly.

> 
> We should look at using the
> 
>  if (dma_ops == swiotlb_dma_ops)
>     swiotlb_map_page()
>  else
>     dma_ops->map_page()
> 
> trick for this. Perhaps with alternatives so that when an Intel or AMD
> IOMMU is detected, it's *that* which is checked for as the special
> case.

Yes, this trick is basically what I'm asking for :-)

It did sound like Hellwig wanted to first avoid/fix that x86 end-up
defaulting to swiotlb.  Thus, we just have to do the same trick with
the new default fall-through dma_ops.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
