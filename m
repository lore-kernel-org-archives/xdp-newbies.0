Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:51226 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbeJHBdg (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 7 Oct 2018 21:33:36 -0400
Message-ID: <7a00a0cd97d95129f3b982069f46bfb754635959.camel@regit.org>
Subject: Re: AF_XDP umem and jumbo frames?
From: Eric Leblond <eric@regit.org>
Date: Sun, 07 Oct 2018 19:48:42 +0200
In-Reply-To: <20181007181339.2d94c762@redhat.com>
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
         <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
         <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
         <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
         <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
         <20181004095233.5430b87c@redhat.com>
         <CAFg6Rxt6Xdhzwb41uPOWaihhLYV2Gf69D=XLCt=wyQ1Vc6YwFA@mail.gmail.com>
         <20181004214452.3045c356@redhat.com>
         <CAJL276AAN2CcyV_vFV1CX7_8BHHoiP9w0z=GQL0imsC+4ujORA@mail.gmail.com>
         <20181007181339.2d94c762@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, Justin Azoff <justin.azoff@gmail.com>
Cc: rob.sherwood@gmail.com, bjorn.topel@gmail.com, aforster@cloudflare.com, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com

Hello Jesper,

On Sun, 2018-10-07 at 18:13 +0200, Jesper Dangaard Brouer wrote:
> On Fri, 5 Oct 2018 15:56:31 -0400
> Justin Azoff <justin.azoff@gmail.com> wrote:
> 
> > > People on this list might not realize that there is a significant
> > > overhead in supporting larger that 4K frames for XDP, that is
> > > larger
> > > than one memory-page. So let me explain...

...

> One thing I realize is that people on this list, are perhaps not
> familiar how NIC RX (via DMA) works.  On RX, we cannot know the RX
> packet size up-front.  Thus, when filling the NIC RX-ring memory
> slots,
> then we have to allocated room for the "worse-case", e.g. 9000Bytes
> is
> minimum 3x4K=12K, and due to page-alloc limits min 4x4K=16K.  Thus,
> regardless of packet length the alloc size is the same.  (I will not
> go
> into detail on how different drivers tries to reduce this mem-
> overhead,
> but only say that those tricks costs CPU cycles).
> 
> A last word of adding features to XDP: When adding features, I look
> long and hard for ways that the features checks can be pushed to
> setup
> time, rather than runtime.

I get your point about performance and really understand why they
matter but we have kind of an issue for pure packet sniffing here.

For this type of usage we get a copy of the organization network
traffic via methods such as TAP devices or port mirroring. The
consequences is that we receive the jumbo frames of other devices and
can not set their length. As we need a pure copy of packets to be able
to analyze the traffic correctly we have to be able to send the full
jumbo frame to userspace for analysis (or feature like file extraction
will not work).

Is there a possible workaround even if lower performance (kind of slow
path) ?

Best regards,
-- 
Eric Leblond <eric@regit.org>
