Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgFJVpN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 17:45:13 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ECDC03E96B
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:45:12 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id p187so989830vkf.0
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
 <87imfy7hrx.fsf@toke.dk> <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
 <87a71a7gay.fsf@toke.dk>
In-Reply-To: <87a71a7gay.fsf@toke.dk>
From: Elerion <elerion1000@gmail.com>
Date: Wed, 10 Jun 2020 14:44:58 -0700
Message-ID: <CAMDScmkJNWXnYxJuFjUQSOte-Wh_kmO_M-b9raEE8Ban9nzpnQ@mail.gmail.com>
Subject: Re: Error loading xdp program that worked with bpf_load
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: xdp-newbies@vger.kernel.org

[1] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=2 bits_offset=0
        'max_entries' type_id=6 bits_offset=64
        'key' type_id=8 bits_offset=128
        'value' type_id=12 bits_offset=192
[2] PTR '(anon)' type_id=4
[3] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[4] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=2
[5] INT '__ARRAY_SIZE_TYPE__' size=4 bits_offset=0 nr_bits=32 encoding=(none)
[6] PTR '(anon)' type_id=7
[7] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=1
[8] PTR '(anon)' type_id=9
[9] TYPEDEF 'uint32_t' type_id=10
[10] TYPEDEF '__uint32_t' type_id=11
[11] INT 'unsigned int' size=4 bits_offset=0 nr_bits=32 encoding=(none)
[12] PTR '(anon)' type_id=13
[13] STRUCT 'config' size=48 vlen=6
        'lock' type_id=14 bits_offset=0
        'new_conn_limit' type_id=16 bits_offset=64
        'rate_limit' type_id=16 bits_offset=128
        'main_ip' type_id=18 bits_offset=192
        'new_ip_count' type_id=16 bits_offset=256
        'new_ip_timestamp' type_id=16 bits_offset=320
[14] STRUCT 'bpf_spin_lock' size=4 vlen=1
        'val' type_id=15 bits_offset=0
[15] TYPEDEF '__u32' type_id=11
[16] TYPEDEF 'uint_fast64_t' type_id=17
[17] INT 'long long unsigned int' size=8 bits_offset=0 nr_bits=64
encoding=(none)
[18] TYPEDEF 'uint_fast32_t' type_id=11
[19] VAR 'config_map' type_id=1, linkage=global-alloc
[20] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=21 bits_offset=0
        'max_entries' type_id=6 bits_offset=64
        'key' type_id=8 bits_offset=128
        'value' type_id=23 bits_offset=192
[21] PTR '(anon)' type_id=22
[22] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=6
[23] PTR '(anon)' type_id=24
[24] STRUCT 'global_stats' size=40 vlen=5
        'packet_in' type_id=16 bits_offset=0
        'packet_out' type_id=16 bits_offset=64
        'bytes_in' type_id=16 bits_offset=128
        'bytes_out' type_id=16 bits_offset=192
        'packets_dropped' type_id=16 bits_offset=256
[25] VAR 'stats_map' type_id=20, linkage=global-alloc
[26] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=6 bits_offset=0
        'max_entries' type_id=27 bits_offset=64
        'key' type_id=29 bits_offset=128
        'value' type_id=32 bits_offset=192
[27] PTR '(anon)' type_id=28
[28] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=512
[29] PTR '(anon)' type_id=30
[30] TYPEDEF 'uint64_t' type_id=31
[31] TYPEDEF '__uint64_t' type_id=17
[32] PTR '(anon)' type_id=33
[33] STRUCT 'forwarding_rule' size=40 vlen=9
        'bind_addr' type_id=9 bits_offset=0
        'bind_port' type_id=34 bits_offset=32
        'to_addr' type_id=9 bits_offset=64
        'to_port' type_id=34 bits_offset=96
        'steam_port' type_id=34 bits_offset=112
        'inner_addr' type_id=9 bits_offset=128
        'a2s_info_cache' type_id=18 bits_offset=160
        'cache_time' type_id=16 bits_offset=192
        'tcp_port1' type_id=34 bits_offset=256
[34] TYPEDEF 'uint16_t' type_id=35
[35] TYPEDEF '__uint16_t' type_id=36
[36] INT 'unsigned short' size=2 bits_offset=0 nr_bits=16 encoding=(none)
[37] VAR 'tunnel_map' type_id=26, linkage=global-alloc
[38] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=2 bits_offset=0
        'max_entries' type_id=27 bits_offset=64
        'key' type_id=8 bits_offset=128
        'value' type_id=32 bits_offset=192
