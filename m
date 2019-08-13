Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35151 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbfHMSaa (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 13 Aug 2019 14:30:30 -0400
Received: by mail-lj1-f193.google.com with SMTP id l14so12519295lje.2
        for <xdp-newbies@vger.kernel.org>; Tue, 13 Aug 2019 11:30:28 -0700 (PDT)
Date: Tue, 13 Aug 2019 21:30:24 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH bpf-next 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Message-ID: <20190813183023.GA2856@khorivan>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-3-ivan.khoronzhuk@linaro.org>
 <9F98648A-8654-4767-97B5-CF4BC939393C@flugsvamp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9F98648A-8654-4767-97B5-CF4BC939393C@flugsvamp.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan Lemon <jlemon@flugsvamp.com>
Cc: magnus.karlsson@intel.com, bjorn.topel@intel.com, davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 13, 2019 at 10:42:18AM -0700, Jonathan Lemon wrote:
>
>
>On 13 Aug 2019, at 3:23, Ivan Khoronzhuk wrote:
>
>>For 64-bit there is no reason to use vmap/vunmap, so use page_address
>>as it was initially. For 32 bits, in some apps, like in samples
>>xdpsock_user.c when number of pgs in use is quite big, the kmap
>>memory can be not enough, despite on this, kmap looks like is
>>deprecated in such cases as it can block and should be used rather
>>for dynamic mm.
>>
>>Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>
>Seems a bit overkill - if not high memory, kmap() falls back
>to just page_address(), unlike vmap().

>-- Jonathan

So, as kmap has limitation... if I correctly understood, you propose
to avoid macros and do smth like kmap:

	void *addr;
	if (!PageHighMem(&umem->pgs[i]))
		addr =  page_address(page);
	else
		addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);

	umem->pages[i].addr = addr;

and while unmap

	if (!PageHighMem(&umem->pgs[i]))
		vunmap(umem->pages[i].addr);

I can try it, and add this in v2 if no objection.

>
>>---
>> net/xdp/xdp_umem.c | 16 ++++++++++++----
>> 1 file changed, 12 insertions(+), 4 deletions(-)
>>
>>diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>>index a0607969f8c0..907c9019fe21 100644
>>--- a/net/xdp/xdp_umem.c
>>+++ b/net/xdp/xdp_umem.c
>>@@ -14,7 +14,7 @@
>> #include <linux/netdevice.h>
>> #include <linux/rtnetlink.h>
>> #include <linux/idr.h>
>>-#include <linux/highmem.h>
>>+#include <linux/vmalloc.h>
>>
>> #include "xdp_umem.h"
>> #include "xsk_queue.h"
>>@@ -167,10 +167,12 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
>>
>> static void xdp_umem_unmap_pages(struct xdp_umem *umem)
>> {
>>+#if BITS_PER_LONG == 32
>> 	unsigned int i;
>>
>> 	for (i = 0; i < umem->npgs; i++)
>>-		kunmap(umem->pgs[i]);
>>+		vunmap(umem->pages[i].addr);
>>+#endif
>> }
>>
>> static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>>@@ -378,8 +380,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
>>struct xdp_umem_reg *mr)
>> 		goto out_account;
>> 	}
>>
>>-	for (i = 0; i < umem->npgs; i++)
>>-		umem->pages[i].addr = kmap(umem->pgs[i]);
>>+	for (i = 0; i < umem->npgs; i++) {
>>+#if BITS_PER_LONG == 32
>>+		umem->pages[i].addr = vmap(&umem->pgs[i], 1, VM_MAP,
>>+					   PAGE_KERNEL);
>>+#else
>>+		umem->pages[i].addr = page_address(umem->pgs[i]);
>>+#endif
>>+	}
>>
>> 	return 0;
>>
>>-- 
>>2.17.1

-- 
Regards,
Ivan Khoronzhuk
