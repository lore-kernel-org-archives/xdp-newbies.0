Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfE2IRR (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 May 2019 04:17:17 -0400
Date: Wed, 29 May 2019 10:16:59 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190529101659.2aa714b8@carbon>
In-Reply-To: <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
        <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, brouer@redhat.com

On Thu, 23 May 2019 21:20:35 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> +static struct page *cpsw_alloc_page(struct cpsw_common *cpsw)
> +{
> +	struct page_pool *pool = cpsw->rx_page_pool;
> +	struct page *page, *prev_page = NULL;
> +	int try = pool->p.pool_size << 2;
> +	int start_free = 0, ret;
> +
> +	do {
> +		page = page_pool_dev_alloc_pages(pool);
> +		if (!page)
> +			return NULL;
> +
> +		/* if netstack has page_pool recycling remove the rest */
> +		if (page_ref_count(page) == 1)
> +			break;
> +
> +		/* start free pages in use, shouldn't happen */
> +		if (prev_page == page || start_free) {
> +			/* dma unmap/puts page if rfcnt != 1 */
> +			page_pool_recycle_direct(pool, page);
> +			start_free = 1;
> +			continue;
> +		}
> +
> +		/* if refcnt > 1, page has been holding by netstack, it's pity,
> +		 * so put it to the ring to be consumed later when fast cash is
> +		 * empty. If ring is full then free page by recycling as above.
> +		 */
> +		ret = ptr_ring_produce(&pool->ring, page);

This looks very wrong to me!  First of all you are manipulation
directly with the internal pool->ring and not using the API, which
makes this code un-maintainable.  Second this is wrong, as page_pool
assume the in-variance that pages on the ring have refcnt==1.

> +		if (ret) {
> +			page_pool_recycle_direct(pool, page);
> +			continue;
> +		}
> +
> +		if (!prev_page)
> +			prev_page = page;
> +	} while (try--);
> +
> +	return page;
> +}


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
