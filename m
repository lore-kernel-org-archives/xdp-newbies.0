Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f49.google.com ([209.85.210.49]:39860 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727599AbeJDWls (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Oct 2018 18:41:48 -0400
Received: by mail-ot1-f49.google.com with SMTP id c20-v6so9631454otl.6
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Oct 2018 08:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
 <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
 <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
 <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
 <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com> <20181004095233.5430b87c@redhat.com>
In-Reply-To: <20181004095233.5430b87c@redhat.com>
From: Rob Sherwood <rob.sherwood@gmail.com>
Date: Thu, 4 Oct 2018 08:47:45 -0700
Message-ID: <CAFg6Rxt6Xdhzwb41uPOWaihhLYV2Gf69D=XLCt=wyQ1Vc6YwFA@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: bjorn.topel@gmail.com, aforster@cloudflare.com, Justin Azoff <justin.azoff@gmail.com>, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com

[not speaking for my current employer, but just from past experience ]

Certainly a lot of the 'hard' requirements (hard meaning - "without
this it won't work")  I've seen could be served with a ~3k non-full
jumbo frame.  But at least what I've seen in the past was that because
many of the host-side operations are per-packet limited (e.g., because
of CPU or RAM, but ultimately turns into a max pps per host), a
trivial way to increase application performance/reduce CPU for
networking was to run at as large a frame size as possible.  For
example, if your application/host is really pps limited, then getting
the frame size to increase from 3k to 9k means either 3x more
bandwidth for the same cpu usage (assuming the application is
bandwidth limited) or 1/3x the CPU usage for the same bandwidth (if
the application is not bandwidth limited).  Either way, IMHO it's a
pretty big win.

- Rob
.
On Thu, Oct 4, 2018 at 12:52 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 4 Oct 2018 08:44:27 +0200
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> > Den tors 27 sep. 2018 kl 02:56 skrev Rob Sherwood <rob.sherwood@gmail.c=
om>:
> > >
> > > Thanks for the reference and the page-per-packet point makes sense.
> > > At the same time, not supporting jumbo frames seems like a non-trivia=
l
> > > limitation.  Are there a subset of drivers that do support jumbo
> > > frames (or LRO or the other features that require multiple pages per
> > > packet)?
> > >
> >
> > No, not at the moment. XDP has a strict "one frame cannot exceed a
> > page" constraint. Everything that applies to XDP in terms of
> > constraints, applies to AF_XDP as well.
> >
> > Just to clarify, XDP supports jumbo frames -- i.e. larger than 1500B
> > payload, just not the maximum 9000B size. My personal observation is
> > that many deployments that "require jumbo frames", are usually OK with
> > an of MTU ~3000B. Jumbo frames, yes. Full jumbo frames, no. :-)
>
> Thank you for clarifying that Bj=C3=B8rn.
>
> Can Alex or Rob explain:
>
> (1) What is your use-case for wanting jumbo-frames?
>
> And (2) will an MTU of ~3000Bytes be sufficient? (which XDP does support)
>
>
> > > On Tue, Sep 25, 2018 at 9:44 AM Alex Forster <aforster@cloudflare.com=
> wrote:
> > > >
> > > > > On my test box running 4.18 if XDP is in use the MTU can not be
> > > > > set higher than 3050.
> > > >
> > > > Ah, that answers a few questions for me. Thanks!
> > > >
> > > > Alex Forster
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
