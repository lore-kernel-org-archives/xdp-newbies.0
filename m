Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36074 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgAPDUD (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 22:20:03 -0500
Received: by mail-ed1-f65.google.com with SMTP id j17so17576731edp.3
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 19:20:02 -0800 (PST)
MIME-Version: 1.0
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
 <87ftggtl7t.fsf@toke.dk> <CAK86TEcyRqVrB-OOiCxtM6WLMp-Sr_+eO9G70+T=OMpF2KBrgQ@mail.gmail.com>
 <99fe90fe-cbb4-1ff1-156b-bd8053293aca@gmail.com> <CAK86TEcGAkmPLeYACWGtLT0CJPZqGYCqZDpZSO=0x4_ph0qcUA@mail.gmail.com>
In-Reply-To: <CAK86TEcGAkmPLeYACWGtLT0CJPZqGYCqZDpZSO=0x4_ph0qcUA@mail.gmail.com>
From: Vincent Li <mchun.li@gmail.com>
Date: Wed, 15 Jan 2020 19:19:50 -0800
Message-ID: <CAK86TEe8Je6NjLWzRHoMhDgqKyhqYd7pX2awmAUTQ7V3GCcKAA@mail.gmail.com>
Subject: Re: XDP invalid memory access
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: David Ahern <dsahern@gmail.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, xdp-newbies@vger.kernel.org

I changed the code below, not sure if I got it right from you, I still
got memory access error


 40 static int tcp_option(void *data, void *data_end)

 41 {

 42         struct ethhdr *eth = (struct ethhdr *)data;

 43         struct iphdr *iph = (struct iphdr *)(eth + 1);

 44         struct tcphdr *tcphdr = (struct tcphdr *)(iph + 1);

 45         int tcplen;

 46

 47         /* sanity check needed by the eBPF verifier */

 48         if ((void *)(tcphdr + 1)  > data_end)

 49                 return 0;

 50

 51         /* skip non TCP packets */

 52         if (eth->h_proto != __constant_htons(ETH_P_IP) ||
iph->protocol != IPPROTO_TCP)

 53                 return 0;

 54

 55         /* incompatible flags, or PSH already set */

 56         if (tcphdr->ack || tcphdr->fin || tcphdr->rst || tcphdr->psh)

 57                 return 0;

 58

 59         if (tcphdr->syn) {

 60                 if (((void *)(tcphdr + 1) + tcphdr->doff*4) > data_end)

 61                         return 0;

 62                 optlen = tcphdr->doff*4 - sizeof(*tcphdr);

 63                 for (i = 0; i < optlen; ) {

 64                         if (op[i] == TCPOPT_EOL ) {

 65                                 char fmt[] = "XDP: tcp source : %d
tcp option eol :%d\n";

 66                                 bpf_trace_printk(fmt, sizeof(fmt),
(int)tcphdr->source, TCPOPT_EOL);

 67                                 return 1;

 68                         }

 69                         if (op[i] < 2)

 70                                 i++;

 71                         else

 72                                 i += op[i+1] ? : 1;

 73                 }

 74                 /*

 75                if (tcphdr->doff*4 == 44 || tcphdr->doff*4 == 28) {

 76                         char fmt[] = "XDP: tcp source : %d data
offset :%d\n";

 77                         bpf_trace_printk(fmt, sizeof(fmt),
(int)tcphdr->source, (int)tcphdr->doff*4);

 78                        return 1;

 79                }

 80                */

 81         }

 82         return 0;

 83 }

# ip link set dev enp4s0 xdpgeneric object tcp_option.o verbose


Prog section 'prog' rejected: Permission denied (13)!

 - Type:         6

 - Instructions: 86 (0 over limit)

 - License:      GPL


Verifier analysis:


0: (b7) r0 = 2

1: (61) r2 = *(u32 *)(r1 +4)

2: (61) r1 = *(u32 *)(r1 +0)

3: (bf) r3 = r1

4: (07) r3 += 54

5: (2d) if r3 > r2 goto pc+79

 R0_w=inv2 R1_w=pkt(id=0,off=0,r=54,imm=0)
R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=54,r=54,imm=0)
R10=fp0

