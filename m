Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35369 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbfE0SVV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 May 2019 14:21:21 -0400
Received: by mail-lf1-f65.google.com with SMTP id a25so2825372lfg.2
        for <xdp-newbies@vger.kernel.org>; Mon, 27 May 2019 11:21:19 -0700 (PDT)
Date: Mon, 27 May 2019 21:21:15 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190527182114.GB4246@khorivan>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
 <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
 <20190524110511.GA27885@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190524110511.GA27885@apalos>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Fri, May 24, 2019 at 02:05:11PM +0300, Ilias Apalodimas wrote:
>On Thu, May 23, 2019 at 09:20:35PM +0300, Ivan Khoronzhuk wrote:
>> Add XDP support based on rx page_pool allocator, one frame per page.
>> Page pool allocator is used with assumption that only one rx_handler
>> is running simultaneously. DMA map/unmap is reused from page pool
>> despite there is no need to map whole page.
>>
>> Due to specific of cpsw, the same TX/RX handler can be used by 2
>> network devices, so special fields in buffer are added to identify
>> an interface the frame is destined to. Thus XDP works for both
>> interfaces, that allows to test xdp redirect between two interfaces
>> easily.
>>
>> XDP prog is common for all channels till appropriate changes are added
>> in XDP infrastructure.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  drivers/net/ethernet/ti/Kconfig        |   1 +
>>  drivers/net/ethernet/ti/cpsw.c         | 555 ++++++++++++++++++++++---
>>  drivers/net/ethernet/ti/cpsw_ethtool.c |  53 +++
>>  drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
>>  4 files changed, 554 insertions(+), 62 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
>> index bd05a977ee7e..3cb8c5214835 100644
>> --- a/drivers/net/ethernet/ti/Kconfig
>> +++ b/drivers/net/ethernet/ti/Kconfig
>> @@ -50,6 +50,7 @@ config TI_CPSW
>>  	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
>>  	select TI_DAVINCI_MDIO
>>  	select MFD_SYSCON
>> +	select PAGE_POOL
>>  	select REGMAP
>>  	---help---
>>  	  This driver supports TI's CPSW Ethernet Switch.
>> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
>> index 87a600aeee4a..274e6b64ea9e 100644
>> --- a/drivers/net/ethernet/ti/cpsw.c
>> +++ b/drivers/net/ethernet/ti/cpsw.c
>> @@ -31,6 +31,10 @@
>>  #include <linux/if_vlan.h>
>>  #include <linux/kmemleak.h>
>>  #include <linux/sys_soc.h>
>> +#include <net/page_pool.h>
>> +#include <linux/bpf.h>
>> +#include <linux/bpf_trace.h>
>> +#include <linux/filter.h>
>>
>>  #include <linux/pinctrl/consumer.h>

[...]

>> +			start_free = 1;
>> +			continue;
>> +		}
>> +
>> +		/* if refcnt > 1, page has been holding by netstack, it's pity,
>> +		 * so put it to the ring to be consumed later when fast cash is
>s/cash/cache
>
>> +		 * empty. If ring is full then free page by recycling as above.
>> +		 */
>> +		ret = ptr_ring_produce(&pool->ring, page);
>> +		if (ret) {
>> +			page_pool_recycle_direct(pool, page);
>> +			continue;
>> +		}
>Although this should be fine since this part won't be called during the driver
>init, i think i'd prefer unmapping the buffer and let the network stack free it,
>instead of pushing it for recycling. The occurence should be pretty low, so
>allocating a buffer every once in a while shouldn't have a noticeable
>performance impact
>

Ok, I will leave previous version from RFC.

-- 
Regards,
Ivan Khoronzhuk
