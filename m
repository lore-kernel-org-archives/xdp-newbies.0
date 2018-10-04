Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f177.google.com ([209.85.160.177]:40511 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbeJDNgj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Oct 2018 09:36:39 -0400
Received: by mail-qt1-f177.google.com with SMTP id b4-v6so659430qtc.7
        for <xdp-newbies@vger.kernel.org>; Wed, 03 Oct 2018 23:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
 <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
 <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com> <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
In-Reply-To: <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Thu, 4 Oct 2018 08:44:27 +0200
Message-ID: <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: rob.sherwood@gmail.com
Cc: aforster@cloudflare.com, justin.azoff@gmail.com, xdp-newbies@vger.kernel.org, "Karlsson, Magnus" <magnus.karlsson@intel.com>

Den tors 27 sep. 2018 kl 02:56 skrev Rob Sherwood <rob.sherwood@gmail.com>:
>
> Thanks for the reference and the page-per-packet point makes sense.
> At the same time, not supporting jumbo frames seems like a non-trivial
> limitation.  Are there a subset of drivers that do support jumbo
> frames (or LRO or the other features that require multiple pages per
> packet)?
>

No, not at the moment. XDP has a strict "one frame cannot exceed a
page" constraint. Everything that applies to XDP in terms of
constraints, applies to AF_XDP as well.

Just to clarify, XDP supports jumbo frames -- i.e. larger than 1500B
payload, just not the maximum 9000B size. My personal observation is
that many deployments that "require jumbo frames", are usually OK with
an of MTU ~3000B. Jumbo frames, yes. Full jumbo frames, no. :-)


Cheers,
Bj=C3=B6rn


> Thanks in advance,
>
> - Rob
> .
> On Tue, Sep 25, 2018 at 9:44 AM Alex Forster <aforster@cloudflare.com> wr=
ote:
> >
> > > On my test box running 4.18 if XDP is in use the MTU can not be set h=
igher than 3050.
> >
> > Ah, that answers a few questions for me. Thanks!
> >
> > Alex Forster
