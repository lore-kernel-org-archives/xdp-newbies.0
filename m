Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:37782 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbeJDWdp (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Oct 2018 18:33:45 -0400
Received: by mail-wr1-f52.google.com with SMTP id u12-v6so10419820wrr.4
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Oct 2018 08:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
 <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
 <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
 <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
 <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com> <20181004095233.5430b87c@redhat.com>
In-Reply-To: <20181004095233.5430b87c@redhat.com>
From: Alex Forster <aforster@cloudflare.com>
Date: Thu, 4 Oct 2018 10:39:43 -0500
Message-ID: <CAKxSbF1G8tve21RxUZOejTV2=AW=dzZRABYG1e+a20CA0__tyA@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: bjorn.topel@gmail.com, rob.sherwood@gmail.com, Justin Azoff <justin.azoff@gmail.com>, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com

> Just to clarify, XDP supports jumbo frames -- i.e. larger than 1500B payl=
oad, just not the maximum 9000B size. My personal observation is that many =
deployments that "require jumbo frames", are usually OK with an of MTU ~300=
0B. Jumbo frames, yes. Full jumbo frames, no. :-)

Right, that's where my confusion was. My understanding was limited to
"XDP supports jumbo frames" until I got here[1] in the umem
implementation ("computer says no") and started questioning myself.

> Can Alex or Rob explain:
>
> (1) What is your use-case for wanting jumbo-frames?
>
> And (2) will an MTU of ~3000Bytes be sufficient? (which XDP does support)

I don't personally have a need for MTU9K right now. ~3K is totally
sufficient for the usecases I have/know of.

Food for thought, though: I think MTU9K is considered a hard
requirement in the storage space.

Alex Forster

[1]: https://github.com/torvalds/linux/blob/v4.19-rc4/net/xdp/xdp_umem.c#L2=
78

On Thu, Oct 4, 2018 at 2:52 AM Jesper Dangaard Brouer <brouer@redhat.com> w=
rote:
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
