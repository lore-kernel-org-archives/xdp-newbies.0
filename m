Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:34212 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdIGXR2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Sep 2017 19:17:28 -0400
Received: by mail-pg0-f41.google.com with SMTP id q68so1942767pgq.1
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 16:17:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Thu, 7 Sep 2017 16:17:27 -0700
Message-ID: <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kiran T <kiran.lkml@gmail.com>
Cc: xdp-newbies@vger.kernel.org

From what I've learned building my own XDP loader, it seems like the
kernel only takes a bock of eBPF instructions. For any references to
maps, the instructions need to have been "fixed up" (if they came from
a source like an elf file) to appropriately reference the file
descriptors for any maps. As far as I can tell, those file descriptors
are the userspace file descriptors for the maps in the loading program

> The samples and test cases have examples showing how user space
> programs can pin maps and get pinned maps as FDs.  However, how would
> one access a user-space created pinned map from kernel space, without
> having to statically have a 'maps' section defined (and depend on the
> elf loader)?

You should be able to write a small userspace program that opens the
pinned maps and uses those file descriptors to create or fixup an eBPF
program from any source (elf or not), so long as you have a way to
tell which instructions need to be fixed up. (ELF puts this
information into the relocation sections.)

samples/bpf/bpf_load.c has an example of how to do the fixing up using
the relocation information from an elf file. Take a look at the
parse_relo_and_apply() function for how to adjust the eBPF
instructions.

--Zvi
