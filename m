Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37348 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfGDJxL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jul 2019 05:53:11 -0400
Received: by mail-lj1-f194.google.com with SMTP id 131so5552799ljf.4
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Jul 2019 02:53:09 -0700 (PDT)
Date: Thu, 4 Jul 2019 12:53:06 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH v6 net-next 5/5] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190704095305.GC19839@khorivan>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
 <20190703101903.8411-6-ivan.khoronzhuk@linaro.org>
 <20190704111939.5d845071@carbon>
 <20190704093902.GA26927@apalos>
 <20190704094329.GA19839@khorivan>
 <20190704094938.GA27382@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190704094938.GA27382@apalos>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Thu, Jul 04, 2019 at 12:49:38PM +0300, Ilias Apalodimas wrote:
>On Thu, Jul 04, 2019 at 12:43:30PM +0300, Ivan Khoronzhuk wrote:
>> On Thu, Jul 04, 2019 at 12:39:02PM +0300, Ilias Apalodimas wrote:
>> >On Thu, Jul 04, 2019 at 11:19:39AM +0200, Jesper Dangaard Brouer wrote:
>> >>On Wed,  3 Jul 2019 13:19:03 +0300
>> >>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>> >>
>> >>> Add XDP support based on rx page_pool allocator, one frame per page.
>> >>> Page pool allocator is used with assumption that only one rx_handler
>> >>> is running simultaneously. DMA map/unmap is reused from page pool
>> >>> despite there is no need to map whole page.
>> >>>
>> >>> Due to specific of cpsw, the same TX/RX handler can be used by 2
>> >>> network devices, so special fields in buffer are added to identify
>> >>> an interface the frame is destined to. Thus XDP works for both
>> >>> interfaces, that allows to test xdp redirect between two interfaces
>> >>> easily. Aslo, each rx queue have own page pools, but common for both
>> >>> netdevs.
>> >>>
>> >>> XDP prog is common for all channels till appropriate changes are added
>> >>> in XDP infrastructure. Also, once page_pool recycling becomes part of
>> >>> skb netstack some simplifications can be added, like removing
>> >>> page_pool_release_page() before skb receive.
>> >>>
>> >>> In order to keep rx_dev while redirect, that can be somehow used in
>> >>> future, do flush in rx_handler, that allows to keep rx dev the same
>> >>> while reidrect. It allows to conform with tracing rx_dev pointed
>> >>> by Jesper.
>> >>
>> >>So, you simply call xdp_do_flush_map() after each xdp_do_redirect().
>> >>It will kill RX-bulk and performance, but I guess it will work.
>> >>
>> >>I guess, we can optimized it later, by e.g. in function calling
>> >>cpsw_run_xdp() have a variable that detect if net_device changed
>> >>(priv->ndev) and then call xdp_do_flush_map() when needed.
>> >I tried something similar on the netsec driver on my initial development.
>> >On the 1gbit speed NICs i saw no difference between flushing per packet vs
>> >flushing on the end of the NAPI handler.
>> >The latter is obviously better but since the performance impact is negligible on
>> >this particular NIC, i don't think this should be a blocker.
>> >Please add a clear comment on this and why you do that on this driver,
>> >so people won't go ahead and copy/paste this approach
>> Sry, but I did this already, is it not enouph?
>The flush *must* happen there to avoid messing the following layers. The comment
>says something like 'just to be sure'. It's not something that might break, it's
>something that *will* break the code and i don't think that's clear with the
>current comment.
>
>So i'd prefer something like
>'We must flush here, per packet, instead of doing it in bulk at the end of
>the napi handler.The RX devices on this particular hardware is sharing a
>common queue, so the incoming device might change per packet'
Sounds good, will replace on it.

-- 
Regards,
Ivan Khoronzhuk
