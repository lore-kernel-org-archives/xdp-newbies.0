Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751183AbeDQHHI (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 17 Apr 2018 03:07:08 -0400
Date: Tue, 17 Apr 2018 09:07:01 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180417090701.6b25f456@redhat.com>
In-Reply-To: <20180417061550.GA21067@infradead.org>
References: <20180412155029.0324fe58@redhat.com>
        <20180416122706.GA20624@infradead.org>
        <20180416230704.65629b9f@redhat.com>
        <20180417061550.GA21067@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, brouer@redhat.com

On Mon, 16 Apr 2018 23:15:50 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Apr 16, 2018 at 11:07:04PM +0200, Jesper Dangaard Brouer wrote:
> > On X86 swiotlb fallback (via get_dma_ops -> get_arch_dma_ops) to use
> > x86_swiotlb_dma_ops, instead of swiotlb_dma_ops.  I also included that
> > in below fix patch.  
> 
> x86_swiotlb_dma_ops should not exist any mor, and x86 now uses
> dma_direct_ops.  Looks like you are applying it to an old kernel :)
> 
> > Performance improved to 8.9 Mpps from approx 6.5Mpps.
> > 
> > (This was without my bulking for net_device->ndo_xdp_xmit, so that
> > number should improve more).  
> 
> What is the number for the otherwise comparable setup without repolines?

Approx 12 Mpps.

You forgot to handle the dma_direct_mapping_error() case, which still
used the retpoline in the above 8.9 Mpps measurement, I fixed it up and
performance increased to 9.6 Mpps.

Notice, in this test there are still two retpoline/indirect-calls
left.  The net_device->ndo_xdp_xmit and the invocation of the XDP BPF
prog.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
