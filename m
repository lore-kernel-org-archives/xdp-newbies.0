Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40765 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCNUU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 3 Jul 2019 09:20:20 -0400
MIME-Version: 1.0
References: <CGME20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77@eucas1p2.samsung.com>
 <20190703120916.19973-1-i.maximets@samsung.com>
In-Reply-To: <20190703120916.19973-1-i.maximets@samsung.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Wed, 3 Jul 2019 15:20:08 +0200
Message-ID: <CAJ8uoz1Wr+bJrO+HNtSD5b79ych-pNg7BxFiHVhzaMSGGAdqLA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xdp: fix race on generic receive path
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>
Cc: Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Wed, Jul 3, 2019 at 2:09 PM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Unlike driver mode, generic xdp receive could be triggered
> by different threads on different CPU cores at the same time
> leading to the fill and rx queue breakage. For example, this
> could happen while sending packets from two processes to the
> first interface of veth pair while the second part of it is
> open with AF_XDP socket.
>
> Need to take a lock for each generic receive to avoid race.

I measured the performance degradation of rxdrop on my local machine
and it went from 2.19 to 2.08, so roughly a 5% drop. I think we can
live with this in XDP_SKB mode. If we at some later point in time need
to boost performance in this mode, let us look at it then from a
broader perspective and find the most low hanging fruit.

Thanks Ilya for this fix.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>
> Version 2:
>     * spin_lock_irqsave --> spin_lock_bh.
>
>  include/net/xdp_sock.h |  2 ++
>  net/xdp/xsk.c          | 31 ++++++++++++++++++++++---------
>  2 files changed, 24 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index d074b6d60f8a..ac3c047d058c 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -67,6 +67,8 @@ struct xdp_sock {
>          * in the SKB destructor callback.
>          */
>         spinlock_t tx_completion_lock;
> +       /* Protects generic receive. */
> +       spinlock_t rx_lock;
>         u64 rx_dropped;
>  };
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..5e0637db92ea 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -123,13 +123,17 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>         u64 addr;
>         int err;
>
> -       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
> -               return -EINVAL;
> +       spin_lock_bh(&xs->rx_lock);
> +
> +       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
> +               err = -EINVAL;
> +               goto out_unlock;
> +       }
>
>         if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>             len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
> -               xs->rx_dropped++;
> -               return -ENOSPC;
> +               err = -ENOSPC;
> +               goto out_drop;
>         }
>
>         addr += xs->umem->headroom;
> @@ -138,13 +142,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>         memcpy(buffer, xdp->data_meta, len + metalen);
>         addr += metalen;
>         err = xskq_produce_batch_desc(xs->rx, addr, len);
> -       if (!err) {
> -               xskq_discard_addr(xs->umem->fq);
> -               xsk_flush(xs);
> -               return 0;
> -       }
> +       if (err)
> +               goto out_drop;
> +
> +       xskq_discard_addr(xs->umem->fq);
> +       xskq_produce_flush_desc(xs->rx);
>
> +       spin_unlock_bh(&xs->rx_lock);
> +
> +       xs->sk.sk_data_ready(&xs->sk);
> +       return 0;
> +
> +out_drop:
>         xs->rx_dropped++;
> +out_unlock:
> +       spin_unlock_bh(&xs->rx_lock);
>         return err;
>  }
>
> @@ -765,6 +777,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>
>         xs = xdp_sk(sk);
>         mutex_init(&xs->mutex);
> +       spin_lock_init(&xs->rx_lock);
>         spin_lock_init(&xs->tx_completion_lock);
>
>         mutex_lock(&net->xdp.lock);
> --
> 2.17.1
>
