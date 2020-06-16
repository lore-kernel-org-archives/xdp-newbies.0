Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731610AbgFPQHN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 16 Jun 2020 12:07:13 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90465C061573
        for <xdp-newbies@vger.kernel.org>; Tue, 16 Jun 2020 09:07:13 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q8so19615021qkm.12
        for <xdp-newbies@vger.kernel.org>; Tue, 16 Jun 2020 09:07:13 -0700 (PDT)
Subject: Re: Lightweight packet timestamping
References: <DB7PR08MB3130BDD01387627E7FAD775F9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130C02AB04133E07146F40D9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130BA2C0F90E0819577C5289E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <b712de09-fd35-1d5e-1842-31bb3b2e163d@gmail.com>
 <DB7PR08MB31304BCD517885F0E1C063F69E830@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <87d0667hm9.fsf@toke.dk> <20200616180001.7409bbad@carbon>
From: David Ahern <dsahern@gmail.com>
Message-ID: <65a07187-8005-a78e-b684-eaafda886fa5@gmail.com>
Date: Tue, 16 Jun 2020 10:07:10 -0600
MIME-Version: 1.0
In-Reply-To: <20200616180001.7409bbad@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc: Federico Parola <fede.parola@hotmail.it>, xdp-newbies@vger.kernel.org, Kanthi P <Pavuluri.kanthi@gmail.com>

On 6/16/20 10:00 AM, Jesper Dangaard Brouer wrote:
> On Wed, 10 Jun 2020 23:09:34 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> 
>> Federico Parola <fede.parola@hotmail.it> writes:
>>
>>> On 06/06/20 01:34, David Ahern wrote:  
>>>> On 6/4/20 7:30 AM, Federico Parola wrote:  
>>>>> Hello everybody,
>>
>>>>> I'm implementing a token bucket algorithm to apply rate limit to
>>>>> traffic and I need the timestamp of packets to update the bucket.
>>>>> To get this information I'm using the bpf_ktime_get_ns() helper
>>>>> but I've discovered it has a non negligible impact on
>>>>> performance. I've seen there is work in progress to make hardware
>>>>> timestamps available to XDP programs, but I don't know if this
>>>>> feature is already available. Is there a faster way to retrieve
>>>>> this information?
>>
>>>>> Thanks for your attention.
>>>>>  
>>>> bpf_ktime_get_ns should be fairly light. What kind of performance loss
>>>> are you seeing with it?  
>>>
>>> I've run some tests on a program forwarding packets between two 
>>> interfaces and applying rate limit: using the bpf_ktime_get_ns() I can 
>>> process up to 3.84 Mpps, if I replace the helper with a lookup on a map 
>>> containing the current timestamp updated in user space I go up to 4.48
>>> Mpps.
> 
> ((1/3.84*1000)-(1/4.48*1000) = 37.20 ns overhead)

I had the same math yesterday and did some tests as well. I am really
surprised the timestamp is that high.

> 
> I was about to suggest doing something close to this.  That is, only call
> bpf_ktime_get_ns() once per NAPI poll-cycle, and store the timestamp in
> a map.  If you don't need super high per packet precision.  You can
> even use a per-CPU map to store the info (to avoid cross CPU
> cache/talk), because softirq will keep RX-processing pinned to a CPU.
> 
> It sounds like you update the timestamp from userspace, is that true?
> (Quote: "current timestamp updated in user space")
> 
> I would suggest that you can leverage the softirq tracepoints (use
> SEC("raw_tracepoint/") for low overhead).  E.g. irq:softirq_entry
> (see when kernel calls trace_softirq_entry) to update the map once per
> NAPI/net_rx_action. I have a bpftrace based-tool[1] that measure

I have code that measures the overhead of net_rx_action:
    https://github.com/dsahern/bpf-progs/blob/master/ksrc/net_rx_action.c

this use case would just need the enter probe.


> network-softirq latency, e.g time it takes from "softirq_raise" until
> it is run "softirq_entry".  You can leverage ideas from that script,
> like 'vec == 3' is NET_RX_SOFTIRQ to limit this to networking.
> 
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/latency/softirq_net_latency.bt
> 
>> Can you share more details on the platform you're running this on?
>> I.e., CPU and chipset details, network driver, etc.
> 
> Yes, please.  I plan to work on XDP-feature of extracting hardware
> offload-info from the drivers descriptor, like timestamps, vlan,
> rss-hash, checksum, etc.  If you tell me what NIC driver you are using,
> I could make sure to include that in the supported drivers.
> 
