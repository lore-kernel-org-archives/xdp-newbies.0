Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36774 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726134AbgFJVGR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 17:06:17 -0400
Received: by mail-ej1-f70.google.com with SMTP id i17so1670925ejb.9
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:06:13 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Error loading xdp program that worked with bpf_load
In-Reply-To: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
Date: Wed, 10 Jun 2020 23:06:10 +0200
Message-ID: <87imfy7hrx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Elerion <elerion1000@gmail.com>, xdp-newbies@vger.kernel.org

Elerion <elerion1000@gmail.com> writes:

> I used this to load my xdp program
> https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c
> but it doesn't seem to work on new style maps so I am using libbpf
> bpf_object__open now.
>
> But now it shows this
>
> libbpf: Error loading BTF: Invalid argument(22)
> libbpf: magic: 0xeb9f
> version: 1
> flags: 0x0
> hdr_len: 24
> type_off: 0
> type_len: 2088
> str_off: 2088
> str_len: 11234
> btf_total_size: 13346
> [1] STRUCT (anon) size=32 vlen=4
>         type type_id=2 bits_offset=0
>         max_entries type_id=6 bits_offset=64
>         key type_id=8 bits_offset=128
>         value type_id=12 bits_offset=192
> [2] PTR (anon) type_id=4
> [3] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> more type information....
> libbpf: Error loading .BTF into kernel: -22.
>
> How do I fix this?

Usually the last line of type information (which it looks like you
snipped above?) contains the error, although sometimes it can be hard to
spot because it looks like part of the type...

-Toke
