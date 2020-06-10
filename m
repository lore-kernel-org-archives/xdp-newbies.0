Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgFJVBV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 17:01:21 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278B2C03E96B
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:01:21 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id d21so2128828vsh.12
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:01:21 -0700 (PDT)
MIME-Version: 1.0
From: Elerion <elerion1000@gmail.com>
Date: Wed, 10 Jun 2020 14:01:09 -0700
Message-ID: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
Subject: Error loading xdp program that worked with bpf_load
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: xdp-newbies@vger.kernel.org

I used this to load my xdp program
https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c
but it doesn't seem to work on new style maps so I am using libbpf
bpf_object__open now.

But now it shows this

libbpf: Error loading BTF: Invalid argument(22)
libbpf: magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 2088
str_off: 2088
str_len: 11234
btf_total_size: 13346
[1] STRUCT (anon) size=32 vlen=4
        type type_id=2 bits_offset=0
        max_entries type_id=6 bits_offset=64
        key type_id=8 bits_offset=128
        value type_id=12 bits_offset=192
[2] PTR (anon) type_id=4
[3] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
more type information....
libbpf: Error loading .BTF into kernel: -22.

How do I fix this?

5.3.0-53-generic #47~18.04.1-Ubuntu SMP Thu May 7 13:10:50 UTC 2020
x86_64 x86_64 x86_64 GNU/Linux
Ubuntu clang version
10.0.1-++20200529024103+a634a80615b-1~exp1~20200529124721.169
Target: x86_64-pc-linux-gnu
