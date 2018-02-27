Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57302 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbeB0Not (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 27 Feb 2018 08:44:49 -0500
Subject: Re: loop in eBPF kernel program
References: <e3a523ec-b090-61b5-c92b-58d3b74a9c31@oracle.com>
 <56c9ce62-9822-f498-4c12-27c68b2d7a51@iogearbox.net>
From: Tushar Dave <tushar.n.dave@oracle.com>
Message-ID: <e0d9ca2c-deaf-15fb-1d1f-a5c04c4538cf@oracle.com>
Date: Tue, 27 Feb 2018 05:39:29 -0800
MIME-Version: 1.0
In-Reply-To: <56c9ce62-9822-f498-4c12-27c68b2d7a51@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org



On 02/27/2018 01:52 AM, Daniel Borkmann wrote:
> On 02/27/2018 01:32 AM, Tushar Dave wrote:
>> Hello,
>>
>> I am writing sample eBPF kernel program that uses kprobe
>> e.g.
>> SEC("kprobe/xyz")
>> int bpf_prog1(struct pt_regs *ctx)
>> {
>> .
>> ..
>> }
>>
>> And with pt_regs context I retrieved pointer to 'struct sk_buff_head'.
>>  From here on, I want to iterate over all skbs in the skb queue and
>> print/gather packet data. This certainly involves loop and that causes
>> my ebpf kernel program to fail with error,
>> e.g.
>> bpf_load_program() err=22
>> back-edge from insn 51 to 39
>> back-edge from insn 51 to 39
>>
>> Any other alternative so that I can retrieve all packet data from skb queue?
>>
>> Apology as this is not pure xdp query but I feel it should be okay to
>> ask here.
> Bounded loops are still wip in BPF core, but today you can make use of
> loop unrolling like the following when <X> is a known constant:
> 
> #pragma unroll
> 	for (i = 0; i < <X>; i++) {
> 		[...]
> 	}
Ok. Thanks.
> 
> I presume you're walking the skb via bpf_probe_read() helper from tracing
> side, right? Other option could be to add a networking program (e.g. via
> cls_bpf) and dump the full skb to perf RB via bpf_skb_event_output() helper.
> Potentially if you already dump other data from tracing side via perf RB,
> then the networking program can reuse/share the very same perf event map
> as well.
yes I am using bpf_probe_read to walk over skb list. I will look into
cls_bpf option you mentioned. Thanks for suggestion :)

-Tushar
> 
> Cheers,
> Daniel
> 
