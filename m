Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:63734 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgAPJcL (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 Jan 2020 04:32:11 -0500
Date: Thu, 16 Jan 2020 03:24:59 +0100
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: XDP invalid memory access
Message-ID: <20200116022459.GA2853@ranger.igk.intel.com>
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Vincent Li <mchun.li@gmail.com>
Cc: xdp-newbies@vger.kernel.org, daniel@iogearbox.net, andriin@fb.com, dsahern@gmail.com

On Wed, Jan 15, 2020 at 02:11:04PM -0800, Vincent Li wrote:
> Hi,
>=20
> I am writing a sample XDP program to parse tcp packet options, code
> below, compiled ok, when I attach it to a network interface
>=20
> #clang -O2 -emit-llvm -c tcp_option.c -o - |llc -march=3Dbpf
> -filetype=3Dobj -o tcp_option.o
>=20
>=20
> # ip link set dev enp3s0 xdpgeneric object tcp_option.o verbose
>=20
>=20
> Prog section 'prog' rejected: Permission denied (13)!
>=20
>  - Type:         6
>=20
>  - Instructions: 42 (0 over limit)
>=20
>  - License:      GPL
>=20
>=20
> Verifier analysis:
>=20
>=20
> 0: (61) r2 =3D *(u32 *)(r1 +4)
>=20
> 1: (61) r1 =3D *(u32 *)(r1 +0)
>=20
> 2: (bf) r3 =3D r1
>=20
> 3: (07) r3 +=3D 54
>=20
> 4: (b7) r0 =3D 2
>=20
> 5: (2d) if r3 > r2 goto pc+35
>=20
>  R0_w=3Dinv2 R1_w=3Dpkt(id=3D0,off=3D0,r=3D54,imm=3D0)
> R2_w=3Dpkt_end(id=3D0,off=3D0,imm=3D0) R3_w=3Dpkt(id=3D0,off=3D54,r=3D54,=
imm=3D0)
> R10=3Dfp0
>=20
> 6: (71) r2 =3D *(u8 *)(r1 +12)
>=20
> 7: (71) r3 =3D *(u8 *)(r1 +13)
>=20
> 8: (67) r3 <<=3D 8
>=20
> 9: (4f) r3 |=3D r2
>=20
> 10: (b7) r0 =3D 2
>=20
> 11: (55) if r3 !=3D 0x8 goto pc+29
>=20
>  R0_w=3Dinv2 R1_w=3Dpkt(id=3D0,off=3D0,r=3D54,imm=3D0)
> R2_w=3Dinv(id=3D0,umax_value=3D255,var_off=3D(0x0; 0xff)) R3_w=3Dinv8 R10=
=3Dfp0
>=20
> 12: (71) r2 =3D *(u8 *)(r1 +23)
>=20
> 13: (b7) r0 =3D 2
>=20
> 14: (55) if r2 !=3D 0x6 goto pc+26
>=20
>  R0=3Dinv2 R1=3Dpkt(id=3D0,off=3D0,r=3D54,imm=3D0) R2=3Dinv6 R3=3Dinv8 R1=
0=3Dfp0
>=20
> 15: (69) r1 =3D *(u16 *)(r1 +46)
>=20
> 16: (bf) r2 =3D r1
>=20
> 17: (57) r2 &=3D 7936
>=20
> 18: (b7) r0 =3D 2
>=20
> 19: (55) if r2 !=3D 0x200 goto pc+21
>=20
>  R0_w=3Dinv2 R1_w=3Dinv(id=3D0,umax_value=3D65535,var_off=3D(0x0; 0xffff)=
)
> R2_w=3Dinv512 R3=3Dinv8 R10=3Dfp0
>=20
> 20: (77) r1 >>=3D 2
>=20
> 21: (57) r1 &=3D 60
>=20
> 22: (07) r1 +=3D -20
>=20
> 23: (18) r2 =3D 0x0
>=20
> 25: (63) *(u32 *)(r2 +0) =3D r1
>=20
> R2 invalid mem access 'inv' <----------------

So it's not out of the bounds access but rather null dereference since r2
has been loaded with 0 on previous insn.

>=20
> processed 25 insns (limit 1000000) max_states_per_insn 0 total_states
> 1 peak_states 1 mark_read 1
>=20
>=20
> it appears optlen =3D tcphdr->doff*4 - sizeof(*tcphdr); is invalid ? if
> I comment out lines between 60 and 73, no problem with invalid mem
> access

I see that optlen is a global variable. This line might be valid but
you're using iproute2's loader for your XDP program, right? AFAIK it
doesn't have support for BPF global variables, only libbpf does (Daniel,
Andrii? is that true?).

So you have to either make the optlen a local variable or go with writing
the loader part that is based on libbpf usage (see samples/bpf directory
in kernel tree, for example xdp1_user.c).

Could you next time try a little better with the format of data you're
providing? I'm pretty sure other folks would have spotted earlier that
optlen is global if the code was properly formatted :)

To wrap this rant up, making optlen a local var does the job for me.

