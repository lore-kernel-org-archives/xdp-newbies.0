Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f49.google.com ([209.85.208.49]:46738 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbgAOWLR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 17:11:17 -0500
Received: by mail-ed1-f49.google.com with SMTP id m8so17016523edi.13
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 14:11:15 -0800 (PST)
MIME-Version: 1.0
From: Vincent Li <mchun.li@gmail.com>
Date: Wed, 15 Jan 2020 14:11:04 -0800
Message-ID: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
Subject: XDP invalid memory access
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

Hi,

I am writing a sample XDP program to parse tcp packet options, code
below, compiled ok, when I attach it to a network interface

#clang -O2 -emit-llvm -c tcp_option.c -o - |llc -march=3Dbpf
-filetype=3Dobj -o tcp_option.o


# ip link set dev enp3s0 xdpgeneric object tcp_option.o verbose


Prog section 'prog' rejected: Permission denied (13)!

 - Type:         6

 - Instructions: 42 (0 over limit)

 - License:      GPL


Verifier analysis:


0: (61) r2 =3D *(u32 *)(r1 +4)

1: (61) r1 =3D *(u32 *)(r1 +0)

2: (bf) r3 =3D r1

3: (07) r3 +=3D 54

4: (b7) r0 =3D 2

5: (2d) if r3 > r2 goto pc+35

 R0_w=3Dinv2 R1_w=3Dpkt(id=3D0,off=3D0,r=3D54,imm=3D0)
R2_w=3Dpkt_end(id=3D0,off=3D0,imm=3D0) R3_w=3Dpkt(id=3D0,off=3D54,r=3D54,im=
m=3D0)
R10=3Dfp0

6: (71) r2 =3D *(u8 *)(r1 +12)

7: (71) r3 =3D *(u8 *)(r1 +13)

8: (67) r3 <<=3D 8

9: (4f) r3 |=3D r2

10: (b7) r0 =3D 2

11: (55) if r3 !=3D 0x8 goto pc+29

 R0_w=3Dinv2 R1_w=3Dpkt(id=3D0,off=3D0,r=3D54,imm=3D0)
R2_w=3Dinv(id=3D0,umax_value=3D255,var_off=3D(0x0; 0xff)) R3_w=3Dinv8 R10=
=3Dfp0

12: (71) r2 =3D *(u8 *)(r1 +23)

13: (b7) r0 =3D 2

14: (55) if r2 !=3D 0x6 goto pc+26

 R0=3Dinv2 R1=3Dpkt(id=3D0,off=3D0,r=3D54,imm=3D0) R2=3Dinv6 R3=3Dinv8 R10=
=3Dfp0

15: (69) r1 =3D *(u16 *)(r1 +46)

16: (bf) r2 =3D r1

17: (57) r2 &=3D 7936

18: (b7) r0 =3D 2

19: (55) if r2 !=3D 0x200 goto pc+21

 R0_w=3Dinv2 R1_w=3Dinv(id=3D0,umax_value=3D65535,var_off=3D(0x0; 0xffff))
R2_w=3Dinv512 R3=3Dinv8 R10=3Dfp0

20: (77) r1 >>=3D 2

21: (57) r1 &=3D 60

22: (07) r1 +=3D -20

23: (18) r2 =3D 0x0

25: (63) *(u32 *)(r2 +0) =3D r1

R2 invalid mem access 'inv' <----------------

processed 25 insns (limit 1000000) max_states_per_insn 0 total_states
1 peak_states 1 mark_read 1


it appears optlen =3D tcphdr->doff*4 - sizeof(*tcphdr); is invalid ? if
I comment out lines between 60 and 73, no problem with invalid mem
access





     1 #include <stdint.h>

     2 #include <arpa/inet.h>

     3 #include <asm/byteorder.h>

     4 #include <linux/bpf.h>

     5 #include <linux/if_ether.h>

     6 #include <linux/ip.h>

     7 #include <linux/tcp.h>

     8 #include <linux/pkt_cls.h>

     9

    10 /*

    11 * Sample XDP to parse tcp option.

    12 * compile it with:

    13 *      clang -O2 -emit-llvm -c tcp_option.c -o - |llc
-march=3Dbpf -filetype=3Dobj -o tcp_option.o

    14  * attach it to a device with XDP as:

    15  *  ip link set dev lo xdp object tcp_option.o verbose

    16 */

    17

    18 #define SEC(NAME) __attribute__((section(NAME), used))

    19

    20 #define TCPOPT_EOL        0       /* End of options (1)             =
 */

    21 #define TCPOPT_NOP        1       /* No-op (1)                      =
 */

    22 #define TCPOPT_MAXSEG     2       /* Maximum segment size (4)       =
 */

    23 #define TCPOPT_WSCALE     3       /* Window scaling (3)             =
 */

    24 #define TCPOPT_SACKOK     4       /* Selective ACK permitted (2)    =
 */

    25 #define TCPOPT_SACK       5       /* Actual selective ACK (10-34)   =
 */

    26 #define TCPOPT_TSTAMP     8       /* Timestamp (10)                 =
 */

    27

    28

    29 /* from bpf_helpers.h */

    30

    31 static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
=3D

    32         (void *) BPF_FUNC_trace_printk;

    33

    34 static unsigned long long (*bpf_get_prandom_u32)(void) =3D

    35 (void *) BPF_FUNC_get_prandom_u32;

    36

    37 const __u8 *op;

    38 int i, optlen;

    39

    40 static int tcp_option(void *data, void *data_end)

    41 {

    42 struct ethhdr *eth =3D (struct ethhdr *)data;

    43 struct iphdr *iph =3D (struct iphdr *)(eth + 1);

    44 struct tcphdr *tcphdr =3D (struct tcphdr *)(iph + 1);

    45 int tcplen;

    46

    47 /* sanity check needed by the eBPF verifier */

    48 if ((void *)(tcphdr + 1) > data_end)

    49 return 0;

    50

    51 /* skip non TCP packets */

    52 if (eth->h_proto !=3D __constant_htons(ETH_P_IP) || iph->protocol
!=3D IPPROTO_TCP)

    53 return 0;

    54

    55 /* incompatible flags, or PSH already set */

    56 if (tcphdr->ack || tcphdr->fin || tcphdr->rst || tcphdr->psh)

    57 return 0;

    58

    59 if (tcphdr->syn) {

    60 optlen =3D tcphdr->doff*4 - sizeof(*tcphdr);

    61                 if (!optlen)

    62                       return -1;

    63 /*

    64                 for (i =3D 0; i < optlen; ) {

    65                         if (op[i] =3D=3D TCPOPT_EOL) {

    66                  char fmt[] =3D "XDP: tcp opt eol kind seen %d \n";

    67                  bpf_trace_printk(fmt, sizeof(fmt), op[i]);

    68 }

    69                         if (op[i] < 2)

    70                                 i++;

    71                         else

    72                                 i +=3D op[i+1] ? : 1;

    73                 }

    74 */

    75

    76                char fmt[] =3D "XDP: tcp syn seen \n";

    77                bpf_trace_printk(fmt, sizeof(fmt));

    78

    79 }

    80

    81 return 0;

    82 }

    83

    84 SEC("prog")

    85 int xdp_main(struct xdp_md *ctx)

    86 {

    87 void *data_end =3D (void *)(uintptr_t)ctx->data_end;

    88 void *data =3D (void *)(uintptr_t)ctx->data;

    89

    90 if (tcp_option(data, data_end))

    91 return XDP_DROP;

    92

    93 return XDP_PASS;

    94 }

    95

    96

    97 char _license[] SEC("license") =3D "GPL";
