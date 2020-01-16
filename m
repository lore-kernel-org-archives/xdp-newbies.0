Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51150 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730161AbgAPWKj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 Jan 2020 17:10:39 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so2212855pjb.0
        for <xdp-newbies@vger.kernel.org>; Thu, 16 Jan 2020 14:10:39 -0800 (PST)
From: Vincent Li <mchun.li@gmail.com>
Date: Thu, 16 Jan 2020 14:10:36 -0800 (PST)
Subject: Re: XDP invalid memory access
In-Reply-To: <2cf8f3e2-d7ce-237e-7076-951c3f53061e@fb.com>
Message-ID: <alpine.OSX.2.21.2001161359270.5443@jiadeimac.local>
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com> <20200116022459.GA2853@ranger.igk.intel.com> <87y2u7spj3.fsf@toke.dk> <alpine.OSX.2.21.2001161059220.5400@jiadeimac.local> <2cf8f3e2-d7ce-237e-7076-951c3f53061e@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1923621565-1579212637=:5443"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andrii Nakryiko <andriin@fb.com>
Cc: Vincent Li <mchun.li@gmail.com>, =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>, Maciej Fijalkowski <maciej.fijalkowski@intel.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "dsahern@gmail.com" <dsahern@gmail.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1923621565-1579212637=:5443
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT



On Thu, 16 Jan 2020, Andrii Nakryiko wrote:

> On 1/16/20 11:06 AM, Vincent Li wrote:
> > 
> > 
> > On Thu, 16 Jan 2020, Toke Høiland-Jørgensen wrote:
> > 
> > Hi Toke,
> > 
> >>
> >> You could also try the xdp-loader in xdp-tools:
> >> https://github.com/xdp-project/xdp-tools
> >>
> >> It's somewhat basic still, but should be able to at least load a basic
> >> program - please file a bug report if it fails.
> > 
> > I tried the xdp-tools xdp-loader, when the optlen is global variable, I
> > got:
> > # xdp-loader load enp3s0 tcp_option.o
> > Couldn't load BPF program: Relocation failed
> > 
> > if I move the optlen, i variable to local variable, I got:
> > 
> > # xdp-loader load enp3s0 tcp_option.o
> > Couldn't load eBPF object: Invalid argument(-22)
> > 
> > Here is the complete code:
> > 
> > #include <stdint.h>
> > #include <arpa/inet.h>
> > #include <asm/byteorder.h>
> > #include <linux/bpf.h>
> > #include <linux/if_ether.h>
> > #include <linux/ip.h>
> > #include <linux/tcp.h>
> > #include <linux/pkt_cls.h>
> > 
> > /*
> >   * Sample XDP to parse tcp option.
> >   * compile it with:
> >   * clang -O2 -emit-llvm -c tcp_option.c -o - |llc -march=bpf -filetype=obj -o tcp_option.o
> >   * attach it to a device with XDP as:
> >   * 	ip link set dev lo xdp object tcp_option.o verbose
> >   */
> > 
> > #define SEC(NAME) __attribute__((section(NAME), used))
> > 
> > #define TCPOPT_EOL        0       /* End of options (1)              */
> > #define TCPOPT_NOP        1       /* No-op (1)                       */
> > #define TCPOPT_MAXSEG     2       /* Maximum segment size (4)        */
> > #define TCPOPT_WSCALE     3       /* Window scaling (3)              */
> > #define TCPOPT_SACKOK     4       /* Selective ACK permitted (2)     */
> > #define TCPOPT_SACK       5       /* Actual selective ACK (10-34)    */
> > #define TCPOPT_TSTAMP     8       /* Timestamp (10)                  */
> > 
> > 
> > /* from bpf_helpers.h */
> > 
> > static int (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
> > (void *) BPF_FUNC_trace_printk;
> > 
> > static unsigned long long (*bpf_get_prandom_u32)(void) =
> > (void *) BPF_FUNC_get_prandom_u32;
> > 
> > 
> > static int tcp_option(void *data, void *data_end)
> 
> I don't know if xdp-loader handles subprogram calls and relocations. 
> Mark it as __always_inline.

I tried __always_inline the tcp_option function, same relocation error, 
the relocation error only occurs when optlen is global variable, if I put 
optlen as local variable, it complains different error:

xdp-loader load enp3s0 tcp_option.o
Couldn't load eBPF object: Invalid argument(-22)

I suspect this may not be specific to xdp-loader. In the beginning, I made 
some code changes in suricata/ebpf/xdp-filter.c to parse tcp options and 
I got same relocation error, this leads me to write a standalone sample 
xdp program  and use iproutes to load the sample program. now we know the 
global variable cause iproutes to fail. and I am back to the 
original problem of suricata/ebpf/xdp-filter.c  or xdp-loader  
libbpf way to load xdp program :).

 
--0-1923621565-1579212637=:5443--
