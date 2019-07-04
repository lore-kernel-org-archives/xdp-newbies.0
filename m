Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35390 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfGDJnf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jul 2019 05:43:35 -0400
Received: by mail-lj1-f196.google.com with SMTP id x25so5537351ljh.2
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Jul 2019 02:43:34 -0700 (PDT)
Date: Thu, 4 Jul 2019 12:43:30 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH v6 net-next 5/5] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190704094329.GA19839@khorivan>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
 <20190703101903.8411-6-ivan.khoronzhuk@linaro.org>
 <20190704111939.5d845071@carbon>
 <20190704093902.GA26927@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190704093902.GA26927@apalos>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Thu, Jul 04, 2019 at 12:39:02PM +0300, Ilias Apalodimas wrote:
>On Thu, Jul 04, 2019 at 11:19:39AM +0200, Jesper Dangaard Brouer wrote:
>> On Wed,  3 Jul 2019 13:19:03 +0300
>> Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>>
>> > Add XDP support based on rx page_pool allocator, one frame per page.
>> > Page pool allocator is used with assumption that only one rx_handler
>> > is running simultaneously. DMA map/unmap is reused from page pool
>> > despite there is no need to map whole page.
>> >
>> > Due to specific of cpsw, the same TX/RX handler can be used by 2
>> > network devices, so special fields in buffer are added to identify
>> > an interface the frame is destined to. Thus XDP works for both
>> > interfaces, that allows to test xdp redirect between two interfaces
>> > easily. Aslo, each rx queue have own page pools, but common for both
>> > netdevs.
>> >
>> > XDP prog is common for all channels till appropriate changes are added
>> > in XDP infrastructure. Also, once page_pool recycling becomes part of
>> > skb netstack some simplifications can be added, like removing
>> > page_pool_release_page() before skb receive.
>> >
>> > In order to keep rx_dev while redirect, that can be somehow used in
>> > future, do flush in rx_handler, that allows to keep rx dev the same
>> > while reidrect. It allows to conform with tracing rx_dev pointed
>> > by Jesper.
>>
>> So, you simply call xdp_do_flush_map() after each xdp_do_redirect().
>> It will kill RX-bulk and performance, but I guess it will work.
>>
>> I guess, we can optimized it later, by e.g. in function calling
>> cpsw_run_xdp() have a variable that detect if net_device changed
>> (priv->ndev) and then call xdp_do_flush_map() when needed.
>I tried something similar on the netsec driver on my initial development.
>On the 1gbit speed NICs i saw no difference between flushing per packet vs
>flushing on the end of the NAPI handler.
>The latter is obviously better but since the performance impact is negligible on
>this particular NIC, i don't think this should be a blocker.
>Please add a clear comment on this and why you do that on this driver,
>so people won't go ahead and copy/paste this approach
Sry, but I did this already, is it not enouph?

-- 
Regards,
Ivan Khoronzhuk
