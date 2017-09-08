Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36590 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752806AbdIHAqs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Sep 2017 20:46:48 -0400
Received: by mail-oi0-f41.google.com with SMTP id x190so7105986oix.3
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 17:46:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
 <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
From: Kiran T <kiran.lkml@gmail.com>
Date: Thu, 7 Sep 2017 17:46:47 -0700
Message-ID: <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: xdp-newbies@vger.kernel.org

>
> You should be able to write a small userspace program that opens the
> pinned maps and uses those file descriptors to create or fixup an eBPF
> program from any source (elf or not), so long as you have a way to
> tell which instructions need to be fixed up. (ELF puts this
> information into the relocation sections.)
>

What I am really trying to do is to be able to access an eBPF hashmap or array
created and pinned by a userspace program *after* the bpf program has
been loaded, from
the bpf code.
Looks like this has not been implemented?
If maps can be made persistent from userspace, but the kernel side bpf
can't quite
access it, it doesn't make much sense :(
(I understand userspace<->userspace can access these maps, but kernel
side should be
able to as well)
