Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47641 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbfGBQLQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 2 Jul 2019 12:11:16 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190702161113euoutp023277df333a7f17907acdfc0d40897988~towGw49fa1364813648euoutp021
        for <xdp-newbies@vger.kernel.org>; Tue,  2 Jul 2019 16:11:13 +0000 (GMT)
Subject: Re: [PATCH bpf] xdp: fix race on generic receive path
From: Ilya Maximets <i.maximets@samsung.com>
Message-ID: <e71ae4be-76f7-8328-0c06-e2fe5459317d@samsung.com>
Date: Tue, 2 Jul 2019 19:11:09 +0300
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz34wS-Ut=TiULN32Zs-terBkzSiEws65jsd=f4S_rp43Q@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
        <20190702143634.19688-1-i.maximets@samsung.com>
        <CAJ8uoz34wS-Ut=TiULN32Zs-terBkzSiEws65jsd=f4S_rp43Q@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On 02.07.2019 18:01, Magnus Karlsson wrote:
> On Tue, Jul 2, 2019 at 4:36 PM Ilya Maximets <i.maximets@samsung.com> wrote:
>>
>> Unlike driver mode, generic xdp receive could be triggered
>> by different threads on different CPU cores at the same time
>> leading to the fill and rx queue breakage. For example, this
>> could happen while sending packets from two processes to the
>> first interface of veth pair while the second part of it is
>> open with AF_XDP socket.
>>
>> Need to take a lock for each generic receive to avoid race.
> 
> Thanks for this catch Ilya. Do you have any performance numbers you
> could share of the impact of adding this spin lock? The reason I ask
> is that if the impact is negligible, then let us just add it. But if
> it is too large, we might want to brain storm about some other
> possible solutions.

Hi. Unfortunately, I don't have a hardware for performance tests right
now, so I could run only tests over virtual interfaces like veth pair.
It'll be good if someone could check the performance with real HW.

Best regards, Ilya Maximets.

> 
> Thanks: Magnus
> 
>> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>  include/net/xdp_sock.h |  2 ++
>>  net/xdp/xsk.c          | 32 +++++++++++++++++++++++---------
>>  2 files changed, 25 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> index d074b6d60f8a..ac3c047d058c 100644
>> --- a/include/net/xdp_sock.h
>> +++ b/include/net/xdp_sock.h
>> @@ -67,6 +67,8 @@ struct xdp_sock {
>>          * in the SKB destructor callback.
>>          */
>>         spinlock_t tx_completion_lock;
>> +       /* Protects generic receive. */
>> +       spinlock_t rx_lock;
>>         u64 rx_dropped;
>>  };
>>
>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> index a14e8864e4fa..19f41d2b670c 100644
>> --- a/net/xdp/xsk.c
>> +++ b/net/xdp/xsk.c
>> @@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>>  {
>>         u32 metalen = xdp->data - xdp->data_meta;
>>         u32 len = xdp->data_end - xdp->data;
>> +       unsigned long flags;
>>         void *buffer;
>>         u64 addr;
>>         int err;
>>
>> -       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
>> -               return -EINVAL;
>> +       spin_lock_irqsave(&xs->rx_lock, flags);
>> +
>> +       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
>> +               err = -EINVAL;
>> +               goto out_unlock;
>> +       }
>>
>>         if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>>             len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
>> -               xs->rx_dropped++;
>> -               return -ENOSPC;
>> +               err = -ENOSPC;
>> +               goto out_drop;
>>         }
>>
>>         addr += xs->umem->headroom;
>> @@ -138,13 +143,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>>         memcpy(buffer, xdp->data_meta, len + metalen);
>>         addr += metalen;
>>         err = xskq_produce_batch_desc(xs->rx, addr, len);
>> -       if (!err) {
>> -               xskq_discard_addr(xs->umem->fq);
>> -               xsk_flush(xs);
>> -               return 0;
>> -       }
>> +       if (err)
>> +               goto out_drop;
>> +
>> +       xskq_discard_addr(xs->umem->fq);
>> +       xskq_produce_flush_desc(xs->rx);
>>
>> +       spin_unlock_irqrestore(&xs->rx_lock, flags);
>> +
>> +       xs->sk.sk_data_ready(&xs->sk);
>> +       return 0;
>> +
>> +out_drop:
>>         xs->rx_dropped++;
>> +out_unlock:
>> +       spin_unlock_irqrestore(&xs->rx_lock, flags);
>>         return err;
>>  }
>>
>> @@ -765,6 +778,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>>
>>         xs = xdp_sk(sk);
>>         mutex_init(&xs->mutex);
>> +       spin_lock_init(&xs->rx_lock);
>>         spin_lock_init(&xs->tx_completion_lock);
>>
>>         mutex_lock(&net->xdp.lock);
>> --
>> 2.17.1
