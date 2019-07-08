Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45565 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729370AbfGHUc7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 16:32:59 -0400
Received: by mail-lj1-f196.google.com with SMTP id m23so17261705lje.12
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 13:32:58 -0700 (PDT)
Date: Mon, 8 Jul 2019 23:32:54 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH v8 net-next 0/5] net: ethernet: ti: cpsw: Add XDP support
Message-ID: <20190708203252.GA12580@khorivan>
References: <20190705150502.6600-1-ivan.khoronzhuk@linaro.org>
 <20190707.183146.1123763637704790378.davem@davemloft.net>
 <20190707.183511.503486832061897586.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190707.183511.503486832061897586.davem@davemloft.net>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Sun, Jul 07, 2019 at 06:35:11PM -0700, David Miller wrote:
>From: David Miller <davem@davemloft.net>
>Date: Sun, 07 Jul 2019 18:31:46 -0700 (PDT)
>
>> From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> Date: Fri,  5 Jul 2019 18:04:57 +0300
>>
>>> This patchset adds XDP support for TI cpsw driver and base it on
>>> page_pool allocator. It was verified on af_xdp socket drop,
>>> af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.
>>>
>>> It was verified with following configs enabled:
>>  ...
>>
>> I'm applying this to net-next, please deal with whatever follow-ups are
>> necessary.
>
>Nevermind, you really have to fix this:
>
>drivers/net/ethernet/ti/davinci_cpdma.c: In function ‘cpdma_chan_submit_si’:
>drivers/net/ethernet/ti/davinci_cpdma.c:1047:12: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>   buffer = (u32)si->data;
>            ^
>drivers/net/ethernet/ti/davinci_cpdma.c: In function ‘cpdma_chan_idle_submit_mapped’:
>drivers/net/ethernet/ti/davinci_cpdma.c:1114:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>  si.data = (void *)(u32)data;
>            ^
>drivers/net/ethernet/ti/davinci_cpdma.c: In function ‘cpdma_chan_submit_mapped’:
>drivers/net/ethernet/ti/davinci_cpdma.c:1164:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>  si.data = (void *)(u32)data;
>            ^
Actrually that's fixed in reply v9 patch.
But, nevermind, i will send v9 for whole series.

-- 
Regards,
Ivan Khoronzhuk
