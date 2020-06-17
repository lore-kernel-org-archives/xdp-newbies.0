Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-db8eur05olkn2086.outbound.protection.outlook.com ([40.92.89.86]:42432
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgFQJrv (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Jun 2020 05:47:51 -0400
Subject: Re: Lightweight packet timestamping
References: <DB7PR08MB3130BDD01387627E7FAD775F9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130C02AB04133E07146F40D9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130BA2C0F90E0819577C5289E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <b712de09-fd35-1d5e-1842-31bb3b2e163d@gmail.com>
 <DB7PR08MB31304BCD517885F0E1C063F69E830@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <87d0667hm9.fsf@toke.dk> <20200616180001.7409bbad@carbon>
 <65a07187-8005-a78e-b684-eaafda886fa5@gmail.com>
From: Federico Parola <fede.parola@hotmail.it>
Message-ID: <DB7PR08MB31300A48E2638C814C929B929E9A0@DB7PR08MB3130.eurprd08.prod.outlook.com>
Date: Wed, 17 Jun 2020 11:47:31 +0200
In-Reply-To: <65a07187-8005-a78e-b684-eaafda886fa5@gmail.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8;
        format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: xdp-newbies@vger.kernel.org

On 16/06/20 18:07, David Ahern wrote:
> On 6/16/20 10:00 AM, Jesper Dangaard Brouer wrote:
>> On Wed, 10 Jun 2020 23:09:34 +0200
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>>
>>> Federico Parola <fede.parola@hotmail.it> writes:
>>>
>>>> On 06/06/20 01:34, David Ahern wrote:
>>>>> On 6/4/20 7:30 AM, Federico Parola wrote:
>>>>>> Hello everybody,
>>>
>>>>>> I'm implementing a token bucket algorithm to apply rate limit to
>>>>>> traffic and I need the timestamp of packets to update the bucket.
>>>>>> To get this information I'm using the bpf_ktime_get_ns() helper
>>>>>> but I've discovered it has a non negligible impact on
>>>>>> performance. I've seen there is work in progress to make hardware
>>>>>> timestamps available to XDP programs, but I don't know if this
>>>>>> feature is already available. Is there a faster way to retrieve
>>>>>> this information?
>>>
>>>>>> Thanks for your attention.
>>>>>>  =20
>>>>> bpf_ktime_get_ns should be fairly light. What kind of performance los=
s
>>>>> are you seeing with it?
>>>>
>>>> I've run some tests on a program forwarding packets between two
>>>> interfaces and applying rate limit: using the bpf_ktime_get_ns() I can
>>>> process up to 3.84 Mpps, if I replace the helper with a lookup on a ma=
p
>>>> containing the current timestamp updated in user space I go up to 4.48
>>>> Mpps.
>>
>> ((1/3.84*1000)-(1/4.48*1000) =3D 37.20 ns overhead)
>=20
> I had the same math yesterday and did some tests as well. I am really
> surprised the timestamp is that high.

Do your tests show a similar overhead?

>=20
>>
>> I was about to suggest doing something close to this.  That is, only cal=
l
>> bpf_ktime_get_ns() once per NAPI poll-cycle, and store the timestamp in
>> a map.  If you don't need super high per packet precision.  You can
>> even use a per-CPU map to store the info (to avoid cross CPU
>> cache/talk), because softirq will keep RX-processing pinned to a CPU.
>>
>> It sounds like you update the timestamp from userspace, is that true?
>> (Quote: "current timestamp updated in user space")
>>
>> I would suggest that you can leverage the softirq tracepoints (use
>> SEC("raw_tracepoint/") for low overhead).  E.g. irq:softirq_entry
>> (see when kernel calls trace_softirq_entry) to update the map once per
>> NAPI/net_rx_action. I have a bpftrace based-tool[1] that measure
>=20
> I have code that measures the overhead of net_rx_action:
>      https://github.com/dsahern/bpf-progs/blob/master/ksrc/net_rx_action.=
c
>=20
> this use case would just need the enter probe.
>=20
>=20
>> network-softirq latency, e.g time it takes from "softirq_raise" until
>> it is run "softirq_entry".  You can leverage ideas from that script,
>> like 'vec =3D=3D 3' is NET_RX_SOFTIRQ to limit this to networking.
>>
>> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/latency=
/softirq_net_latency.bt
>>

Thanks for your suggestion, currently I have a thread in user space that=20
updates a PERCPU_ARRAY map with the current timestamp every millisecond=20
and the precision seems to be good enough.
I'll check your solution as well.

>>> Can you share more details on the platform you're running this on?
>>> I.e., CPU and chipset details, network driver, etc.
>>
>> Yes, please.  I plan to work on XDP-feature of extracting hardware
>> offload-info from the drivers descriptor, like timestamps, vlan,
>> rss-hash, checksum, etc.  If you tell me what NIC driver you are using,
>> I could make sure to include that in the supported drivers.
>>
>

I ran the test on a Intel Xeon Gold 5120 @2.60GHz on a single core using=20
a dual port 40 GbE Intel XL710 NIC (i40e driver), forwarding 64 bytes=20
frames between the ports.

Thanks for your help.

Federico
