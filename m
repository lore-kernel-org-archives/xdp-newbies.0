Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbeJGXVb (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 7 Oct 2018 19:21:31 -0400
Date: Sun, 7 Oct 2018 18:13:39 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: AF_XDP umem and jumbo frames?
Message-ID: <20181007181339.2d94c762@redhat.com>
In-Reply-To: <CAJL276AAN2CcyV_vFV1CX7_8BHHoiP9w0z=GQL0imsC+4ujORA@mail.gmail.com>
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
        <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
        <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
        <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
        <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
        <20181004095233.5430b87c@redhat.com>
        <CAFg6Rxt6Xdhzwb41uPOWaihhLYV2Gf69D=XLCt=wyQ1Vc6YwFA@mail.gmail.com>
        <20181004214452.3045c356@redhat.com>
        <CAJL276AAN2CcyV_vFV1CX7_8BHHoiP9w0z=GQL0imsC+4ujORA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Justin Azoff <justin.azoff@gmail.com>
Cc: rob.sherwood@gmail.com, bjorn.topel@gmail.com, aforster@cloudflare.com, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com, brouer@redhat.com

On Fri, 5 Oct 2018 15:56:31 -0400
Justin Azoff <justin.azoff@gmail.com> wrote:

> > People on this list might not realize that there is a significant
> > overhead in supporting larger that 4K frames for XDP, that is larger
> > than one memory-page. So let me explain...
> >
> > It is actually trivially easy for XDP to support jumbo frames, if the
> > NIC hardware supports storing RX frames into higher order pages (aka
> > compound pages, more 4K pages physically after each-other) which most
> > HW does. (Page order0 = 4KB, order1=8KB, order2=16KB, order3=32KB).
> > As then XDP will work out-of-the-box, as the requirement is really that
> > packet-payload is layout as phys continuous memory.
> >  
> 
> For the use cases of XDP_DROP or XDP_PASS, could XDP send as much of
> the packet that fits in a single page up to the ebpf program and allow
> decisions based on that?
> 
> For the flow bypass, ddos drop stuff, you only need the l3 header to
> make the PASS/DROP decision, not the entire packet.
> 
> I suppose this would be a bit more complicated for modifying headers
> and using XDP_TX.

The key in your question is just "bit more complicated", then we can
support feature "X".  For XDP is designed for performance where every
nanosec counts.  Feature creep will slowly but surely kill this
performance edge.

I'll try to explain the overhead of jumbo-frame again, with another
angle.  XDP have gained performance up-front by saying we don't support
jumbo-frames. As instead of (per RX packet) allocating 3x 4KB pages, we
only need to alloc a single 4KB page.  That in itself is a huge
performance win.  Are you saying that you want a feature, that is used
in 1-5% use-cases, that in general is going to slowdown the baseline
performance of XDP?

One thing I realize is that people on this list, are perhaps not
familiar how NIC RX (via DMA) works.  On RX, we cannot know the RX
packet size up-front.  Thus, when filling the NIC RX-ring memory slots,
then we have to allocated room for the "worse-case", e.g. 9000Bytes is
minimum 3x4K=12K, and due to page-alloc limits min 4x4K=16K.  Thus,
regardless of packet length the alloc size is the same.  (I will not go
into detail on how different drivers tries to reduce this mem-overhead,
but only say that those tricks costs CPU cycles).

A last word of adding features to XDP: When adding features, I look
long and hard for ways that the features checks can be pushed to setup
time, rather than runtime.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
