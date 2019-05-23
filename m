Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45991 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729902AbfEWNkP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 May 2019 09:40:15 -0400
Subject: Re: [PATCH bpf-next 3/3] veth: Support bulk XDP_TX
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-4-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <87zhnd1kg9.fsf@toke.dk> <599302b2-96d2-b571-01ee-f4914acaf765@lab.ntt.co.jp>
 <87sgt51i0e.fsf@toke.dk>
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <0439f845-16cd-20ef-65e2-ebe6da11d57a@gmail.com>
Date: Thu, 23 May 2019 22:40:09 +0900
MIME-Version: 1.0
In-Reply-To: <87sgt51i0e.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

On 19/05/23 (木) 21:18:25, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
> 
>> On 2019/05/23 20:25, Toke Høiland-Jørgensen wrote:
>>> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
>>>
>>>> This improves XDP_TX performance by about 8%.
>>>>
>>>> Here are single core XDP_TX test results. CPU consumptions are taken
>>>> from "perf report --no-child".
>>>>
>>>> - Before:
>>>>
>>>>    7.26 Mpps
>>>>
>>>>    _raw_spin_lock  7.83%
>>>>    veth_xdp_xmit  12.23%
>>>>
>>>> - After:
>>>>
>>>>    7.84 Mpps
>>>>
>>>>    _raw_spin_lock  1.17%
>>>>    veth_xdp_xmit   6.45%
>>>>
>>>> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
>>>> ---
>>>>   drivers/net/veth.c | 26 +++++++++++++++++++++++++-
>>>>   1 file changed, 25 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>> index 52110e5..4edc75f 100644
>>>> --- a/drivers/net/veth.c
>>>> +++ b/drivers/net/veth.c
>>>> @@ -442,6 +442,23 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>>   	return ret;
>>>>   }
>>>>   
>>>> +static void veth_xdp_flush_bq(struct net_device *dev)
>>>> +{
>>>> +	struct xdp_tx_bulk_queue *bq = this_cpu_ptr(&xdp_tx_bq);
>>>> +	int sent, i, err = 0;
>>>> +
>>>> +	sent = veth_xdp_xmit(dev, bq->count, bq->q, 0);
>>>
>>> Wait, veth_xdp_xmit() is just putting frames on a pointer ring. So
>>> you're introducing an additional per-cpu bulk queue, only to avoid lock
>>> contention around the existing pointer ring. But the pointer ring is
>>> per-rq, so if you have lock contention, this means you must have
>>> multiple CPUs servicing the same rq, no?
>>
>> Yes, it's possible. Not recommended though.
>>
>>> So why not just fix that instead?
>>
>> The queues are shared with packets from stack sent from peer. That's
>> because I needed the lock. I have tried to separate the queues, one for
>> redirect and one for stack, but receiver side got too complicated and it
>> ended up with worse performance.
> 
> I meant fix it with configuration. Now many receive queues are you
> running on the veth device in your benchmarks, and how have you
> configured the RPS?

As I wrote this test is a single queue test and does not have any 
contention.
Per packet lock has some overhead even in that configuration.

Toshiaki Makita
