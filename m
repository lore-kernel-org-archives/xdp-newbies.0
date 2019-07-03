Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49111 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfGCMDM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 3 Jul 2019 08:03:12 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190703120310euoutp01358c9d507e96fa5e0bdbd6f33105b6ed~t5Az86dYg1393413934euoutp01e
        for <xdp-newbies@vger.kernel.org>; Wed,  3 Jul 2019 12:03:10 +0000 (GMT)
Subject: Re: [PATCH bpf] xdp: fix race on generic receive path
From: Ilya Maximets <i.maximets@samsung.com>
Message-ID: <687d9498-87a9-11e5-dc53-f09f42d6371b@samsung.com>
Date: Wed, 3 Jul 2019 15:03:03 +0300
MIME-Version: 1.0
In-Reply-To: <20190702174014.005a3166@cakuba.netronome.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
        <20190702143634.19688-1-i.maximets@samsung.com>
        <20190702174014.005a3166@cakuba.netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On 03.07.2019 3:40, Jakub Kicinski wrote:
> On Tue,  2 Jul 2019 17:36:34 +0300, Ilya Maximets wrote:
>> Unlike driver mode, generic xdp receive could be triggered
>> by different threads on different CPU cores at the same time
>> leading to the fill and rx queue breakage. For example, this
>> could happen while sending packets from two processes to the
>> first interface of veth pair while the second part of it is
>> open with AF_XDP socket.
>>
>> Need to take a lock for each generic receive to avoid race.
>>
>> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> 
>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> index a14e8864e4fa..19f41d2b670c 100644
>> --- a/net/xdp/xsk.c
>> +++ b/net/xdp/xsk.c
>> @@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>>  {
>>  	u32 metalen = xdp->data - xdp->data_meta;
>>  	u32 len = xdp->data_end - xdp->data;
>> +	unsigned long flags;
>>  	void *buffer;
>>  	u64 addr;
>>  	int err;
>>  
>> -	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
>> -		return -EINVAL;
>> +	spin_lock_irqsave(&xs->rx_lock, flags);
> 
> Why _irqsave, rather than _bh?

Yes, spin_lock_bh() is enough here. Will change in v2.
Thanks.

> 
>> +	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
>> +		err = -EINVAL;
>> +		goto out_unlock;
>> +	}
>>  
>>  	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>>  	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
>> -		xs->rx_dropped++;
>> -		return -ENOSPC;
>> +		err = -ENOSPC;
>> +		goto out_drop;
>>  	}
>>  
>>  	addr += xs->umem->headroom;
> 
> 
> 
