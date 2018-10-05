Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f49.google.com ([209.85.221.49]:34894 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbeJFC46 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Oct 2018 22:56:58 -0400
Received: by mail-wr1-f49.google.com with SMTP id w5-v6so14705297wrt.2
        for <xdp-newbies@vger.kernel.org>; Fri, 05 Oct 2018 12:56:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
 <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
 <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
 <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
 <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
 <20181004095233.5430b87c@redhat.com> <CAFg6Rxt6Xdhzwb41uPOWaihhLYV2Gf69D=XLCt=wyQ1Vc6YwFA@mail.gmail.com>
 <20181004214452.3045c356@redhat.com>
In-Reply-To: <20181004214452.3045c356@redhat.com>
From: Justin Azoff <justin.azoff@gmail.com>
Date: Fri, 5 Oct 2018 15:56:31 -0400
Message-ID: <CAJL276AAN2CcyV_vFV1CX7_8BHHoiP9w0z=GQL0imsC+4ujORA@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: rob.sherwood@gmail.com, bjorn.topel@gmail.com, aforster@cloudflare.com, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com

> People on this list might not realize that there is a significant
> overhead in supporting larger that 4K frames for XDP, that is larger
> than one memory-page. So let me explain...
>
> It is actually trivially easy for XDP to support jumbo frames, if the
> NIC hardware supports storing RX frames into higher order pages (aka
> compound pages, more 4K pages physically after each-other) which most
> HW does. (Page order0 = 4KB, order1=8KB, order2=16KB, order3=32KB).
> As then XDP will work out-of-the-box, as the requirement is really that
> packet-payload is layout as phys continuous memory.
>

For the use cases of XDP_DROP or XDP_PASS, could XDP send as much of
the packet that fits in a single page up to the ebpf program and allow
decisions based on that?

For the flow bypass, ddos drop stuff, you only need the l3 header to
make the PASS/DROP decision, not the entire packet.

I suppose this would be a bit more complicated for modifying headers
and using XDP_TX.

-- 
- Justin
