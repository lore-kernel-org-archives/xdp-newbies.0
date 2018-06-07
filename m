Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl0-f43.google.com ([209.85.160.43]:36814 "EHLO
        mail-pl0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbeFGUv6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Jun 2018 16:51:58 -0400
Received: by mail-pl0-f43.google.com with SMTP id a7-v6so4383206plp.3
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Jun 2018 13:51:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8e8268eb-5a36-a260-2c4c-5db61b4f9db7@solarflare.com>
References: <CAC1LvL21L=Zo2_5NQhyDVr8ciPwyExMhuAO2-7MQ97OPuV5y9A@mail.gmail.com>
 <8e8268eb-5a36-a260-2c4c-5db61b4f9db7@solarflare.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Thu, 7 Jun 2018 13:51:57 -0700
Message-ID: <CAC1LvL33hYab98swyP5J3wm0J7LZr5J6t36LRzdiAYTrdbXmGQ@mail.gmail.com>
Subject: Re: Is it possible to read from a dynamic offset in a packet?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Edward Cree <ecree@solarflare.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

Thank you! That works when I write the opcodes by hand.

When using clang (6.0.0) to compile from C code, however, the register
allocator does not seem to want to reuse the register it used for the
comparison for the read, causing a verifier failure.
Is there a good method for getting clang to reuse the register it used
for the comparison for the read?

=3D=3D=3D=3D=3D BEGIN CODE =3D=3D=3D=3D=3D
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>

static int (*bpf_trace_printk)(const char* fmt, int fmt_size, ...) =3D
(void *)BPF_FUNC_trace_printk;

int xdp_program(struct xdp_md *context) {
void* frame_end =3D (void *)(long)context->data_end;

void *frame_start =3D (void*)(long)context->data;
if (frame_start + sizeof(struct ethhdr) + sizeof(struct iphdr) > frame_end)=
 {
return XDP_PASS;
}

if (__builtin_bswap16(((struct ethhdr*)frame_start)->h_proto) !=3D ETH_P_IP=
) {
return XDP_PASS;
}

__u16 payload_length =3D __builtin_bswap16(((struct iphdr*)(frame_start
+ sizeof(struct ethhdr)))->tot_len - sizeof(struct iphdr));
if (payload_length > 1500) {
return XDP_PASS;
}

if (frame_start + sizeof(struct ethhdr) + sizeof(struct iphdr) +
payload_length > frame_end) {
return XDP_PASS;
}
int last_byte_payload_offset =3D payload_length - 1;
__u8 byte =3D ((__u8*)frame_start + sizeof(struct ethhdr) +
sizeof(struct iphdr))[last_byte_payload_offset];
char fmt[] =3D "Packet's last byte was 0x%x\n";
bpf_trace_printk(fmt, sizeof(fmt), byte);

return XDP_TX;
}

char _license[] __attribute__((section("license"), used)) =3D "GPL";
=3D=3D=3D=3D=3D END CODE =3D=3D=3D=3D=3D

The above code was compiled with clang -O2 -Wall -Werror -target bpf -c -g.

When attempting to install the program, the verifier complained with

=3D=3D=3D=3D=3D BEGIN VERIFIER OUTPUT =3D=3D=3D=3D=3D
Verifier analysis:

0: (b7) r0 =3D 2
1: (61) r2 =3D *(u32 *)(r1 +4)
2: (61) r3 =3D *(u32 *)(r1 +0)
3: (bf) r1 =3D r3
4: (07) r1 +=3D 34
5: (2d) if r1 > r2 goto pc+32
 R0=3Dinv2 R1=3Dpkt(id=3D0,off=3D34,r=3D34,imm=3D0) R2=3Dpkt_end(id=3D0,off=
=3D0,imm=3D0)
R3=3Dpkt(id=3D0,off=3D0,r=3D34,imm=3D0) R10=3Dfp0,call_-1
6: (71) r4 =3D *(u8 *)(r3 +12)
7: (71) r5 =3D *(u8 *)(r3 +13)
8: (67) r5 <<=3D 8
9: (4f) r5 |=3D r4
10: (55) if r5 !=3D 0x8 goto pc+27
 R0=3Dinv2 R1=3Dpkt(id=3D0,off=3D34,r=3D34,imm=3D0) R2=3Dpkt_end(id=3D0,off=
=3D0,imm=3D0)
R3=3Dpkt(id=3D0,off=3D0,r=3D34,imm=3D0) R4=3Dinv(id=3D0,umax_value=3D255,va=
r_off=3D(0x0;
0xff)) R5=3Dinv8 R10=3Dfp0,call_-1
11: (69) r3 =3D *(u16 *)(r3 +16)
12: (07) r3 +=3D 65516
13: (dc) r3 =3D be16 r3
14: (25) if r3 > 0x5dc goto pc+23
 R0=3Dinv2 R1=3Dpkt(id=3D0,off=3D34,r=3D34,imm=3D0) R2=3Dpkt_end(id=3D0,off=
=3D0,imm=3D0)
R3=3Dinv(id=3D0,umax_value=3D1500,var_off=3D(0x0; 0x7ff))
R4=3Dinv(id=3D0,umax_value=3D255,var_off=3D(0x0; 0xff)) R5=3Dinv8
R10=3Dfp0,call_-1
15: (bf) r4 =3D r1
16: (0f) r4 +=3D r3
17: (2d) if r4 > r2 goto pc+20
 R0=3Dinv2 R1=3Dpkt(id=3D0,off=3D34,r=3D34,imm=3D0) R2=3Dpkt_end(id=3D0,off=
=3D0,imm=3D0)
R3=3Dinv(id=3D0,umax_value=3D1500,var_off=3D(0x0; 0x7ff))
R4=3Dpkt(id=3D1,off=3D34,r=3D34,umax_value=3D1500,var_off=3D(0x0; 0x7ff)) R=
5=3Dinv8
R10=3Dfp0,call_-1
18: (0f) r1 +=3D r3
19: (71) r3 =3D *(u8 *)(r1 -1)
invalid access to packet, off=3D33 size=3D1, R1(id=3D2,off=3D34,r=3D0)
R1 offset is outside of the packet

Error fetching program/map!
=3D=3D=3D=3D=3D END VERIFIER OUTPUT =3D=3D=3D=3D=3D

Thank you!
--Zvi


On Thu, Jun 7, 2018 at 6:24 AM, Edward Cree <ecree@solarflare.com> wrote:
> On 06/06/18 23:22, Zvi Effron wrote:
>> Hi XDPeople!
>>
>> I've been having great success with reading data from fixed offsets in
>> a packet/ethernet frame. But every time I try to read from a dynamic
>> offset (e.g. read the last byte in the packet by using the packet
>> length in the IP/UDP headers). It looks like once I add a register to
>> a packet pointer, the range is reset to 0, and no amount of
>> comparisons will restore a range.
>>
>> Looking through the verifier code, I believe I found where the range
>> is getting set to 0
>> (https://elixir.bootlin.com/linux/latest/source/kernel/bpf/verifier.c#L2=
695),
>> and it looks like the risk of overflow
>> (https://elixir.bootlin.com/linux/latest/source/kernel/bpf/verifier.c#L3=
267)
>> is why the range doesn't get updated by later comparisons.
>>
>> Is there a way to do a read from a packet at a dynamic offset? If not,
>> is that something that could potentially be added to the verifier? It
>> feels like `if (packet_start <=3D packet_start + offset && packet_end >
>> packet_start + offset)` is something that should be verifiable as
>> safe, even with potential overflow in `packet_start + offset`?
>>
>> Thank you!
>> --Zvi
> I think that to make this work you need to bound the dynamic offset
>  before you add it to the packet pointer.  So for instance if you read
>  a packet length from the IP header, that's a u16 (so max. 0xffff), and
>  it's then added to the offset of L4 (probably 14+20=3D34), giving a max.
>  larger than MAX_PACKET_OFF.
>
> So you need to do something like
>   if (offset < 0xffff && packet_start + offset < packet_end)
>  because the verifier isn't smart enough to learn anything from an
>   if (ptr_to_packet <=3D ptr_to_packet + offset)
>  check.  The trouble with the latter is that it's a piece of state that
>  belongs both to the packet-pointer (which in the general case could be
>  variably-offset already) and to the offset, so you'd need n=C2=B2 storag=
e to
>  record which (pointer, offset) pairs had been determined not to overflow=
.
>
> HTH,
> -Ed
