Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46849 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfGCAkU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 2 Jul 2019 20:40:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id h21so630886qtn.13
        for <xdp-newbies@vger.kernel.org>; Tue, 02 Jul 2019 17:40:20 -0700 (PDT)
Date: Tue, 2 Jul 2019 17:40:14 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH bpf] xdp: fix race on generic receive path
Message-ID: <20190702174014.005a3166@cakuba.netronome.com>
In-Reply-To: <20190702143634.19688-1-i.maximets@samsung.com>
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
        <20190702143634.19688-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Tue,  2 Jul 2019 17:36:34 +0300, Ilya Maximets wrote:
> Unlike driver mode, generic xdp receive could be triggered
> by different threads on different CPU cores at the same time
> leading to the fill and rx queue breakage. For example, this
> could happen while sending packets from two processes to the
> first interface of veth pair while the second part of it is
> open with AF_XDP socket.
> 
> Need to take a lock for each generic receive to avoid race.
> 
> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..19f41d2b670c 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  {
>  	u32 metalen = xdp->data - xdp->data_meta;
>  	u32 len = xdp->data_end - xdp->data;
> +	unsigned long flags;
>  	void *buffer;
>  	u64 addr;
>  	int err;
>  
> -	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
> -		return -EINVAL;
> +	spin_lock_irqsave(&xs->rx_lock, flags);

Why _irqsave, rather than _bh?

> +	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
> +		err = -EINVAL;
> +		goto out_unlock;
> +	}
>  
>  	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>  	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
> -		xs->rx_dropped++;
> -		return -ENOSPC;
> +		err = -ENOSPC;
> +		goto out_drop;
>  	}
>  
>  	addr += xs->umem->headroom;
