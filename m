Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:42934 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbeAVGaE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 22 Jan 2018 01:30:04 -0500
Received: by mail-ua0-f193.google.com with SMTP id n2so5100538uak.9
        for <xdp-newbies@vger.kernel.org>; Sun, 21 Jan 2018 22:30:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFg6RxuH7wxg2aa_BOb_c_V_XjfKQ9ad=MQdoxQVm_NX1VaC+A@mail.gmail.com>
References: <CAFg6RxuH7wxg2aa_BOb_c_V_XjfKQ9ad=MQdoxQVm_NX1VaC+A@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Sun, 21 Jan 2018 22:29:23 -0800
Message-ID: <CAH3MdRXZx=Awad8QSMg8m05r8awavV2rpfYZsqNpDLz4V1djuw@mail.gmail.com>
Subject: Re: Confused about how maps are identified across user/kernel space
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Rob Sherwood <rob.sherwood@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Sun, Jan 21, 2018 at 8:38 AM, Rob Sherwood <rob.sherwood@gmail.com> wrote:
> I feel like the answer to this is a pointer to the relevant code, but
> since I can't find it...
>
> The basic question is: how does the kernel part of a bpf program
> identify its maps (e.g., map_k1, map_k2, map_k3) in a way that the
> user space program (e.g., map_u1, map_u2, map_u3) identifies the same
> maps and put data in to the right places?  I know bcc and libbpf (from
> the kernel tree) are supposed to take care of this magic for us, but
> I'd like to better understand how it works.

The map_id is used for communication. Initially during map creation,
the map key/value size is passed to kernel, and kernel will have
a record of this. Later on, user space when doing map
lookup/update/delete/get_next_key, etc. just
pass map_id plus key/value pointer and kernel will do its job and
return the results
properly.
>
> It's not like there's type checking across the user/kernel space
> boundary, but the only information passed in the bpf(2) system call is
> the map schema.  I'm surprised there's no "map ID" that gets passed on
> both sides to make sure they're talking about the same map.

Right, for these bpf syscall's, they are not type checking across the
user/kernel
space boundary. The user space should pass correct map_id, otherwise,
wrong data or error code may be returned.

>
> Looking through samples/bpf/xdp_*, the kernel side of each program
> identifies each map by a struct bpf_map_def, which is not a kernel
> structure but a (random?) data type from tools/lib/bpf/libbpf.h.

This "struct bpf_map_def" data structure is used in userspace to
convey information
between different functions. It is not used between
userspace/kernelspace communication.

In that sense, it is "random" defined for convenience. The data structure which
carries information from user space to kernel is "struct bpf_attr" in
include/uapi/linux/bpf.h.

> Somehow that gets translated (by the JIT?)

It is not translated by JIT. It is translated by kernel bpf syscall handlers at
linux/kernel/bpf/syscall.c.

> bpf_map' data structure (which contains a critical ID field) but then
> the identifier that the userspace gets back after the
> bpf(BPF_CREATE_MAP) system call is a file descriptor.

Yes, the file descriptor is returned.

>
> Does it basically come down to declaring the maps in the same order?

This is just the way user space library works. They call BPF_MAP_CREATE
bpf syscall based on declaration ordering and creates the an array of
map_id's which
will have the same ordering as the declaration.

>
> Any help here would be appreciated - TIA!
>
> - Rob
> .
