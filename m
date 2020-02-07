Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vi1eur05on2056.outbound.protection.outlook.com ([40.107.21.56]:6160
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726798AbgBGMe3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 7 Feb 2020 07:34:29 -0500
Subject: Re: [PATCH bpf] xsk: publish global consumer pointers when NAPI is
 finsihed
References: <1581068272-4615-1-git-send-email-magnus.karlsson@intel.com>
From: Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <c5d6fd11-8696-e898-6f05-5fcc087c0065@mellanox.com>
Date: Fri, 7 Feb 2020 14:34:09 +0200
In-Reply-To: <1581068272-4615-1-git-send-email-magnus.karlsson@intel.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: xdp-newbies@vger.kernel.org, rgoodfel@isi.edu, bjorn.topel@intel.com, tariqt@mellanox.com, saeedm@mellanox.com, moshe@mellanox.com

On 2020-02-07 11:37, Magnus Karlsson wrote:
> The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> introduced a much more lazy way of updating the global consumer
> pointers from the kernel side, by only doing so when running out of
> entries in the fill or Tx rings (the rings consumed by the
> kernel). This can result in a deadlock with the user application if
> the kernel requires more than one entry to proceed and the application
> cannot put these entries in the fill ring because the kernel has not
> updated the global consumer pointer since the ring is not empty.
> 
> Fix this by publishing the local kernel side consumer pointer whenever
> we have copmleted Rx or Tx processing in the kernel. This way, user
> space will have an up-to-date view of the consumer pointers whenever it
> gets to execute in the one core case (application and driver on the
> same core), or after a certain number of packets have been processed
> in the two core case (application and driver on different cores).
> 
> A side effect of this patch is that the one core case gets better
> performance, but the two core case gets worse. The reason that the one
> core case improves is that updating the global consumer pointer is
> relatively cheap since the application by definition is not running
> when the kernel is (they are on the same core) and it is beneficial
> for the application, once it gets to run, to have a pointers that are
> as up to date as possible since it then can operate on more packets
> and buffers. In the two core case, the most important performance
> aspect is to minimize the number of accesses to the global pointers
> since they are shared between two cores and bounces between the caches
> of those cores. This patch results in more updates to global state,
> which means lower performance in the two core case.
> 
> Fixes: 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> Reported-by: Ryan Goodfellow <rgoodfel@isi.edu>
> Reported-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   net/xdp/xsk.c       | 2 ++
>   net/xdp/xsk_queue.h | 3 ++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index df60048..356f90e 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -217,6 +217,7 @@ static int xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>   static void xsk_flush(struct xdp_sock *xs)
>   {
>   	xskq_prod_submit(xs->rx);
> +	__xskq_cons_release(xs->umem->fq);
>   	sock_def_readable(&xs->sk);
>   }
>   
> @@ -304,6 +305,7 @@ void xsk_umem_consume_tx_done(struct xdp_umem *umem)
>   
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
> +		__xskq_cons_release(xs->tx);
>   		xs->sk.sk_write_space(&xs->sk);
>   	}
>   	rcu_read_unlock();
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index bec2af1..89a01ac 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -271,7 +271,8 @@ static inline void xskq_cons_release(struct xsk_queue *q)
>   {
>   	/* To improve performance, only update local state here.
>   	 * Reflect this to global state when we get new entries
> -	 * from the ring in xskq_cons_get_entries().
> +	 * from the ring in xskq_cons_get_entries() and whenever
> +	 * Rx or Tx processing are completed in the NAPI loop.
>   	 */
>   	q->cached_cons++;
>   }
> 

Acked-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Is it intentional that you didn't send it to bpf and netdev mailing lists?