>=20
>=20
>=20
>=20
>=20
>      1 #include <stdint.h>
>=20
>      2 #include <arpa/inet.h>
>=20
>      3 #include <asm/byteorder.h>
>=20
>      4 #include <linux/bpf.h>
>=20
>      5 #include <linux/if_ether.h>
>=20
>      6 #include <linux/ip.h>
>=20
>      7 #include <linux/tcp.h>
>=20
>      8 #include <linux/pkt_cls.h>
>=20
>      9
>=20
>     10 /*
>=20
>     11 * Sample XDP to parse tcp option.
>=20
>     12 * compile it with:
>=20
>     13 *      clang -O2 -emit-llvm -c tcp_option.c -o - |llc
> -march=3Dbpf -filetype=3Dobj -o tcp_option.o
>=20
>     14  * attach it to a device with XDP as:
>=20
>     15  *  ip link set dev lo xdp object tcp_option.o verbose
>=20
>     16 */
>=20
>     17
>=20
>     18 #define SEC(NAME) __attribute__((section(NAME), used))
>=20
>     19
>=20
>     20 #define TCPOPT_EOL        0       /* End of options (1)           =
   */
>=20
>     21 #define TCPOPT_NOP        1       /* No-op (1)                    =
   */
>=20
>     22 #define TCPOPT_MAXSEG     2       /* Maximum segment size (4)     =
   */
>=20
>     23 #define TCPOPT_WSCALE     3       /* Window scaling (3)           =
   */
>=20
>     24 #define TCPOPT_SACKOK     4       /* Selective ACK permitted (2)  =
   */
>=20
>     25 #define TCPOPT_SACK       5       /* Actual selective ACK (10-34) =
   */
>=20
>     26 #define TCPOPT_TSTAMP     8       /* Timestamp (10)               =
   */
>=20
>     27
>=20
>     28
>=20
>     29 /* from bpf_helpers.h */
>=20
>     30
>=20
>     31 static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...)=
 =3D
>=20
>     32         (void *) BPF_FUNC_trace_printk;
>=20
>     33
>=20
>     34 static unsigned long long (*bpf_get_prandom_u32)(void) =3D
>=20
>     35 (void *) BPF_FUNC_get_prandom_u32;
>=20
>     36
>=20
>     37 const __u8 *op;
>=20
>     38 int i, optlen;
>=20
>     39
>=20
>     40 static int tcp_option(void *data, void *data_end)
>=20
>     41 {
>=20
>     42 struct ethhdr *eth =3D (struct ethhdr *)data;
>=20
>     43 struct iphdr *iph =3D (struct iphdr *)(eth + 1);
>=20
>     44 struct tcphdr *tcphdr =3D (struct tcphdr *)(iph + 1);
>=20
>     45 int tcplen;
>=20
>     46
>=20
>     47 /* sanity check needed by the eBPF verifier */
>=20
>     48 if ((void *)(tcphdr + 1) > data_end)
>=20
>     49 return 0;
>=20
>     50
>=20
>     51 /* skip non TCP packets */
>=20
>     52 if (eth->h_proto !=3D __constant_htons(ETH_P_IP) || iph->protocol
> !=3D IPPROTO_TCP)
>=20
>     53 return 0;
>=20
>     54
>=20
>     55 /* incompatible flags, or PSH already set */
>=20
>     56 if (tcphdr->ack || tcphdr->fin || tcphdr->rst || tcphdr->psh)
>=20
>     57 return 0;
>=20
>     58
>=20
>     59 if (tcphdr->syn) {
>=20
>     60 optlen =3D tcphdr->doff*4 - sizeof(*tcphdr);
>=20
>     61                 if (!optlen)
>=20
>     62                       return -1;
>=20
>     63 /*
>=20
>     64                 for (i =3D 0; i < optlen; ) {
>=20
>     65                         if (op[i] =3D=3D TCPOPT_EOL) {
>=20
>     66                  char fmt[] =3D "XDP: tcp opt eol kind seen %d \n"=
;
>=20
>     67                  bpf_trace_printk(fmt, sizeof(fmt), op[i]);
>=20
>     68 }
>=20
>     69                         if (op[i] < 2)
>=20
>     70                                 i++;
>=20
>     71                         else
>=20
>     72                                 i +=3D op[i+1] ? : 1;
>=20
>     73                 }
>=20
>     74 */
>=20
>     75
>=20
>     76                char fmt[] =3D "XDP: tcp syn seen \n";
>=20
>     77                bpf_trace_printk(fmt, sizeof(fmt));
>=20
>     78
>=20
>     79 }
>=20
>     80
>=20
>     81 return 0;
>=20
>     82 }
>=20
>     83
>=20
>     84 SEC("prog")
>=20
>     85 int xdp_main(struct xdp_md *ctx)
>=20
>     86 {
>=20
>     87 void *data_end =3D (void *)(uintptr_t)ctx->data_end;
>=20
>     88 void *data =3D (void *)(uintptr_t)ctx->data;
>=20
>     89
>=20
>     90 if (tcp_option(data, data_end))
>=20
>     91 return XDP_DROP;
>=20
>     92
>=20
>     93 return XDP_PASS;
>=20
>     94 }
>=20
>     95
>=20
>     96
>=20
>     97 char _license[] SEC("license") =3D "GPL";
