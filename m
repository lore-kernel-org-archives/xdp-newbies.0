Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:57808 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbdHUV5r (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Aug 2017 17:57:47 -0400
Message-ID: <599B5757.9050107@iogearbox.net>
Date: Mon, 21 Aug 2017 23:57:43 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: What library to use ?
References: <1503234237.13034.9.camel@regit.org>        <599A11B8.9030906@iogearbox.net> <20170821101600.4e769785@redhat.com>
In-Reply-To: <20170821101600.4e769785@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Eric Leblond <eric@regit.org>, xdp-newbies@vger.kernel.org, pavel.odintsov@gmail.com

On 08/21/2017 10:16 AM, Jesper Dangaard Brouer wrote:
> On Mon, 21 Aug 2017 00:48:24 +0200 Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 08/20/2017 03:03 PM, Eric Leblond wrote:
>> [...]
>>> I've just started to work again on eBPF and XDP. My target it to work
>>> on XDP support for Suricata (Daniel if you read me, yes finally ;)
>>> Target is to be able to start Suricata with --xdp eth5 and get
>>> everything setup by Suricata to get a working capture.
>>
>> Great, finally! ;)
>
> This is really great to hear! I would very much like to cooperate in
> this area.
>
> I assume that the (currently) recommended interface for transferring
> raw XDP packets to userspace is the perf ring buffer via
> bpf_perf_event_output() interface?

Yep, allows for meta data plus partial or full packet, e.g. see
cilium bpf/lib/drop.h +40 as an example. XDP works the same way.

> I want to code-up some benchmarks to establish a baseline of
> the expected performance that can be achieved via the perf ring buffer
> interface.

That would be great, there's likely room for optimization as
well! ;) Note struct perf_event_attr has couple of wakeup watermark
options, see perf_event_open(2). The sample code lets poll time
out to trigger head/tail check btw.

> Can someone point me to some eBPF+perf-ring example code / docs?
>
> I have noticed that samples/bpf/trace_output_*.c [1][2] contains
> something... but I'm hoping someone else have some examples?
>   [1] https://github.com/torvalds/linux/blob/master/samples/bpf/trace_output_kern.c
>   [2] https://github.com/torvalds/linux/blob/master/samples/bpf/trace_output_user.c

Interface from user space side is effectively the same as
trace_output_user.c, you'd need per cpu pmu fds (the example
above is just for cpu 0), and to pin the processing threads
accordingly to the corresponding cpu. fds go into perf event
map with index : cpu mapping, so you can use BPF_F_CURRENT_CPU
flag from helper side.

>>> I've done one year ago an implementation of eBPF support in Suricata
>>> using the library in tools/lib/bpf. One year later is using this
>>> library the way to go or is there another library ?
>>
>> Yep, the lib in tools/lib/bpf would be recommended (also used in
>> tools/testing/selftests/bpf/ for some of the networking selftests
>> these days, incl. XDP).
>>
>> Anyway, patches welcome just in case. ;)
>
> I've been baseing my examples[3] on samples/bpf/bpf_load.c, but I would
> very much like to move away from this approach, and instead use
> tools/lib/bpf/.

+1, they should be migrated to selftests ideally, so they are
run on regular basis.