[39] VAR 'forwarding_map' type_id=38, linkage=global-alloc
[40] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=6 bits_offset=0
        'max_entries' type_id=27 bits_offset=64
        'key' type_id=8 bits_offset=128
        'value' type_id=41 bits_offset=192
[41] PTR '(anon)' type_id=42
[42] STRUCT 'a2s_info_cache_entry' size=40 vlen=6
        'age' type_id=30 bits_offset=0
        'misses' type_id=30 bits_offset=64
        'hits' type_id=30 bits_offset=128
        'udp_data' type_id=43 bits_offset=192
        'len' type_id=34 bits_offset=256
        'csum' type_id=9 bits_offset=288
[43] PTR '(anon)' type_id=44
[44] TYPEDEF 'uint8_t' type_id=45
[45] TYPEDEF '__uint8_t' type_id=46
[46] INT 'unsigned char' size=1 bits_offset=0 nr_bits=8 encoding=(none)
[47] VAR 'a2s_info_cache_map' type_id=40, linkage=global-alloc
[48] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=49 bits_offset=0

        'key' type_id=8 bits_offset=128
        'value' type_id=8 bits_offset=192
[49] PTR '(anon)' type_id=50
[50] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=17
[51] PTR '(anon)' type_id=52
[52] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=128
[53] VAR 'xsk_map' type_id=48, linkage=global-alloc
[54] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=6 bits_offset=0
        'max_entries' type_id=27 bits_offset=64
        'key' type_id=8 bits_offset=128
        'value' type_id=55 bits_offset=192
[55] PTR '(anon)' type_id=56
[56] STRUCT 'server_rate_limit_entry' size=72 vlen=9
        'under_attack_start' type_id=16 bits_offset=0
        'under_attack_last' type_id=16 bits_offset=64
        'packets_sent' type_id=16 bits_offset=128
        'packets_sent_time' type_id=16 bits_offset=192
        'tcp_packets' type_id=16 bits_offset=256
        'misc_packets' type_id=16 bits_offset=320
        'a2s_packets' type_id=16 bits_offset=384
        'a2sinfo_packets' type_id=16 bits_offset=448
        'syn_packets' type_id=16 bits_offset=512
[57] VAR 'server_rate_limits' type_id=54, linkage=global-alloc
[58] STRUCT '(anon)' size=32 vlen=4
        'type' type_id=59 bits_offset=0
        'max_entries' type_id=61 bits_offset=64
        'key' type_id=8 bits_offset=128
        'value' type_id=63 bits_offset=192
[59] PTR '(anon)' type_id=60
[60] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=9
[61] PTR '(anon)' type_id=62
[62] ARRAY '(anon)' type_id=3 index_type_id=5 nr_elems=65536
[63] PTR '(anon)' type_id=64
[64] STRUCT 'ip_addr_history' size=24 vlen=3
        'timestamp' type_id=16 bits_offset=0
        'hits' type_id=16 bits_offset=64
        'created' type_id=16 bits_offset=128
[65] VAR 'client_rate_limits' type_id=58, linkage=global-alloc
[66] PTR '(anon)' type_id=67
[67] STRUCT 'xdp_md' size=20 vlen=5
        'data' type_id=15 bits_offset=0
        'data_end' type_id=15 bits_offset=32
        'data_meta' type_id=15 bits_offset=64
        'ingress_ifindex' type_id=15 bits_offset=96
        'rx_queue_index' type_id=15 bits_offset=128
[68] FUNC_PROTO '(anon)' ret_type_id=3 vlen=1
        'ctx' type_id=66
[69] FUNC 'xdp_program' type_id=68
[70] INT 'char' size=1 bits_offset=0 nr_bits=8 encoding=SIGNED
[71] ARRAY '(anon)' type_id=70 index_type_id=5 nr_elems=4
[72] VAR '_license' type_id=71, linkage=global-alloc
[73] DATASEC '.maps' size=0 vlen=8
        type_id=19 offset=0 size=32
        type_id=25 offset=0 size=32
        type_id=37 offset=0 size=32
        type_id=39 offset=0 size=32
        type_id=47 offset=0 size=32
        type_id=53 offset=0 size=32
        type_id=57 offset=0 size=32
        type_id=65 offset=0 size=32
[74] DATASEC 'license' size=0 vlen=1
        type_id=72 offset=0 size=4

On Wed, Jun 10, 2020 at 2:38 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
> Elerion <elerion1000@gmail.com> writes:
>
> > [69] FUNC xdp_program type_id=68 vlen != 0
>
> 'vlen != 0' is the error. Not sure why you hit that; what's the output
> of 'bpftool btf dump file yourprog.o' ?
>
> -Toke
>
