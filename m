Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f46.google.com ([209.85.208.46]:38949 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfGLKxW (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 12 Jul 2019 06:53:22 -0400
Received: by mail-ed1-f46.google.com with SMTP id m10so8809349edv.6
        for <xdp-newbies@vger.kernel.org>; Fri, 12 Jul 2019 03:53:21 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: x710 Checksum Offloading with XDP
In-Reply-To: <CAH7f-UJUTUT0YKYVMCjNaQzwN3=sFh62Bx7sBO85XyjuNyy4Fg@mail.gmail.com>
References: <CAH7f-UJUTUT0YKYVMCjNaQzwN3=sFh62Bx7sBO85XyjuNyy4Fg@mail.gmail.com>
Date: Fri, 12 Jul 2019 12:53:18 +0200
Message-ID: <87ims7v80x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Cody Haas <chaas@riotgames.com>, xdp-newbies@vger.kernel.org

Cody Haas <chaas@riotgames.com> writes:

> Hey,
>
> Trying to utilize TX checksum offloading while running an XDP
> application; We're running on Fedora 28, using Intel x710 Network
> Adapters in unison with the Intel i40e drivers and we've verified that
> the Fedora sees that TX checksum offloading is enabled. On the
> receiving side of an XDP_TX we don't see a proper checksum in the
> transmitted packet. Is this due to XDP bypassing the Linux network
> stack? If so, is there a way to have XDP instruct the driver to
> conduct the TX checksum? Or is this intended behavior?

You are quite right that this is because XDP bypasses the stack
entirely. There is currently no support for interacting with hardware
offload features from XDP, so if you're using XDP_TX you need to fix up
the checksum in your eBPF program. There's a bpf_csum_diff() helper
which may be helpful in this regard.

Getting better support for hardware offloads in concert with XDP is
something we'd like to get to eventually, but we're not there yet,
unfortunately.

-Toke
