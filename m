Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44579 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727769AbgFJJc1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 05:32:27 -0400
Received: by mail-ej1-f70.google.com with SMTP id ca6so821441ejb.7
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 02:32:21 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: How to load BTF style maps?
In-Reply-To: <CAMDScm=VZJMZYN=SXo9OAshY=yYxwtavLDgTvu1qEasg77JyLw@mail.gmail.com>
References: <CAMDScm=VZJMZYN=SXo9OAshY=yYxwtavLDgTvu1qEasg77JyLw@mail.gmail.com>
Date: Wed, 10 Jun 2020 11:32:18 +0200
Message-ID: <87ftb38dwd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Elerion <elerion1000@gmail.com>, xdp-newbies@vger.kernel.org

Elerion <elerion1000@gmail.com> writes:

> I have maps written in the old style like this:
>
> struct bpf_map_def SEC("maps") xdp_stats_map = {
> .type        = BPF_MAP_TYPE_ARRAY,
> .key_size    = sizeof(__u32),
> .value_size  = sizeof(struct datarec),
> .max_entries = XDP_ACTION_MAX,
> };
>
> I changed it to the new BTF style like this but now the example BPF
> loader from the kernel doesn't work anymore.
>
> struct {
>     __uint(type, BPF_MAP_TYPE_ARRAY);
>     __uint(max_entries,  XDP_ACTION_MAX);
>     __type(key,  __u32);
>     __type(value,  struct datarec);
> }  xdp_stats_map SEC(".maps");
>
> I used this to load my program
> https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c
>
> But now it fails to load. First thing I noticed was the I had to
> change "maps" to ".maps"
> https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c#L563
>
> But then bpf_create_map_node fails because all the arguments are 0. I
> dumped the buffer here
> https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c#L489
> and it just copies 28 bytes of zeroes for each map I have.
>
> How do you load BTF style maps? bpf_load.c doesn't seem to work on them.

Hmm, bpf_load.c seems to be using old-style loading (not libbpf) and so
wouldn't understand BTF-defined maps. I guess we should fix that.

In the meantime, you can try one of the following options:

Use xdp-loader from xdp-tools (since this seems to be an XDP use case?):
https://github.com/xdp-project/xdp-tools

Use bpftool (in tools/bpf/bpftool in the kernel source tree).

-Toke
