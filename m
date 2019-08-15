Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46868 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfHOTdA (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 15 Aug 2019 15:33:00 -0400
From: "Jonathan Lemon" <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Date: Thu, 15 Aug 2019 12:32:57 -0700
Message-ID: <0BD97FA1-8251-436D-A1F8-00BEF0791B95@gmail.com>
In-Reply-To: <20190815191456.GA11699@khorivan>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
 <5B58D364-609F-498E-B7DF-4457D454A14D@gmail.com>
 <20190815191456.GA11699@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: magnus.karlsson@intel.com, bjorn.topel@intel.com, davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org, yhs@fb.com, andrii.nakryiko@gmail.com



On 15 Aug 2019, at 12:19, Ivan Khoronzhuk wrote:

> On Thu, Aug 15, 2019 at 11:23:16AM -0700, Jonathan Lemon wrote:
>> On 15 Aug 2019, at 5:13, Ivan Khoronzhuk wrote:
>>
>>> For 64-bit there is no reason to use vmap/vunmap, so use 
>>> page_address
>>> as it was initially. For 32 bits, in some apps, like in samples
>>> xdpsock_user.c when number of pgs in use is quite big, the kmap
>>> memory can be not enough, despite on this, kmap looks like is
>>> deprecated in such cases as it can block and should be used rather
>>> for dynamic mm.
>>>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>> ---
>>> net/xdp/xdp_umem.c | 36 ++++++++++++++++++++++++++++++------
>>> 1 file changed, 30 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>>> index a0607969f8c0..d740c4f8810c 100644
>>> --- a/net/xdp/xdp_umem.c
>>> +++ b/net/xdp/xdp_umem.c
>>> @@ -14,7 +14,7 @@
>>> #include <linux/netdevice.h>
>>> #include <linux/rtnetlink.h>
>>> #include <linux/idr.h>
>>> -#include <linux/highmem.h>
>>> +#include <linux/vmalloc.h>
>>>
>>> #include "xdp_umem.h"
>>> #include "xsk_queue.h"
>>> @@ -170,7 +170,30 @@ static void xdp_umem_unmap_pages(struct 
>>> xdp_umem *umem)
>>> 	unsigned int i;
>>>
>>> 	for (i = 0; i < umem->npgs; i++)
>>> -		kunmap(umem->pgs[i]);
>>> +		if (PageHighMem(umem->pgs[i]))
>>> +			vunmap(umem->pages[i].addr);
>>> +}
>>> +
>>> +static int xdp_umem_map_pages(struct xdp_umem *umem)
>>> +{
>>> +	unsigned int i;
>>> +	void *addr;
>>> +
>>> +	for (i = 0; i < umem->npgs; i++) {
>>> +		if (PageHighMem(umem->pgs[i]))
>>> +			addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);
>>> +		else
>>> +			addr = page_address(umem->pgs[i]);
>>> +
>>> +		if (!addr) {
>>> +			xdp_umem_unmap_pages(umem);
>>> +			return -ENOMEM;
>>> +		}
>>> +
>>> +		umem->pages[i].addr = addr;
>>> +	}
>>> +
>>> +	return 0;
>>> }
>>
>> You'll want a __xdp_umem_unmap_pages() helper here that takes an
>> count of the number of pages to unmap, so it can be called from
>> xdp_umem_unmap_pages() in the normal case, and xdp_umem_map_pages()
>> in the error case.  Otherwise the error case ends up calling
>> PageHighMem on a null page.
>> -- 
>> Jonathan
>
> Do you mean null address?
> If so, then vunmap do nothing if it's null, and addr is null if it's 
> not
> assigned... and it's not assigned w/o correct mapping...
>
> If you mean null page, then it is not possible after all they are
> pinned above, here: xdp_umem_pin_pages(), thus assigned.
>
> Or I missed smth?

No - I forgot about umem_pin_pages() - feel free to ignore my comments.
--
Jonathan

>
> Despite of this, seems like here should be one more patch, adding 
> unpinning page
> in error path, but this not related to this change. Will do this in 
> follow up
> fix patch, if no objection to my explanation, ofc.
>
> -- 
> Regards,
> Ivan Khoronzhuk
