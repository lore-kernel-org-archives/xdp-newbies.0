Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:48054 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932297AbdHYSfX (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 25 Aug 2017 14:35:23 -0400
Message-ID: <1503686114.19844.5.camel@regit.org>
Subject: Re: What library to use ?
From: Eric Leblond <eric@regit.org>
Date: Fri, 25 Aug 2017 20:35:14 +0200
In-Reply-To: <599B5757.9050107@iogearbox.net>
References: <1503234237.13034.9.camel@regit.org>
                <599A11B8.9030906@iogearbox.net> <20170821101600.4e769785@redhat.com>
         <599B5757.9050107@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org, pavel.odintsov@gmail.com

Hi,

On Mon, 2017-08-21 at 23:57 +0200, Daniel Borkmann wrote:
> On 08/21/2017 10:16 AM, Jesper Dangaard Brouer wrote:
> > On Mon, 21 Aug 2017 00:48:24 +0200 Daniel Borkmann <daniel@iogearbo
> > x.net> wrote:
> > > On 08/20/2017 03:03 PM, Eric Leblond wrote:
> > > [...]
> > > > I've just started to work again on eBPF and XDP. My target it
> > > > to work
> > > > on XDP support for Suricata (Daniel if you read me, yes finally
> > > > ;)
> > > > Target is to be able to start Suricata with --xdp eth5 and get
> > > > everything setup by Suricata to get a working capture.
> > > 
> > > Great, finally! ;)
> > 
> > This is really great to hear! I would very much like to cooperate
> > in
> > this area.

I think I can appreciate some help here :)

> > I assume that the (currently) recommended interface for
> > transferring
> > raw XDP packets to userspace is the perf ring buffer via
> > bpf_perf_event_output() interface?
> 
> Yep, allows for meta data plus partial or full packet, e.g. see
> cilium bpf/lib/drop.h +40 as an example. XDP works the same way.
> 
> > I want to code-up some benchmarks to establish a baseline of
> > the expected performance that can be achieved via the perf ring
> > buffer
> > interface.
> 
> That would be great, there's likely room for optimization as
> well! ;) Note struct perf_event_attr has couple of wakeup watermark
> options, see perf_event_open(2). The sample code lets poll time
> out to trigger head/tail check btw.
> 
> > Can someone point me to some eBPF+perf-ring example code / docs?
> > 
> > I have noticed that samples/bpf/trace_output_*.c [1][2] contains
> > something... but I'm hoping someone else have some examples?
> >   [1] https://github.com/torvalds/linux/blob/master/samples/bpf/tra
> > ce_output_kern.c
> >   [2] https://github.com/torvalds/linux/blob/master/samples/bpf/tra
> > ce_output_user.c
> 
> Interface from user space side is effectively the same as
> trace_output_user.c, you'd need per cpu pmu fds (the example
> above is just for cpu 0), and to pin the processing threads
> accordingly to the corresponding cpu. fds go into perf event
> map with index : cpu mapping, so you can use BPF_F_CURRENT_CPU
> flag from helper side.

OK, this looks like what we were already doing in Suricata so it should
be ok. If I get correctly the design, we will have a per CPU load
balancing. The CPU reading the packet will send data to his own ring
buffer via the bpf_perf_event_output that don't take any CPU related
parameters. As we are really early in the processing, this means that
the per-CPU load balancing will be done by the card.
So we will encounter the asymetric flow hash problem on driver like
ixgbe which do not have a symetric load balancing function.

Thus we need another card to do the testing. I had one test bed ready
with an ixgbe. It looks like I will need some other hardware to do the
tests. 

Did I understood correctly ?

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
