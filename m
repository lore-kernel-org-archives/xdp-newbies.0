Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:41372 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbeAUQir (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 21 Jan 2018 11:38:47 -0500
Received: by mail-qt0-f171.google.com with SMTP id i1so15199383qtj.8
        for <xdp-newbies@vger.kernel.org>; Sun, 21 Jan 2018 08:38:47 -0800 (PST)
MIME-Version: 1.0
From: Rob Sherwood <rob.sherwood@gmail.com>
Date: Sun, 21 Jan 2018 08:38:45 -0800
Message-ID: <CAFg6RxuH7wxg2aa_BOb_c_V_XjfKQ9ad=MQdoxQVm_NX1VaC+A@mail.gmail.com>
Subject: Confused about how maps are identified across user/kernel space
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

I feel like the answer to this is a pointer to the relevant code, but
since I can't find it...

The basic question is: how does the kernel part of a bpf program
identify its maps (e.g., map_k1, map_k2, map_k3) in a way that the
user space program (e.g., map_u1, map_u2, map_u3) identifies the same
maps and put data in to the right places?  I know bcc and libbpf (from
the kernel tree) are supposed to take care of this magic for us, but
I'd like to better understand how it works.

It's not like there's type checking across the user/kernel space
boundary, but the only information passed in the bpf(2) system call is
the map schema.  I'm surprised there's no "map ID" that gets passed on
both sides to make sure they're talking about the same map.

Looking through samples/bpf/xdp_*, the kernel side of each program
identifies each map by a struct bpf_map_def, which is not a kernel
structure but a (random?) data type from tools/lib/bpf/libbpf.h.
Somehow that gets translated (by the JIT?) into the kernel 'struct
bpf_map' data structure (which contains a critical ID field) but then
the identifier that the userspace gets back after the
bpf(BPF_CREATE_MAP) system call is a file descriptor.

Does it basically come down to declaring the maps in the same order?

Any help here would be appreciated - TIA!

- Rob
.
