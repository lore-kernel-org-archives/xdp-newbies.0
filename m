Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28433 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731650AbgAPJpm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 Jan 2020 04:45:42 -0500
Received: by mail-lf1-f71.google.com with SMTP id 6so3760746lfj.17
        for <xdp-newbies@vger.kernel.org>; Thu, 16 Jan 2020 01:45:39 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP invalid memory access
In-Reply-To: <20200116022459.GA2853@ranger.igk.intel.com>
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com> <20200116022459.GA2853@ranger.igk.intel.com>
Date: Thu, 16 Jan 2020 10:45:36 +0100
Message-ID: <87y2u7spj3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Vincent Li <mchun.li@gmail.com>
Cc: xdp-newbies@vger.kernel.org, daniel@iogearbox.net, andriin@fb.com, dsahern@gmail.com

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Wed, Jan 15, 2020 at 02:11:04PM -0800, Vincent Li wrote:
>> Hi,
>> 
>> I am writing a sample XDP program to parse tcp packet options, code
>> below, compiled ok, when I attach it to a network interface
>> 
>> #clang -O2 -emit-llvm -c tcp_option.c -o - |llc -march=bpf
>> -filetype=obj -o tcp_option.o
>> 
>> 
>> # ip link set dev enp3s0 xdpgeneric object tcp_option.o verbose
>> 
>> 
>> Prog section 'prog' rejected: Permission denied (13)!
>> 
>>  - Type:         6
>> 
>>  - Instructions: 42 (0 over limit)
>> 
>>  - License:      GPL
>> 
>> 
>> Verifier analysis:
>> 
>> 
>> 0: (61) r2 = *(u32 *)(r1 +4)
>> 
>> 1: (61) r1 = *(u32 *)(r1 +0)
>> 
>> 2: (bf) r3 = r1
>> 
>> 3: (07) r3 += 54
>> 
>> 4: (b7) r0 = 2
>> 
>> 5: (2d) if r3 > r2 goto pc+35
>> 
>>  R0_w=inv2 R1_w=pkt(id=0,off=0,r=54,imm=0)
>> R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=54,r=54,imm=0)
>> R10=fp0
>> 
>> 6: (71) r2 = *(u8 *)(r1 +12)
>> 
>> 7: (71) r3 = *(u8 *)(r1 +13)
>> 
>> 8: (67) r3 <<= 8
>> 
>> 9: (4f) r3 |= r2
>> 
>> 10: (b7) r0 = 2
>> 
>> 11: (55) if r3 != 0x8 goto pc+29
>> 
>>  R0_w=inv2 R1_w=pkt(id=0,off=0,r=54,imm=0)
>> R2_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R3_w=inv8 R10=fp0
>> 
>> 12: (71) r2 = *(u8 *)(r1 +23)
>> 
>> 13: (b7) r0 = 2
>> 
>> 14: (55) if r2 != 0x6 goto pc+26
>> 
>>  R0=inv2 R1=pkt(id=0,off=0,r=54,imm=0) R2=inv6 R3=inv8 R10=fp0
>> 
>> 15: (69) r1 = *(u16 *)(r1 +46)
>> 
>> 16: (bf) r2 = r1
>> 
>> 17: (57) r2 &= 7936
>> 
>> 18: (b7) r0 = 2
>> 
>> 19: (55) if r2 != 0x200 goto pc+21
>> 
>>  R0_w=inv2 R1_w=inv(id=0,umax_value=65535,var_off=(0x0; 0xffff))
>> R2_w=inv512 R3=inv8 R10=fp0
>> 
>> 20: (77) r1 >>= 2
>> 
>> 21: (57) r1 &= 60
>> 
>> 22: (07) r1 += -20
>> 
>> 23: (18) r2 = 0x0
>> 
>> 25: (63) *(u32 *)(r2 +0) = r1
>> 
>> R2 invalid mem access 'inv' <----------------
>
> So it's not out of the bounds access but rather null dereference since r2
> has been loaded with 0 on previous insn.
>
>> 
>> processed 25 insns (limit 1000000) max_states_per_insn 0 total_states
>> 1 peak_states 1 mark_read 1
>> 
>> 
>> it appears optlen = tcphdr->doff*4 - sizeof(*tcphdr); is invalid ? if
>> I comment out lines between 60 and 73, no problem with invalid mem
>> access
>
> I see that optlen is a global variable. This line might be valid but
> you're using iproute2's loader for your XDP program, right? AFAIK it
> doesn't have support for BPF global variables, only libbpf does (Daniel,
> Andrii? is that true?).

Yes, this is true. Converting the iproute2 loader is still on my todo list...

> So you have to either make the optlen a local variable or go with writing
> the loader part that is based on libbpf usage (see samples/bpf directory
> in kernel tree, for example xdp1_user.c).

You could also try the xdp-loader in xdp-tools:
https://github.com/xdp-project/xdp-tools

It's somewhat basic still, but should be able to at least load a basic
program - please file a bug report if it fails.

-Toke
