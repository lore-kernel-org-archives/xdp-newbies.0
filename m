Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:36669 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdLDSBk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 4 Dec 2017 13:01:40 -0500
Received: by mail-ua0-f172.google.com with SMTP id w47so13110032uah.3
        for <xdp-newbies@vger.kernel.org>; Mon, 04 Dec 2017 10:01:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3580c48c28ad1688229efe962bc96c9a@cse.iitd.ac.in>
References: <3580c48c28ad1688229efe962bc96c9a@cse.iitd.ac.in>
From: Y Song <ys114321@gmail.com>
Date: Mon, 4 Dec 2017 10:00:58 -0800
Message-ID: <CAH3MdRW3HW7rsueHaLj4vUDkvr7Qunuwv_FX5=jee6oBGYMHew@mail.gmail.com>
Subject: Re: Common hash function for kernel and user space in XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: anmol07.visitor@cse.iitd.ac.in
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Mon, Dec 4, 2017 at 6:39 AM, Anmol Panda
<anmol07.visitor@cse.iitd.ac.in> wrote:
> Hello All,
>    We are trying to implement L2 forwarding in xdp and we need to convert
> the mac-address to a hash value. Thus far, we have tried using crc32
> functions from <linux/crc32.h> for kernel space but it can't be used in user
> space. We need a common crc hash function for both kernel and user space.
>
>    The kernel crc function causes the following error:
>
> invalid relo for insn[24].code 0x85
> bpf_load_program() err=22
> 0: (61) r2 = *(u32 *)(r1 +4)
> 1: (61) r1 = *(u32 *)(r1 +0)
> .
> .
> .
> 23: (b7) r3 = 6
> 24: (85) call unknown#-1
> BPF_CALL uses reserved fields

The kernel crc function eventually calls crc32_le_shift or other variants
in lib/crc32.c. BPF program is able to resolve the reference to
crc32_le_shift at verification time, hence you will see the failure above.

You may need to implement one or re-structure an existing implementation
(e.g. the one from linux) into separate header files, so you can include in
both bpf program and your user space application.

>
>
>    Can you please point to some examples or references?
>    We would be highly grateful.
>
> Thanks,
> Sincerely,
>
