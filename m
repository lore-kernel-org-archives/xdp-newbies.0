Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751819AbeDLNun (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Apr 2018 09:50:43 -0400
Date: Thu, 12 Apr 2018 15:50:29 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180412155029.0324fe58@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: brouer@redhat.com, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

Heads-up XDP performance nerds!

I got an unpleasant surprise when I updated my GCC compiler (to support
the option -mindirect-branch=thunk-extern).  My XDP redirect
performance numbers when cut in half; from approx 13Mpps to 6Mpps
(single CPU core).  I've identified the issue, which is caused by
kernel CONFIG_RETPOLINE, that only have effect when the GCC compiler
have support.  This is mitigation of Spectre variant 2 (CVE-2017-5715)
related to indirect (function call) branches.

XDP_REDIRECT itself only have two primary (per packet) indirect
function calls, ndo_xdp_xmit and invoking bpf_prog, plus any
map_lookup_elem calls in the bpf_prog.  I PoC implemented bulking for
ndo_xdp_xmit, which helped, but not enough. The real root-cause is all
the DMA API calls, which uses function pointers extensively.


Mitigation plan
---------------
Implement support for keeping the DMA mapping through the XDP return
call, to remove RX map/unmap calls.  Implement bulking for XDP
ndo_xdp_xmit and XDP return frame API.  Bulking allows to perform DMA
bulking via scatter-gatter DMA calls, XDP TX need it for DMA
map+unmap. The driver RX DMA-sync (to CPU) per packet calls are harder
to mitigate (via bulk technique). Ask DMA maintainer for a common
case direct call for swiotlb DMA sync call ;-)

Root-cause verification
-----------------------
I have verified that indirect DMA calls are the root-cause, by
removing the DMA sync calls from the code (as they for swiotlb does
nothing), and manually inlined the DMA map calls (basically calling
phys_to_dma(dev, page_to_phys(page)) + offset). For my ixgbe test,
performance "returned" to 11Mpps.

Perf reports
------------
It is not easy to diagnose via perf event tool. I'm coordinating with
ACME to make it easier to pinpoint the hotspots.  Lookout for symbols:
__x86_indirect_thunk_r10, __indirect_thunk_start, __x86_indirect_thunk_rdx
etc.  Be aware that they might not be super high in perf top, but they
stop CPU speculation.  Thus, instead use perf-stat and see the
negative effect of 'insn per cycle'.


Want to understand retpoline at ASM level read this:
 https://support.google.com/faqs/answer/7625886

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