6: (71) r4 = *(u8 *)(r1 +12)

7: (71) r5 = *(u8 *)(r1 +13)

8: (67) r5 <<= 8

9: (4f) r5 |= r4

10: (55) if r5 != 0x8 goto pc+74

 R0_w=inv2 R1_w=pkt(id=0,off=0,r=54,imm=0)
R2_w=pkt_end(id=0,off=0,imm=0) R3_w=pkt(id=0,off=54,r=54,imm=0)
R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R5_w=inv8 R10=fp0

11: (71) r4 = *(u8 *)(r1 +23)

12: (55) if r4 != 0x6 goto pc+72

 R0=inv2 R1=pkt(id=0,off=0,r=54,imm=0) R2=pkt_end(id=0,off=0,imm=0)
R3=pkt(id=0,off=54,r=54,imm=0) R4=inv6 R5=inv8 R10=fp0

13: (69) r5 = *(u16 *)(r1 +46)

14: (bf) r4 = r5

15: (57) r4 &= 7936

16: (55) if r4 != 0x200 goto pc+68

 R0=inv2 R1=pkt(id=0,off=0,r=54,imm=0) R2=pkt_end(id=0,off=0,imm=0)
R3=pkt(id=0,off=54,r=54,imm=0) R4_w=inv512
R5_w=inv(id=0,umax_value=65535,var_off=(0x0; 0xffff)) R10=fp0

17: (77) r5 >>= 2

18: (57) r5 &= 60

19: (0f) r3 += r5

last_idx 19 first_idx 12

regs=20 stack=0 before 18: (57) r5 &= 60

regs=20 stack=0 before 17: (77) r5 >>= 2

regs=20 stack=0 before 16: (55) if r4 != 0x200 goto pc+68

regs=20 stack=0 before 15: (57) r4 &= 7936

regs=20 stack=0 before 14: (bf) r4 = r5

regs=20 stack=0 before 13: (69) r5 = *(u16 *)(r1 +46)

20: (2d) if r3 > r2 goto pc+64

 R0=inv2 R1=pkt(id=0,off=0,r=54,imm=0) R2=pkt_end(id=0,off=0,imm=0)
R3=pkt(id=1,off=54,r=54,umax_value=60,var_off=(0x0; 0x3c)) R4=inv512
R5=invP(id=0,umax_value=60,var_off=(0x0; 0x3c)) R10=fp0

21: (18) r2 = 0x0

23: (b7) r4 = 0

24: (63) *(u32 *)(r2 +0) = r4

R2 invalid mem access 'inv'

processed 24 insns (limit 1000000) max_states_per_insn 0 total_states
2 peak_states 2 mark_read 2


Error fetching program/map!

On Wed, Jan 15, 2020 at 5:34 PM Vincent Li <mchun.li@gmail.com> wrote:
>
> thank you! I will try that
>
> On Wed, Jan 15, 2020 at 4:40 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 1/15/20 3:31 PM, Vincent Li wrote:
> > > On Wed, Jan 15, 2020 at 2:21 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > >
> > >> You have to check that you're not reading out of bounds before
> > >> dereferencing the bytes in the TCP header...
> > >>
> > >
> > > I have below before the optlen
> > >
> > >    47 /* sanity check needed by the eBPF verifier */
> > >
> > >     48 if ((void *)(tcphdr + 1) > data_end)
> > >
> > >     49 return 0;
> > >
> > > this is not enough, how do I check the out of bounds properly?
> > >
> >
> > options are optional and after 'struct tcphdr' you need to do something
> > like:
> >
> >    if ((void *)(tcphdr + 1) + tcphdr->doff > data_end)
> >        return XDP_....
