Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33765 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfEaX1d (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 May 2019 19:27:33 -0400
Received: by mail-lf1-f67.google.com with SMTP id y17so9230071lfe.0
        for <xdp-newbies@vger.kernel.org>; Fri, 31 May 2019 16:27:32 -0700 (PDT)
Date: Sat, 1 Jun 2019 02:27:28 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190531232727.GB15675@khorivan>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
 <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
 <20190531174643.4be8b27f@carbon>
 <20190531162523.GA3694@khorivan>
 <20190531183241.255293bc@carbon>
 <20190531170332.GB3694@khorivan>
 <20190601003736.65cb6a61@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190601003736.65cb6a61@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Sat, Jun 01, 2019 at 12:37:36AM +0200, Jesper Dangaard Brouer wrote:
>On Fri, 31 May 2019 20:03:33 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> Probably it's not good example for others how it should be used, not
>> a big problem to move it to separate pools.., even don't remember why
>> I decided to use shared pool, there was some more reasons... need
>> search in history.
>
>Using a shared pool is makes it a lot harder to solve the issue I'm
>currently working on.  That is handling/waiting for in-flight frames to
>complete, before removing the mem ID from the (r)hashtable lookup.  I
>have working code, that basically remove page_pool_destroy() from
>public API, and instead lets xdp_rxq_info_unreg() call it when
>in-flight count reach zero (and delay fully removing the mem ID).

Frankly, not see reason why it can block smth, it can be considered
like not shared pool. But Ok, anyway it can look more logical and can be
reused by another SoC. I will add it per channel not a problem,
at least for now no blockers. Adding pool per channel will create more
page_pool_destroy() calls, per each pool, that I can be dropped once
you decided to remove it form the API.

This API is called along with xdp_rxq_info_unreg(), and seems like not
a problem to just remove page_pool_destroy(), except one case that
worries me... cpsw has one interesting feature, share same h/w with 2
network devices like dual mac, basically it's 3 port switch, but used
as 2 separate interfaces. So that, both of them share same queues/channels/rings.
XDP rxq requires network device to be set in rxq info, wich is used in the
code as a pointer and is shared between xdp buffers, so can't be changed in
flight. That's why each network interface has it's own instances of rxq, but
page pools per each network device is common, so when I call
xdp_rxq_info_unreg() per net device it doesn't mean I want to delete
page pool....But seems I can avoid it calling xdp_rxq_info_unreg()
for both when delete page pools...

>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
