Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51519 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728899AbgAOWVS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 17:21:18 -0500
Received: by mail-lj1-f198.google.com with SMTP id z2so4461462ljh.16
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 14:21:13 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP invalid memory access
In-Reply-To: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
Date: Wed, 15 Jan 2020 23:21:10 +0100
Message-ID: <87ftggtl7t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Vincent Li <mchun.li@gmail.com>, xdp-newbies@vger.kernel.org

Vincent Li <mchun.li@gmail.com> writes:

> Hi,
>
> I am writing a sample XDP program to parse tcp packet options, code
> below, compiled ok, when I attach it to a network interface
>
> #clang -O2 -emit-llvm -c tcp_option.c -o - |llc -march=bpf
> -filetype=obj -o tcp_option.o
>
>
> # ip link set dev enp3s0 xdpgeneric object tcp_option.o verbose
>
>
> Prog section 'prog' rejected: Permission denied (13)!
>
>  - Type:         6
>
>  - Instructions: 42 (0 over limit)
>
>  - License:      GPL
>
>
> Verifier analysis:
>
>
> 0: (61) r2 = *(u32 *)(r1 +4)
>
> 1: (61) r1 = *(u32 *)(r1 +0)
>
> 2: (bf) r3 = r1
>
> 3: (07) r3 += 54
>
> 4: (b7) r0 = 2
>
> 5: (2d) if r3 > r2 goto pc+35
>
>  R0_w=inv2 R1_w=pkt(id=0,off=0,r=54,imm=0)
> R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=54,r=54,imm=0)
> R10=fp0
>
> 6: (71) r2 = *(u8 *)(r1 +12)
>
> 7: (71) r3 = *(u8 *)(r1 +13)
>
> 8: (67) r3 <<= 8
>
> 9: (4f) r3 |= r2
>
> 10: (b7) r0 = 2
>
> 11: (55) if r3 != 0x8 goto pc+29
>
>  R0_w=inv2 R1_w=pkt(id=0,off=0,r=54,imm=0)
> R2_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R3_w=inv8 R10=fp0
>
> 12: (71) r2 = *(u8 *)(r1 +23)
>
> 13: (b7) r0 = 2
>
> 14: (55) if r2 != 0x6 goto pc+26
>
>  R0=inv2 R1=pkt(id=0,off=0,r=54,imm=0) R2=inv6 R3=inv8 R10=fp0
>
> 15: (69) r1 = *(u16 *)(r1 +46)
>
> 16: (bf) r2 = r1
>
> 17: (57) r2 &= 7936
>
> 18: (b7) r0 = 2
>
> 19: (55) if r2 != 0x200 goto pc+21
>
>  R0_w=inv2 R1_w=inv(id=0,umax_value=65535,var_off=(0x0; 0xffff))
> R2_w=inv512 R3=inv8 R10=fp0
>
> 20: (77) r1 >>= 2
>
> 21: (57) r1 &= 60
>
> 22: (07) r1 += -20
>
> 23: (18) r2 = 0x0
>
> 25: (63) *(u32 *)(r2 +0) = r1
>
> R2 invalid mem access 'inv' <----------------
>
> processed 25 insns (limit 1000000) max_states_per_insn 0 total_states
> 1 peak_states 1 mark_read 1
>
>
> it appears optlen = tcphdr->doff*4 - sizeof(*tcphdr); is invalid ? if
> I comment out lines between 60 and 73, no problem with invalid mem
> access

You have to check that you're not reading out of bounds before
dereferencing the bytes in the TCP header...

-Toke
