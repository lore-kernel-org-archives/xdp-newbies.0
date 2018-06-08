Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl0-f45.google.com ([209.85.160.45]:39311 "EHLO
        mail-pl0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbeFHQci (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Jun 2018 12:32:38 -0400
Received: by mail-pl0-f45.google.com with SMTP id f1-v6so8611493plt.6
        for <xdp-newbies@vger.kernel.org>; Fri, 08 Jun 2018 09:32:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d4fa48f4-966b-4cf5-9c4e-c33973b1dcaf@iogearbox.net>
References: <CAC1LvL21L=Zo2_5NQhyDVr8ciPwyExMhuAO2-7MQ97OPuV5y9A@mail.gmail.com>
 <8e8268eb-5a36-a260-2c4c-5db61b4f9db7@solarflare.com> <CAC1LvL33hYab98swyP5J3wm0J7LZr5J6t36LRzdiAYTrdbXmGQ@mail.gmail.com>
 <d4fa48f4-966b-4cf5-9c4e-c33973b1dcaf@iogearbox.net>
From: Zvi Effron <zeffron@riotgames.com>
Date: Fri, 8 Jun 2018 09:32:37 -0700
Message-ID: <CAC1LvL0Dr5fnrB73g7erg-PWMoJ2kuDF0mB6=HxwqPpbg+C_bA@mail.gmail.com>
Subject: Re: Is it possible to read from a dynamic offset in a packet?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Edward Cree <ecree@solarflare.com>, Xdp <xdp-newbies@vger.kernel.org>

Thanks very much, that trick worked!

--Zvi

On Fri, Jun 8, 2018 at 5:44 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 06/07/2018 10:51 PM, Zvi Effron wrote:
>> Thank you! That works when I write the opcodes by hand.
>>
>> When using clang (6.0.0) to compile from C code, however, the register
>> allocator does not seem to want to reuse the register it used for the
>> comparison for the read, causing a verifier failure.
>> Is there a good method for getting clang to reuse the register it used
>> for the comparison for the read?
>>
>> ===== BEGIN CODE =====
>> #include <linux/bpf.h>
>> #include <linux/if_ether.h>
>> #include <linux/ip.h>
>>
>> static int (*bpf_trace_printk)(const char* fmt, int fmt_size, ...) =
>> (void *)BPF_FUNC_trace_printk;
>>
>> int xdp_program(struct xdp_md *context) {
>> void* frame_end = (void *)(long)context->data_end;
>>
>> void *frame_start = (void*)(long)context->data;
>> if (frame_start + sizeof(struct ethhdr) + sizeof(struct iphdr) > frame_end) {
>> return XDP_PASS;
>> }
>>
>> if (__builtin_bswap16(((struct ethhdr*)frame_start)->h_proto) != ETH_P_IP) {
>> return XDP_PASS;
>> }
>>
>> __u16 payload_length = __builtin_bswap16(((struct iphdr*)(frame_start
>> + sizeof(struct ethhdr)))->tot_len - sizeof(struct iphdr));
>> if (payload_length > 1500) {
>> return XDP_PASS;
>> }
>>
>> if (frame_start + sizeof(struct ethhdr) + sizeof(struct iphdr) +
>> payload_length > frame_end) {
>> return XDP_PASS;
>> }
>> int last_byte_payload_offset = payload_length - 1;
>> __u8 byte = ((__u8*)frame_start + sizeof(struct ethhdr) +
>> sizeof(struct iphdr))[last_byte_payload_offset];
>> char fmt[] = "Packet's last byte was 0x%x\n";
>> bpf_trace_printk(fmt, sizeof(fmt), byte);
>
> Should break here in the last part since verifier is only aware that
> access up to frame_start + sizeof(struct ethhdr) + sizeof(struct iphdr)
> is safe. So you would need roughly something like this:
>
> __u8 *ptr = frame_start + sizeof(struct ethhdr) + sizeof(struct iphdr) +
>             last_byte_payload_offset
> if (ptr + 1 > frame_end)
>     return ...;
> bpf_trace_printk(fmt, sizeof(fmt), *ptr);
>
> Cheers,
> Daniel
>
>> return XDP_TX;
>> }
>>
>> char _license[] __attribute__((section("license"), used)) = "GPL";
>> ===== END CODE =====
>>
>> The above code was compiled with clang -O2 -Wall -Werror -target bpf -c -g.
>>
>> When attempting to install the program, the verifier complained with
>>
>> ===== BEGIN VERIFIER OUTPUT =====
>> Verifier analysis:
>>
>> 0: (b7) r0 = 2
>> 1: (61) r2 = *(u32 *)(r1 +4)
>> 2: (61) r3 = *(u32 *)(r1 +0)
>> 3: (bf) r1 = r3
>> 4: (07) r1 += 34
>> 5: (2d) if r1 > r2 goto pc+32
>>  R0=inv2 R1=pkt(id=0,off=34,r=34,imm=0) R2=pkt_end(id=0,off=0,imm=0)
>> R3=pkt(id=0,off=0,r=34,imm=0) R10=fp0,call_-1
>> 6: (71) r4 = *(u8 *)(r3 +12)
>> 7: (71) r5 = *(u8 *)(r3 +13)
>> 8: (67) r5 <<= 8
>> 9: (4f) r5 |= r4
>> 10: (55) if r5 != 0x8 goto pc+27
>>  R0=inv2 R1=pkt(id=0,off=34,r=34,imm=0) R2=pkt_end(id=0,off=0,imm=0)
>> R3=pkt(id=0,off=0,r=34,imm=0) R4=inv(id=0,umax_value=255,var_off=(0x0;
>> 0xff)) R5=inv8 R10=fp0,call_-1
>> 11: (69) r3 = *(u16 *)(r3 +16)
>> 12: (07) r3 += 65516
>> 13: (dc) r3 = be16 r3
>> 14: (25) if r3 > 0x5dc goto pc+23
>>  R0=inv2 R1=pkt(id=0,off=34,r=34,imm=0) R2=pkt_end(id=0,off=0,imm=0)
>> R3=inv(id=0,umax_value=1500,var_off=(0x0; 0x7ff))
>> R4=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R5=inv8
>> R10=fp0,call_-1
>> 15: (bf) r4 = r1
>> 16: (0f) r4 += r3
>> 17: (2d) if r4 > r2 goto pc+20
>>  R0=inv2 R1=pkt(id=0,off=34,r=34,imm=0) R2=pkt_end(id=0,off=0,imm=0)
>> R3=inv(id=0,umax_value=1500,var_off=(0x0; 0x7ff))
>> R4=pkt(id=1,off=34,r=34,umax_value=1500,var_off=(0x0; 0x7ff)) R5=inv8
>> R10=fp0,call_-1
>> 18: (0f) r1 += r3
>> 19: (71) r3 = *(u8 *)(r1 -1)
>> invalid access to packet, off=33 size=1, R1(id=2,off=34,r=0)
>> R1 offset is outside of the packet
>>
>> Error fetching program/map!
>> ===== END VERIFIER OUTPUT =====
>>
>> Thank you!
>> --Zvi
