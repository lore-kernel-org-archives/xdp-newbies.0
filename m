Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55466 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752763AbeDLOva (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Apr 2018 10:51:30 -0400
Date: Thu, 12 Apr 2018 16:51:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180412145123.GA7048@lst.de>
References: <20180412155029.0324fe58@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180412155029.0324fe58@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

On Thu, Apr 12, 2018 at 03:50:29PM +0200, Jesper Dangaard Brouer wrote:
> ---------------
> Implement support for keeping the DMA mapping through the XDP return
> call, to remove RX map/unmap calls.  Implement bulking for XDP
> ndo_xdp_xmit and XDP return frame API.  Bulking allows to perform DMA
> bulking via scatter-gatter DMA calls, XDP TX need it for DMA
> map+unmap. The driver RX DMA-sync (to CPU) per packet calls are harder
> to mitigate (via bulk technique). Ask DMA maintainer for a common
> case direct call for swiotlb DMA sync call ;-)

Why do you even end up in swiotlb code?  Once you bounce buffer your
performance is toast anyway..
