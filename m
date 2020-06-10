Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgFJVIP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 17:08:15 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93614C03E96B
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:08:15 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id y123so2161344vsb.6
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
 <87imfy7hrx.fsf@toke.dk>
In-Reply-To: <87imfy7hrx.fsf@toke.dk>
From: Elerion <elerion1000@gmail.com>
Date: Wed, 10 Jun 2020 14:08:03 -0700
Message-ID: <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
Subject: Re: Error loading xdp program that worked with bpf_load
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: xdp-newbies@vger.kernel.org

Here is the full dump.

bpf_object__open
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
[4] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=2
[5] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
[6] PTR (anon) type_id=7
[7] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=1
[8] PTR (anon) type_id=9
[9] TYPEDEF uint32_t type_id=10
[10] TYPEDEF __uint32_t type_id=11
[11] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
[12] PTR (anon) type_id=13
[13] STRUCT config size=48 vlen=6
        lock type_id=14 bits_offset=0
        new_conn_limit type_id=16 bits_offset=64
        rate_limit type_id=16 bits_offset=128
        main_ip type_id=18 bits_offset=192
        new_ip_count type_id=16 bits_offset=256
        new_ip_timestamp type_id=16 bits_offset=320
[14] STRUCT bpf_spin_lock size=4 vlen=1
        val type_id=15 bits_offset=0
[15] TYPEDEF __u32 type_id=11
[16] TYPEDEF uint_fast64_t type_id=17
[17] INT long long unsigned int size=8 bits_offset=0 nr_bits=64 encoding=(none)
[18] TYPEDEF uint_fast32_t type_id=11
[19] VAR config_map type_id=1 linkage=1
[20] STRUCT (anon) size=32 vlen=4
        type type_id=21 bits_offset=0
        max_entries type_id=6 bits_offset=64
        key type_id=8 bits_offset=128
        value type_id=23 bits_offset=192
[21] PTR (anon) type_id=22

        value type_id=8 bits_offset=192
[49] PTR (anon) type_id=50
[50] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=17
[51] PTR (anon) type_id=52
[52] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=128
[53] VAR xsk_map type_id=48 linkage=1
[54] STRUCT (anon) size=32 vlen=4
        type type_id=6 bits_offset=0
        max_entries type_id=27 bits_offset=64
        key type_id=8 bits_offset=128
        value type_id=55 bits_offset=192
[55] PTR (anon) type_id=56
[56] STRUCT server_rate_limit_entry size=72 vlen=9
        under_attack_start type_id=16 bits_offset=0
        under_attack_last type_id=16 bits_offset=64
        packets_sent type_id=16 bits_offset=128
        packets_sent_time type_id=16 bits_offset=192
        tcp_packets type_id=16 bits_offset=256
        misc_packets type_id=16 bits_offset=320
        a2s_packets type_id=16 bits_offset=384
        a2sinfo_packets type_id=16 bits_offset=448
        syn_packets type_id=16 bits_offset=512
[57] VAR server_rate_limits type_id=54 linkage=1
[58] STRUCT (anon) size=32 vlen=4
        type type_id=59 bits_offset=0
        max_entries type_id=61 bits_offset=64
        key type_id=8 bits_offset=128
        value type_id=63 bits_offset=192
[59] PTR (anon) type_id=60
[60] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=9
[61] PTR (anon) type_id=62
[62] ARRAY (anon) type_id=3 index_type_id=5 nr_elems=65536
[63] PTR (anon) type_id=64
[64] STRUCT ip_addr_history size=24 vlen=3
        timestamp type_id=16 bits_offset=0
        hits type_id=16 bits_offset=64
        created type_id=16 bits_offset=128
[65] VAR client_rate_limits type_id=58 linkage=1
[66] PTR (anon) type_id=67
[67] STRUCT xdp_md size=20 vlen=5
        data type_id=15 bits_offset=0
        data_end type_id=15 bits_offset=32
        data_meta type_id=15 bits_offset=64
        ingress_ifindex type_id=15 bits_offset=96
        rx_queue_index type_id=15 bits_offset=128
[68] FUNC_PROTO (anon) return=3 args=(66 ctx)
[69] FUNC xdp_program type_id=68 vlen != 0

libbpf: Error loading .BTF into kernel: -22.
bpf_object__find_program_by_title
Segmentation fault (core dumped)

On Wed, Jun 10, 2020 at 2:06 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
> Elerion <elerion1000@gmail.com> writes:
>
> > I used this to load my xdp program
> > https://github.com/torvalds/linux/blob/master/samples/bpf/bpf_load.c
> > but it doesn't seem to work on new style maps so I am using libbpf
> > bpf_object__open now.
> >
> > But now it shows this
> >
> > libbpf: Error loading BTF: Invalid argument(22)
> > libbpf: magic: 0xeb9f
> > version: 1
> > flags: 0x0
> > hdr_len: 24
> > type_off: 0
> > type_len: 2088
> > str_off: 2088
> > str_len: 11234
> > btf_total_size: 13346
> > [1] STRUCT (anon) size=32 vlen=4
> >         type type_id=2 bits_offset=0
> >         max_entries type_id=6 bits_offset=64
> >         key type_id=8 bits_offset=128
> >         value type_id=12 bits_offset=192
> > [2] PTR (anon) type_id=4
> > [3] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> > more type information....
> > libbpf: Error loading .BTF into kernel: -22.
> >
> > How do I fix this?
>
> Usually the last line of type information (which it looks like you
> snipped above?) contains the error, although sometimes it can be hard to
> spot because it looks like part of the type...
>
> -Toke
>
