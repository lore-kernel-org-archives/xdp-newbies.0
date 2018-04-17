Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeDQGP4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Apr 2018 02:15:56 -0400
Date: Mon, 16 Apr 2018 23:15:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180417061550.GA21067@infradead.org>
References: <20180412155029.0324fe58@redhat.com>
 <20180416122706.GA20624@infradead.org>
 <20180416230704.65629b9f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180416230704.65629b9f@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

On Mon, Apr 16, 2018 at 11:07:04PM +0200, Jesper Dangaard Brouer wrote:
> On X86 swiotlb fallback (via get_dma_ops -> get_arch_dma_ops) to use
> x86_swiotlb_dma_ops, instead of swiotlb_dma_ops.  I also included that
> in below fix patch.

x86_swiotlb_dma_ops should not exist any mor, and x86 now uses
dma_direct_ops.  Looks like you are applying it to an old kernel :)

> Performance improved to 8.9 Mpps from approx 6.5Mpps.
> 
> (This was without my bulking for net_device->ndo_xdp_xmit, so that
> number should improve more).

What is the number for the otherwise comparable setup without repolines?
