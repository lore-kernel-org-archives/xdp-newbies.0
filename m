Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60858 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbeDMR0N (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 13 Apr 2018 13:26:13 -0400
Date: Fri, 13 Apr 2018 19:26:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180413172611.GA23634@lst.de>
References: <20180412155029.0324fe58@redhat.com> <20180412145123.GA7048@lst.de> <20180412145653.GA7172@lst.de> <fbcb4cc8-53fb-82cd-bd9d-76c5fdd47918@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbcb4cc8-53fb-82cd-bd9d-76c5fdd47918@oracle.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Tushar Dave <tushar.n.dave@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jesper Dangaard Brouer <brouer@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

On Fri, Apr 13, 2018 at 10:12:41AM -0700, Tushar Dave wrote:
> I guess there is nothing we need to do!
>
> On x86, in case of no intel iommu or iommu is disabled, you end up in
> swiotlb for DMA API calls when system has 4G memory.
> However, AFAICT, for 64bit DMA capable devices swiotlb DMA APIs do not
> use bounce buffer until and unless you have swiotlb=force specified in
> kernel commandline.

Sure.  But that means very sync_*_to_device and sync_*_to_cpu now
involves an indirect call to do exactly nothing, which in the workload
Jesper is looking at is causing a huge performance degradation due to
retpolines.
