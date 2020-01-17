Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39975 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726343AbgAQLHI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 17 Jan 2020 06:07:08 -0500
Received: by mail-lj1-f200.google.com with SMTP id k21so6130141ljg.3
        for <xdp-newbies@vger.kernel.org>; Fri, 17 Jan 2020 03:07:05 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP invalid memory access
In-Reply-To: <alpine.OSX.2.21.2001161059220.5400@jiadeimac.local>
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com> <20200116022459.GA2853@ranger.igk.intel.com> <87y2u7spj3.fsf@toke.dk> <alpine.OSX.2.21.2001161059220.5400@jiadeimac.local>
Date: Fri, 17 Jan 2020 12:07:02 +0100
Message-ID: <87blr2qr3d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Vincent Li <mchun.li@gmail.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, xdp-newbies@vger.kernel.org, daniel@iogearbox.net, andriin@fb.com, dsahern@gmail.com

Vincent Li <mchun.li@gmail.com> writes:

> On Thu, 16 Jan 2020, Toke Høiland-Jørgensen wrote:
>
> Hi Toke,
>
>> 
>> You could also try the xdp-loader in xdp-tools:
>> https://github.com/xdp-project/xdp-tools
>> 
>> It's somewhat basic still, but should be able to at least load a basic
>> program - please file a bug report if it fails.
>
> I tried the xdp-tools xdp-loader, when the optlen is global variable, I 
> got:
> # xdp-loader load enp3s0 tcp_option.o
> Couldn't load BPF program: Relocation failed
>
> if I move the optlen, i variable to local variable, I got:
>
> # xdp-loader load enp3s0 tcp_option.o
> Couldn't load eBPF object: Invalid argument(-22)

OK, I tried this, and there were a couple of issues:

- The xdp-loader didn't set the BPF program type to XDP, and since your
  section name doesn't have an xdp_ prefix libbpf couldn't auto-detect
  it. I've pushed a fix for this to the xdp-tools repo so the loader
  will always set the program type to XDP now.

- There are a couple of bugs in your program:

First, when compiling with warnings turned on, I get this:

tcp_options.c:64:29: error: variable 'op' is uninitialized when used here [-Werror,-Wuninitialized]
                        if (op[i] == TCPOPT_EOL ) {
                            ^~
tcp_options.c:43:23: note: initialize the variable 'op' to silence this warning
        const __u8 *op;
                      ^
                       = 0

after fixing that (adding this line after the optlen = assignment):

                op = (const __u8 *)(tcphdr + 1);

the verifier then complains about out-of-bounds reading of the packet
data (pass -vv to xdp-loader to get the full debug output from libbpf).
You are not checking that the op pointer doesn't read out-of-bounds.

I fixed that by adding a couple of bounds checks inside the for loop.
The whole thing now looks like this:

                optlen = tcphdr->doff*4 - sizeof(*tcphdr);
                op = (const __u8 *)(tcphdr + 1);
                for (i = 0; i < optlen; ) {
                        if ((void *)op + i + 1 > data_end)
                                return 0;
                        if (op[i] == TCPOPT_EOL ) {
                                char fmt[] = "XDP: tcp source : %d tcp option eol\n";
                                bpf_trace_printk(fmt, sizeof(fmt), (int)tcphdr->source);
                                return 1;
                        }
                        if (op[i] < 2)
                                i++;
                        else
                                i += ((void *)op + 2 < data_end && op[i+1]) ? : 1;
                }


With this, I can successfully load the program using xdp-loader. Turning
the variables back into globals still doesn't work, but I think that
error message should be fairly obvious:

libbpf: invalid relo for 'op' in special section 0xfff2; forgot to initialize global var?..

-Toke
