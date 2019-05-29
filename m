Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33331 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfE2J6U (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 May 2019 05:58:20 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so1838362ljw.0
        for <xdp-newbies@vger.kernel.org>; Wed, 29 May 2019 02:58:19 -0700 (PDT)
Date: Wed, 29 May 2019 12:58:16 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190529095814.GA4639@khorivan>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
 <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
 <20190529101659.2aa714b8@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190529101659.2aa714b8@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Wed, May 29, 2019 at 10:16:59AM +0200, Jesper Dangaard Brouer wrote:
>On Thu, 23 May 2019 21:20:35 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> +static struct page *cpsw_alloc_page(struct cpsw_common *cpsw)
>> +{
>> +	struct page_pool *pool = cpsw->rx_page_pool;
>> +	struct page *page, *prev_page = NULL;
>> +	int try = pool->p.pool_size << 2;
>> +	int start_free = 0, ret;
>> +
>> +	do {
>> +		page = page_pool_dev_alloc_pages(pool);
>> +		if (!page)
>> +			return NULL;
>> +
>> +		/* if netstack has page_pool recycling remove the rest */
>> +		if (page_ref_count(page) == 1)
>> +			break;
>> +
>> +		/* start free pages in use, shouldn't happen */
>> +		if (prev_page == page || start_free) {
>> +			/* dma unmap/puts page if rfcnt != 1 */
>> +			page_pool_recycle_direct(pool, page);
>> +			start_free = 1;
>> +			continue;
>> +		}
>> +
>> +		/* if refcnt > 1, page has been holding by netstack, it's pity,
>> +		 * so put it to the ring to be consumed later when fast cash is
>> +		 * empty. If ring is full then free page by recycling as above.
>> +		 */
>> +		ret = ptr_ring_produce(&pool->ring, page);
>
>This looks very wrong to me!  First of all you are manipulation
>directly with the internal pool->ring and not using the API, which
>makes this code un-maintainable.
Yes I know, it's hack, it was with assumption to be dropped once page_pool
recycling is added.

>Second this is wrong, as page_pool
>assume the in-variance that pages on the ring have refcnt==1.
Yes, but this is w/o obvious reason, seems like it can work with refcnt > 1 if
remove restriction and use >= instead of ==.

As I answered on Ilias comment, I'm going to leave version from RFC and drop
this one.

>
>> +		if (ret) {
>> +			page_pool_recycle_direct(pool, page);
>> +			continue;
>> +		}
>> +
>> +		if (!prev_page)
>> +			prev_page = page;
>> +	} while (try--);
>> +
>> +	return page;
>> +}
>
>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
