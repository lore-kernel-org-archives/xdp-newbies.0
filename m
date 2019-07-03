Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfGCRkg (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 3 Jul 2019 13:40:36 -0400
Date: Wed, 3 Jul 2019 19:40:13 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v6 net-next 1/5] xdp: allow same allocator usage
Message-ID: <20190703194013.02842e42@carbon>
In-Reply-To: <20190703101903.8411-2-ivan.khoronzhuk@linaro.org>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
        <20190703101903.8411-2-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, brouer@redhat.com

On Wed,  3 Jul 2019 13:18:59 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> First of all, it is an absolute requirement that each RX-queue have
> their own page_pool object/allocator. And this change is intendant
> to handle special case, where a single RX-queue can receive packets
> from two different net_devices.
> 
> In order to protect against using same allocator for 2 different rx
> queues, add queue_index to xdp_mem_allocator to catch the obvious
> mistake where queue_index mismatch, as proposed by Jesper Dangaard
> Brouer.
> 
> Adding this on xdp allocator level allows drivers with such dependency
> change the allocators w/o modifications.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  include/net/xdp_priv.h |  2 ++
>  net/core/xdp.c         | 55 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
> index 6a8cba6ea79a..9858a4057842 100644
> --- a/include/net/xdp_priv.h
> +++ b/include/net/xdp_priv.h
> @@ -18,6 +18,8 @@ struct xdp_mem_allocator {
>  	struct rcu_head rcu;
>  	struct delayed_work defer_wq;
>  	unsigned long defer_warn;
> +	unsigned long refcnt;
> +	u32 queue_index;
>  };

I don't like this approach, because I think we need to extend struct
xdp_mem_allocator with a net_device pointer, for doing dev_hold(), to
correctly handle lifetime issues. (As I tried to explain previously).
This will be much harder after this change, which is why I proposed the
other patch.


>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 829377cc83db..4f0ddbb3717a 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -98,6 +98,18 @@ static bool __mem_id_disconnect(int id, bool force)
>  		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
>  		return true;
>  	}
> +
> +	/* to avoid calling hash lookup twice, decrement refcnt here till it
> +	 * reaches zero, then it can be called from workqueue afterwards.
> +	 */
> +	if (xa->refcnt)
> +		xa->refcnt--;
> +
> +	if (xa->refcnt) {
> +		mutex_unlock(&mem_id_lock);
> +		return true;
> +	}
> +
>  	xa->disconnect_cnt++;
>  
>  	/* Detects in-flight packet-pages for page_pool */
> @@ -312,6 +324,33 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
>  	return true;
>  }
>  
> +static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
> +{
> +	struct xdp_mem_allocator *xae, *xa = NULL;
> +	struct rhashtable_iter iter;
> +
> +	if (!allocator)
> +		return xa;
> +
> +	rhashtable_walk_enter(mem_id_ht, &iter);
> +	do {
> +		rhashtable_walk_start(&iter);
> +
> +		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
> +			if (xae->allocator == allocator) {
> +				xa = xae;
> +				break;
> +			}
> +		}
> +
> +		rhashtable_walk_stop(&iter);
> +
> +	} while (xae == ERR_PTR(-EAGAIN));
> +	rhashtable_walk_exit(&iter);
> +
> +	return xa;
> +}
> +
>  int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  			       enum xdp_mem_type type, void *allocator)
>  {
> @@ -347,6 +386,20 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  		}
>  	}
>  
> +	mutex_lock(&mem_id_lock);
> +	xdp_alloc = xdp_allocator_find(allocator);
> +	if (xdp_alloc) {
> +		/* One allocator per queue is supposed only */
> +		if (xdp_alloc->queue_index != xdp_rxq->queue_index)
> +			return -EINVAL;
> +
> +		xdp_rxq->mem.id = xdp_alloc->mem.id;
> +		xdp_alloc->refcnt++;
> +		mutex_unlock(&mem_id_lock);
> +		return 0;
> +	}
> +	mutex_unlock(&mem_id_lock);
> +
>  	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
>  	if (!xdp_alloc)
>  		return -ENOMEM;
> @@ -360,6 +413,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  	xdp_rxq->mem.id = id;
>  	xdp_alloc->mem  = xdp_rxq->mem;
>  	xdp_alloc->allocator = allocator;
> +	xdp_alloc->refcnt = 1;
> +	xdp_alloc->queue_index = xdp_rxq->queue_index;
>  
>  	/* Insert allocator into ID lookup table */
>  	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
