Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:38044 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbdH1Tyj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 28 Aug 2017 15:54:39 -0400
Received: by mail-pg0-f47.google.com with SMTP id b8so4284766pgn.5
        for <xdp-newbies@vger.kernel.org>; Mon, 28 Aug 2017 12:54:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59A46042.5040909@iogearbox.net>
References: <CAC1LvL0WgC0bqEuGHp+LepyajskFdAkPruKY-9F6rL=zf49RKw@mail.gmail.com>
 <59A46042.5040909@iogearbox.net>
From: Zvi Effron <zeffron@riotgames.com>
Date: Mon, 28 Aug 2017 12:54:38 -0700
Message-ID: <CAC1LvL08ssH4=wekLdYJAmD0wrTJ4JKBJGEDfVay5oMGV3+LGw@mail.gmail.com>
Subject: Re: Issues with bpf_trace_printk
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: xdp-newbies@vger.kernel.org

64bit kernel (4.12.8-300.fc26.x86_64) running in a VM.

[root@localhost scratch]# ip link set dev eth0 xdp object
/root/xdp/xdp_test_kern.o section .text verbose

Prog section '.text' loaded (5)!
 - Type:         6
 - Instructions: 63 (0 over limit)
 - License:      GPL

Verifier analysis:

0: (bf) r6 = r1
1: (b7) r1 = 0
2: (73) *(u8 *)(r10 -4) = r1
3: (b7) r1 = 175645984
4: (63) *(u32 *)(r10 -8) = r1
5: (18) r1 = 0x3a646e6520617461
7: (7b) *(u64 *)(r10 -16) = r1
8: (18) r1 = 0x44097825203a7472
10: (7b) *(u64 *)(r10 -24) = r1
11: (18) r7 = 0x6174732061746144
13: (7b) *(u64 *)(r10 -32) = r7
14: (61) r4 = *(u32 *)(r6 +4)
15: (61) r3 = *(u32 *)(r6 +0)
16: (bf) r1 = r10
17: (07) r1 += -32
18: (b7) r2 = 29
19: (85) call bpf_trace_printk#6
20: (b7) r1 = 10
21: (6b) *(u16 *)(r10 -52) = r1
22: (b7) r1 = 2015699002
23: (63) *(u32 *)(r10 -56) = r1
24: (18) r1 = 0x746e6174736e6f43
26: (7b) *(u64 *)(r10 -64) = r1
27: (bf) r1 = r10
28: (07) r1 += -64
29: (b7) r2 = 14
30: (b7) r3 = 1
31: (85) call bpf_trace_printk#6
32: (61) r1 = *(u32 *)(r6 +0)
33: (55) if r1 != 0x0 goto pc+11
 R0=inv R1=pkt(id=0,off=0,r=0),min_value=0,max_value=0 R6=ctx
R7=imm7022364301888610628 R10=fp
34: (18) r1 = 0x30207465736666
36: (7b) *(u64 *)(r10 -48) = r1
37: (18) r1 = 0x6f20746120737472
39: (7b) *(u64 *)(r10 -56) = r1
40: (7b) *(u64 *)(r10 -64) = r7
41: (bf) r1 = r10
42: (07) r1 += -64
43: (b7) r2 = 24
44: (85) call bpf_trace_printk#6
45: (61) r1 = *(u32 *)(r6 +4)
46: (55) if r1 != 0x0 goto pc+14
 R0=inv R1=pkt_end,min_value=0,max_value=0 R6=ctx
R7=imm7022364301888610628 R10=fp
47: (b7) r1 = 48
48: (6b) *(u16 *)(r10 -44) = r1
49: (b7) r1 = 544499059
50: (63) *(u32 *)(r10 -48) = r1
51: (18) r1 = 0x66666f2074612073
53: (7b) *(u64 *)(r10 -56) = r1
54: (18) r1 = 0x646e652061746144
56: (7b) *(u64 *)(r10 -64) = r1
57: (bf) r1 = r10
58: (07) r1 += -64
59: (b7) r2 = 22
60: (85) call bpf_trace_printk#6
61: (b7) r0 = 2
62: (95) exit

from 46 to 61: safe

