Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34592 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFGCWI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 6 Jun 2019 22:22:08 -0400
Subject: Re: [PATCH v2 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
 <20190605053613.22888-2-toshiaki.makita1@gmail.com>
 <20190605095931.5d90b69c@carbon>
 <abd43c39-afb7-acd4-688a-553cec76f55c@gmail.com>
 <20190606214105.6bf2f873@carbon>
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <e0266202-5db6-123c-eba6-33e5c5c4ba6d@gmail.com>
Date: Fri, 7 Jun 2019 11:22:00 +0900
MIME-Version: 1.0
In-Reply-To: <20190606214105.6bf2f873@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Jason Wang <jasowang@redhat.com>, Brendan Gregg <brendan.d.gregg@gmail.com>

On 2019/06/07 4:41, Jesper Dangaard Brouer wrote:
> On Thu, 6 Jun 2019 20:04:20 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> 
>> On 2019/06/05 16:59, Jesper Dangaard Brouer wrote:
>>> On Wed,  5 Jun 2019 14:36:12 +0900
>>> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
>>>    
>>>> This is introduced for admins to check what is happening on XDP_TX when
>>>> bulk XDP_TX is in use, which will be first introduced in veth in next
>>>> commit.
>>>
>>> Is the plan that this tracepoint 'xdp:xdp_bulk_tx' should be used by
>>> all drivers?
>>
>> I guess you mean all drivers that implement similar mechanism should use
>> this? Then yes.
>> (I don't think all drivers needs bulk tx mechanism though)
>>
>>> (more below)
>>>    
>>>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>>>> ---
>>>>    include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
>>>>    kernel/bpf/core.c          |  1 +
>>>>    2 files changed, 26 insertions(+)
>>>>
>>>> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
>>>> index e95cb86..e06ea65 100644
>>>> --- a/include/trace/events/xdp.h
>>>> +++ b/include/trace/events/xdp.h
>>>> @@ -50,6 +50,31 @@
>>>>    		  __entry->ifindex)
>>>>    );
>>>>    
>>>> +TRACE_EVENT(xdp_bulk_tx,
>>>> +
>>>> +	TP_PROTO(const struct net_device *dev,
>>>> +		 int sent, int drops, int err),
>>>> +
>>>> +	TP_ARGS(dev, sent, drops, err),
>>>> +
>>>> +	TP_STRUCT__entry(
>>>
>>> All other tracepoints in this file starts with:
>>>
>>> 		__field(int, prog_id)
>>> 		__field(u32, act)
>>> or
>>> 		__field(int, map_id)
>>> 		__field(u32, act)
>>>
>>> Could you please add those?
>>
>> So... prog_id is the problem. The program can be changed while we are
>> enqueueing packets to the bulk queue, so the prog_id at flush may be an
>> unexpected one.
> 
> Hmmm... that sounds problematic, if the XDP bpf_prog for veth can
> change underneath, before the flush.  Our redirect system, depend on
> things being stable until the xdp_do_flush_map() operation, as will
> e.g. set per-CPU (bpf_redirect_info) map_to_flush pointer (which depend
> on XDP prog), and expect it to be correct/valid.

Sorry, I don't get how maps depend on programs.
At least xdp_do_redirect_map() handles map_to_flush change during NAPI. 
Is there a problem when the map is not changed but the program is changed?
Also I believe this is not veth-specific behavior. Looking at tun and 
i40e, they seem to change xdp_prog without stopping data path.

>> It can be fixed by disabling NAPI when changing XDP programs. This stops
>> packet processing while changing XDP programs, but I guess it is an
>> acceptable compromise. Having said that, I'm honestly not so eager to
>> make this change, since this will require refurbishment of one of the
>> most delicate part of veth XDP, NAPI disabling/enabling mechanism.
>>
>> WDYT?
> 
> Sound like a bug, if XDP bpf_prog is not stable within the NAPI poll...
> 
>   
>>>> +		__field(int, ifindex)
>>>> +		__field(int, drops)
>>>> +		__field(int, sent)
>>>> +		__field(int, err)
>>>> +	),
>>>
>>> The reason is that this make is easier to attach to multiple
>>> tracepoints, and extract the same value.
>>>
>>> Example with bpftrace oneliner:
>>>
>>> $ sudo bpftrace -e 'tracepoint:xdp:xdp_* { @action[args->act] = count(); }'
> 
