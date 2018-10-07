Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:45136 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeJHCn1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sun, 7 Oct 2018 22:43:27 -0400
Message-ID: <1538940893.2928.3.camel@sipsolutions.net>
Subject: Re: AF_XDP umem and jumbo frames?
From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 07 Oct 2018 21:34:53 +0200
In-Reply-To: <20181007181339.2d94c762@redhat.com> (sfid-20181007_181349_090534_10CC0B8A)
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
         <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
         <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
         <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
         <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
         <20181004095233.5430b87c@redhat.com>
         <CAFg6Rxt6Xdhzwb41uPOWaihhLYV2Gf69D=XLCt=wyQ1Vc6YwFA@mail.gmail.com>
         <20181004214452.3045c356@redhat.com>
         <CAJL276AAN2CcyV_vFV1CX7_8BHHoiP9w0z=GQL0imsC+4ujORA@mail.gmail.com>
         <20181007181339.2d94c762@redhat.com> (sfid-20181007_181349_090534_10CC0B8A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, Justin Azoff <justin.azoff@gmail.com>
Cc: rob.sherwood@gmail.com, bjorn.topel@gmail.com, aforster@cloudflare.com, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com

On Sun, 2018-10-07 at 18:13 +0200, Jesper Dangaard Brouer wrote:

> One thing I realize is that people on this list, are perhaps not
> familiar how NIC RX (via DMA) works.  On RX, we cannot know the RX
> packet size up-front.  Thus, when filling the NIC RX-ring memory slots,
> then we have to allocated room for the "worse-case", e.g. 9000Bytes is
> minimum 3x4K=12K, and due to page-alloc limits min 4x4K=16K.  Thus,
> regardless of packet length the alloc size is the same.  (I will not go
> into detail on how different drivers tries to reduce this mem-overhead,
> but only say that those tricks costs CPU cycles).

Isn't all that generally only true if the NIC has no capability for
split packets? Some (wireless) NICs will - afaict - simply split the
larger packets into multiple single DMA descriptors (pages).

Obviously then that isn't contiguous memory, but it seems that part
could be solved by "mumble mumble something like rewriting eBPF accesses
at skb->data+4k to virtual memory" - which yes, would be *tremendously*
expensive once your program actually does that, but shouldn't actually
cause the general case to be worse off?

(Yes, I also realize that there's a question of being able to prove that
the access is >=4k, but in general I'd assume you can prove that it's
significantly less than 4k and thus not punt to such a slow-path)

johannes
