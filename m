Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdHUIQH (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Aug 2017 04:16:07 -0400
Date: Mon, 21 Aug 2017 10:16:00 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: What library to use ?
Message-ID: <20170821101600.4e769785@redhat.com>
In-Reply-To: <599A11B8.9030906@iogearbox.net>
References: <1503234237.13034.9.camel@regit.org>
        <599A11B8.9030906@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Leblond <eric@regit.org>, xdp-newbies@vger.kernel.org, brouer@redhat.com, pavel.odintsov@gmail.com


On Mon, 21 Aug 2017 00:48:24 +0200 Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 08/20/2017 03:03 PM, Eric Leblond wrote:
> [...]
> > I've just started to work again on eBPF and XDP. My target it to work
> > on XDP support for Suricata (Daniel if you read me, yes finally ;)
> > Target is to be able to start Suricata with --xdp eth5 and get
> > everything setup by Suricata to get a working capture.  
> 
> Great, finally! ;)

This is really great to hear! I would very much like to cooperate in
this area.

I assume that the (currently) recommended interface for transferring
raw XDP packets to userspace is the perf ring buffer via
bpf_perf_event_output() interface?

I want to code-up some benchmarks to establish a baseline of
the expected performance that can be achieved via the perf ring buffer
interface.

Can someone point me to some eBPF+perf-ring example code / docs?

I have noticed that samples/bpf/trace_output_*.c [1][2] contains
something... but I'm hoping someone else have some examples?
 [1] https://github.com/torvalds/linux/blob/master/samples/bpf/trace_output_kern.c
 [2] https://github.com/torvalds/linux/blob/master/samples/bpf/trace_output_user.c


> > I've done one year ago an implementation of eBPF support in Suricata
> > using the library in tools/lib/bpf. One year later is using this
> > library the way to go or is there another library ?  
> 
> Yep, the lib in tools/lib/bpf would be recommended (also used in
> tools/testing/selftests/bpf/ for some of the networking selftests
> these days, incl. XDP).
> 
> Anyway, patches welcome just in case. ;)

I've been baseing my examples[3] on samples/bpf/bpf_load.c, but I would
very much like to move away from this approach, and instead use
tools/lib/bpf/.  Maybe we can do a joined effort and bring
tools/lib/bpf/ into shape?

[3] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
