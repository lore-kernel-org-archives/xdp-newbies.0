Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59748 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeDQHNw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Apr 2018 03:13:52 -0400
Date: Tue, 17 Apr 2018 00:13:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180417071339.GA24498@infradead.org>
References: <20180412155029.0324fe58@redhat.com>
 <20180416122706.GA20624@infradead.org>
 <20180416230704.65629b9f@redhat.com>
 <20180417061550.GA21067@infradead.org>
 <20180417090701.6b25f456@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417090701.6b25f456@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

On Tue, Apr 17, 2018 at 09:07:01AM +0200, Jesper Dangaard Brouer wrote:
> > > number should improve more).  
> > 
> > What is the number for the otherwise comparable setup without repolines?
> 
> Approx 12 Mpps.
> 
> You forgot to handle the dma_direct_mapping_error() case, which still
> used the retpoline in the above 8.9 Mpps measurement, I fixed it up and
> performance increased to 9.6 Mpps.
> 
> Notice, in this test there are still two retpoline/indirect-calls
> left.  The net_device->ndo_xdp_xmit and the invocation of the XDP BPF
> prog.

But that seems like a pretty clear indicator that we want the fast path
direct mapping.  I'll try to find some time over the next weeks to
do a cleaner version of it.
