Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41845 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbfBDLXU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 4 Feb 2019 06:23:20 -0500
Received: by mail-lj1-f196.google.com with SMTP id k15-v6so11211640ljc.8
        for <xdp-newbies@vger.kernel.org>; Mon, 04 Feb 2019 03:23:18 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: AF_XDP fib lookup
In-Reply-To: <CAHOxX0xSKGaEHiPy8xC=Rxs-juFn7tGwv1QrwgLj5b2DOJmQfw@mail.gmail.com>
References: <CAHOxX0xSKGaEHiPy8xC=Rxs-juFn7tGwv1QrwgLj5b2DOJmQfw@mail.gmail.com>
Date: Mon, 04 Feb 2019 12:23:16 +0100
Message-ID: <87sgx3hk63.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>, xdp-newbies@vger.kernel.org

Pavel Popa <pashinho1990@gmail.com> writes:

> Hi all,
>
> Is there any way to perform routing in user-space with AF_XDP without
> too much hassle? The only way I see at the moment is to replicate in
> user-space the kernel's FIB state via RTNL events, and performing
> afterwards the IP routing lookup using some LPM algorithm
> implementation. Is there an "easier" way for doing this?

Not in user space, but there's an XDP helper that allows you to do FIB
lookups directly from an XDP program running in the kernel. See the
xdp_fwd_kern.c sample:

https://elixir.bootlin.com/linux/latest/source/samples/bpf/xdp_fwd_kern.c

You could conceivably do this lookup in the kernel before forwarding the
packet to userspace, and store the result in the XDP metadata field. But
if you're "just" forwarding packets it's probably easier to do the
redirect directly from the XDP program.

-Toke