from 33 to 45: R0=inv R1=pkt(id=0,off=0,r=0) R6=ctx
R7=imm7022364301888610628 R10=fp
45: (61) r1 = *(u32 *)(r6 +4)
46: (55) if r1 != 0x0 goto pc+14
 R0=inv R1=pkt_end,min_value=0,max_value=0 R6=ctx
R7=imm7022364301888610628 R10=fp
47: (b7) r1 = 48
48: (6b) *(u16 *)(r10 -44) = r1
49: (b7) r1 = 544499059
50: (63) *(u32 *)(r10 -48) = r1
51: (18) r1 = 0x66666f2074612073
53: (7b) *(u64 *)(r10 -56) = r1
54: (18) r1 = 0x646e652061746144
56: (7b) *(u64 *)(r10 -64) = r1
57: (bf) r1 = r10
58: (07) r1 += -64
59: (b7) r2 = 22
60: (85) call bpf_trace_printk#6
61: (b7) r0 = 2
62: (95) exit

from 46 to 61: R0=inv R1=pkt_end R6=ctx R7=imm7022364301888610628 R10=fp
61: (b7) r0 = 2
62: (95) exit
processed 74 insns

Thanks!
--Zvi

On Mon, Aug 28, 2017 at 11:26 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 08/28/2017 07:20 PM, Zvi Effron wrote:
>>
>> Hello,
>>
>> I'm having an issue where bpf_trace_printk seems to always print 0 for
>> values. I'm running the following xdp program:
>>
>>
>> #include <uapi/linux/bpf.h>
>>
>> static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
>> (void *) BPF_FUNC_trace_printk;
>>
>> int xdp(struct xdp_md *ctx) {
>>      char format_string[] = "Data start: %x\tData end: %x\n";
>>      bpf_trace_printk(format_string, sizeof(format_string), ctx->data,
>> ctx->data_end);
>>
>>      {
>>          char format_string[] = "Constant: %x\n";
>>          bpf_trace_printk(format_string, sizeof(format_string), 1);
>>      }
>>
>>      if (ctx->data == 0) {
>>          char format_string[] = "Data starts at offset 0";
>>          bpf_trace_printk(format_string, sizeof(format_string));
>>      }
>>      if (ctx->data_end == 0) {
>>          char format_string[] = "Data ends at offset 0";
>>          bpf_trace_printk(format_string, sizeof(format_string));
>>      }
>>      return XDP_PASS;
>> }
>>
>> char __attribute__((section("license"), used)) license[] = "GPL";
>>
>>
>> and I get the following output in /sys/kernel/debug/tracing/trace_pipe
>>
>>
>>              sshd-4824  [000] ..s1 67372.673714: : Data start: 0 Data end:
>> 0
>>              sshd-4824  [000] ..s1 67372.673720: : Constant: 0
>>            <idle>-0     [000] ..s. 67372.675062: : Data start: 0 Data end:
>> 0
>>            <idle>-0     [000] .Ns. 67372.675090: : Constant: 0
>>            <idle>-0     [000] .Ns. 67372.675116: : Data start: 0 Data end:
>> 0
>>            <idle>-0     [000] .Ns. 67372.675117: : Constant: 0
>>            <idle>-0     [000] .Ns. 67372.675129: : Data start: 0 Data end:
>> 0
>>            <idle>-0     [000] .Ns. 67372.675130: : Constant: 0
>>            <idle>-0     [000] .Ns. 67372.675136: : Data start: 0 Data end:
>> 0
>>            <idle>-0     [000] .Ns. 67372.675137: : Constant: 0
>>            <idle>-0     [000] .Ns. 67372.675142: : Data start: 0 Data end:
>> 0
>>            <idle>-0     [000] .Ns. 67372.675143: : Constant: 0
>>                ip-6458  [000] ..s. 67372.676083: : Data start: 0 Data end:
>> 0
>>                ip-6458  [000] ..s. 67372.676084: : Constant: 0
>>                ip-6458  [000] ..s. 67372.676093: : Data start: 0 Data end:
>> 0
>>                ip-6458  [000] ..s. 67372.676094: : Constant: 0
>>
>>
>> It looks like ctx->data and ctx->data_end are not 0, because the calls
>> to bpf_trace_printk in those ifs aren't being called, and the constant
>> is definitely not 0.
>>
>> What might I be missing or doing incorrectly?
>
>
> Are you on 32bit? Could you dump the verifier output?
>
> Thanks,
> Daniel
