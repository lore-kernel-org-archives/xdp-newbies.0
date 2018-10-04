Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:38068 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbeJDVl4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Oct 2018 17:41:56 -0400
Received: by mail-wr1-f48.google.com with SMTP id a13-v6so10238249wrt.5
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Oct 2018 07:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
 <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
 <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
 <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
 <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com> <20181004095233.5430b87c@redhat.com>
In-Reply-To: <20181004095233.5430b87c@redhat.com>
From: Justin Azoff <justin.azoff@gmail.com>
Date: Thu, 4 Oct 2018 10:48:06 -0400
Message-ID: <CAJL276Co5xjGnCp6OwLF84BowQ54vfcd08xKdce9SiojsGppPw@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: bjorn.topel@gmail.com, rob.sherwood@gmail.com, aforster@cloudflare.com, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com

On Thu, Oct 4, 2018 at 3:52 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> Can Alex or Rob explain:
>
> (1) What is your use-case for wanting jumbo-frames?
>
> And (2) will an MTU of ~3000Bytes be sufficient? (which XDP does support)

Not Alex or Rob, but lack of jumbo frames is currently a blocker for using XDP.

I'm working on https://github.com/JustinAzoff/libflowbypass which is similar to
the bypass stuff suricata can do, but implemented as a standalone library.

We have a number of high performance networks that use jumbo frames and the XDP
NICs sit on fiber taps.  So it's not so much that I want to use jumbo frames
but that some of the traffic I need to analyze is using them.  For
this same reason 3000
bytes isn't enough since I see 9000 byte frames.

If XDP could implicitly XDP_PASS jumbo frames instead of truncating them at
3000 that would at least allow the use of XDP to inspect and drop the
majority of  < 3000
byte frames.

-- 
- Justin
