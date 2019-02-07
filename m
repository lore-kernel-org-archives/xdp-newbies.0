Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f181.google.com ([209.85.166.181]:56235 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfBGIe0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Feb 2019 03:34:26 -0500
Received: by mail-it1-f181.google.com with SMTP id m62so12706884ith.5
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Feb 2019 00:34:25 -0800 (PST)
MIME-Version: 1.0
References: <CAHOxX0xSKGaEHiPy8xC=Rxs-juFn7tGwv1QrwgLj5b2DOJmQfw@mail.gmail.com>
 <CAJ+HfNhhkz_fgx7hT0ERLSFqpo_XP6y8nAcFGhq6yxc7XizU8Q@mail.gmail.com>
In-Reply-To: <CAJ+HfNhhkz_fgx7hT0ERLSFqpo_XP6y8nAcFGhq6yxc7XizU8Q@mail.gmail.com>
From: Pavel Popa <pashinho1990@gmail.com>
Date: Thu, 7 Feb 2019 09:34:13 +0100
Message-ID: <CAHOxX0wHABNA+q8y=EEJE2pXVSbLR9ke+PjgAzHn=bj_zJ=Qpg@mail.gmail.com>
Subject: Re: AF_XDP fib lookup
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc: xdp-newbies@vger.kernel.org

Well, I thought about this for some time. The main problem is, as I
already experimented with, the bpf verifier. It does effectively
prevent sure bugs and kernel panics, but it's also full of false
positives (e.g. parsing optional headers with tlv format is a huge
pain). My use-case is a dataplane for tunnel encap/decap, keeping
track of the right sessions and their accounting, packet
classification, routing, and some other smaller things. In my view,
clearly it's almost impossible doing all of this in XDP, therefore the
choice of AF_XDP. I hope this makes sense.

Thank you

Il giorno gio 7 feb 2019 alle ore 08:16 Bj=C3=B6rn T=C3=B6pel
<bjorn.topel@gmail.com> ha scritto:
>
> Den m=C3=A5n 4 feb. 2019 kl 12:13 skrev Pavel Popa <pashinho1990@gmail.co=
m>:
> >
> > Hi all,
> >
> > Is there any way to perform routing in user-space with AF_XDP without
> > too much hassle? The only way I see at the moment is to replicate in
> > user-space the kernel's FIB state via RTNL events, and performing
> > afterwards the IP routing lookup using some LPM algorithm
> > implementation. Is there an "easier" way for doing this?
> >
>
> Are you sure that AF_XDP is the right approach? If you'd like to use
> internal kernel structures, like the FIB, XDP is probably the right
> tool.
>
> What is your use-case? Could it be that XDP is a better fit?
>
> Thanks,
> Bj=C3=B6rn
>
>
> > Thank you
