Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:50228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfBGSCb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Feb 2019 13:02:31 -0500
Date: Thu, 07 Feb 2019 10:02:30 -0800 (PST)
Message-Id: <20190207.100230.864448306113247122.davem@davemloft.net>
Subject: Re: AF_XDP fib lookup
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHOxX0wHABNA+q8y=EEJE2pXVSbLR9ke+PjgAzHn=bj_zJ=Qpg@mail.gmail.com>
References: <CAHOxX0xSKGaEHiPy8xC=Rxs-juFn7tGwv1QrwgLj5b2DOJmQfw@mail.gmail.com>
        <CAJ+HfNhhkz_fgx7hT0ERLSFqpo_XP6y8nAcFGhq6yxc7XizU8Q@mail.gmail.com>
        <CAHOxX0wHABNA+q8y=EEJE2pXVSbLR9ke+PjgAzHn=bj_zJ=Qpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: pashinho1990@gmail.com
Cc: bjorn.topel@gmail.com, xdp-newbies@vger.kernel.org

From: Pavel Popa <pashinho1990@gmail.com>
Date: Thu, 7 Feb 2019 09:34:13 +0100

> Well, I thought about this for some time. The main problem is, as I
> already experimented with, the bpf verifier. It does effectively
> prevent sure bugs and kernel panics, but it's also full of false
> positives (e.g. parsing optional headers with tlv format is a huge
> pain). My use-case is a dataplane for tunnel encap/decap, keeping
> track of the right sessions and their accounting, packet
> classification, routing, and some other smaller things. In my view,
> clearly it's almost impossible doing all of this in XDP, therefore the
> choice of AF_XDP. I hope this makes sense.

We should make XDP align to your needs in this situation, please work
with us so that we can make it so.

Thanks.
