Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40764 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbfDSTBK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 19 Apr 2019 15:01:10 -0400
Received: by mail-lf1-f66.google.com with SMTP id a28so4635010lfo.7
        for <xdp-newbies@vger.kernel.org>; Fri, 19 Apr 2019 12:01:08 -0700 (PDT)
Date: Fri, 19 Apr 2019 13:42:30 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [RFC PATCH 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190419104228.GA4268@khorivan>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
 <20190417174942.11811-4-ivan.khoronzhuk@linaro.org>
 <20190419083156.GA6687@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190419083156.GA6687@apalos>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: grygorii.strashko@ti.com, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, ast@kernel.org, aniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Fri, Apr 19, 2019 at 11:31:56AM +0300, Ilias Apalodimas wrote:
>Hi Ivan,
>
>> +static struct page *cpsw_alloc_page(struct cpsw_common *cpsw)
>> +{
>> +	struct page_pool *pool = cpsw->rx_page_pool;
>> +	struct page *page;
>> +	int i = 0;
>> +
>> +	do {
>> +		page = page_pool_dev_alloc_pages(pool);
>> +		if (!page)
>> +			return NULL;
>> +
>> +		/* skip pages used by skb netstack */
>I think the comment here is wrong and might confuse people.
>The page ref cnt is 1, which means the packet was *processed* and netstack is
>done with it, hence you can re-use it.
>If it's !=1 then you correctly unmap the buffer and decrease the ref cnt, so it
>will eventually be freed and not returned to the pool, right?
It's compensation substitution for page_pool support in skb netsack.
And should be considered in combine with:

skb = build_skb(xmeta, cpsw_rxbuf_total_len(pkt_size));
...
page_pool_recycle_direct(pool, page);
page_ref_inc(page);
netif_receive_skb(skb);

Here order is important.

I will correct comments in final version (w/o overloading) ofc, leaving
thinking environment for people. I think it's fair enough about this.

>> +		if (page_ref_count(page) == 1)
>> +			break;
>> +
>> +		/* it's a pitty, but free page */
>> +		page_pool_recycle_direct(pool, page);
>> +	} while (++i < descs_pool_size);
>> +
>> +	return page;
>> +}
>> +
>
> /Ilias

-- 
Regards,
Ivan Khoronzhuk
