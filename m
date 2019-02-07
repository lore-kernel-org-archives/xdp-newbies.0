Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f173.google.com ([209.85.160.173]:33396 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfBGHQQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Feb 2019 02:16:16 -0500
Received: by mail-qt1-f173.google.com with SMTP id l11so10934370qtp.0
        for <xdp-newbies@vger.kernel.org>; Wed, 06 Feb 2019 23:16:15 -0800 (PST)
MIME-Version: 1.0
References: <CAHOxX0xSKGaEHiPy8xC=Rxs-juFn7tGwv1QrwgLj5b2DOJmQfw@mail.gmail.com>
In-Reply-To: <CAHOxX0xSKGaEHiPy8xC=Rxs-juFn7tGwv1QrwgLj5b2DOJmQfw@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Thu, 7 Feb 2019 08:16:03 +0100
Message-ID: <CAJ+HfNhhkz_fgx7hT0ERLSFqpo_XP6y8nAcFGhq6yxc7XizU8Q@mail.gmail.com>
Subject: Re: AF_XDP fib lookup
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>
Cc: xdp-newbies@vger.kernel.org

Den m=C3=A5n 4 feb. 2019 kl 12:13 skrev Pavel Popa <pashinho1990@gmail.com>=
:
>
> Hi all,
>
> Is there any way to perform routing in user-space with AF_XDP without
> too much hassle? The only way I see at the moment is to replicate in
> user-space the kernel's FIB state via RTNL events, and performing
> afterwards the IP routing lookup using some LPM algorithm
> implementation. Is there an "easier" way for doing this?
>

Are you sure that AF_XDP is the right approach? If you'd like to use
internal kernel structures, like the FIB, XDP is probably the right
tool.

What is your use-case? Could it be that XDP is a better fit?

Thanks,
Bj=C3=B6rn


> Thank you
