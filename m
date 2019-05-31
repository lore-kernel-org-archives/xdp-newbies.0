Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35540 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfEaXAQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 May 2019 19:00:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id h11so11124750ljb.2
        for <xdp-newbies@vger.kernel.org>; Fri, 31 May 2019 16:00:14 -0700 (PDT)
Date: Sat, 1 Jun 2019 02:00:10 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190531230008.GA15675@khorivan>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
 <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
 <20190531174643.4be8b27f@carbon>
 <20190531162523.GA3694@khorivan>
 <20190531183241.255293bc@carbon>
 <20190531170332.GB3694@khorivan>
 <a65de3a257ab5ebec83e817c092f074b58b9ae47.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a65de3a257ab5ebec83e817c092f074b58b9ae47.camel@mellanox.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "brouer@redhat.com" <brouer@redhat.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>, "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>, "hawk@kernel.org" <hawk@kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>

On Fri, May 31, 2019 at 10:08:03PM +0000, Saeed Mahameed wrote:
>On Fri, 2019-05-31 at 20:03 +0300, Ivan Khoronzhuk wrote:
>> On Fri, May 31, 2019 at 06:32:41PM +0200, Jesper Dangaard Brouer
>> wrote:
>> > On Fri, 31 May 2019 19:25:24 +0300 Ivan Khoronzhuk <
>> > ivan.khoronzhuk@linaro.org> wrote:
>> >
>> > > On Fri, May 31, 2019 at 05:46:43PM +0200, Jesper Dangaard Brouer
>> > > wrote:
>> > > > From below code snippets, it looks like you only allocated 1
>> > > > page_pool
>> > > > and sharing it with several RX-queues, as I don't have the full
>> > > > context
>> > > > and don't know this driver, I might be wrong?
>> > > >
>> > > > To be clear, a page_pool object is needed per RX-queue, as it
>> > > > is
>> > > > accessing a small RX page cache (which protected by
>> > > > NAPI/softirq).
>> > >
>> > > There is one RX interrupt and one RX NAPI for all rx channels.
>> >
>> > So, what are you saying?
>> >
>> > You _are_ sharing the page_pool between several RX-channels, but it
>> > is
>> > safe because this hardware only have one RX interrupt + NAPI
>> > instance??
>>
>> I can miss smth but in case of cpsw technically it means:
>> 1) RX interrupts are disabled while NAPI is scheduled,
>>    not for particular CPU or channel, but at all, for whole cpsw
>> module.
>> 2) RX channels are handled one by one by priority.
>
>Hi Ivan, I got a silly question..
>
>What is the reason behind having multiple RX rings and one CPU/NAPI
>handling all of them ? priority ? how do you priorities ?
Several.
One of the reason, from what I know, it can handle for several cpus/napi but
because of errata on some SoCs or for all of them it was discarded, but idea was
it can. Second it uses same davinci_cpdma API as tx channels that can be rate
limited, and it's used not only by cpsw but also by other driver, so can't be
modified easily and no reason. And third one, h/w has ability to steer some
filtered traffic to rx queues and can be potentially configured with ethtool
ntuples or so, but it's not implemented....yet.

>
>> 3) After all of them handled and no more in budget - interrupts are
>> enabled.
>> 4) If page is returned to the pool, and it's within NAPI, no races as
>> it's
>>    returned protected by softirq. If it's returned not in softirq
>> it's protected
>>    by producer lock of the ring.
>>
>> Probably it's not good example for others how it should be used, not
>> a big
>> problem to move it to separate pools.., even don't remember why I
>> decided to
>> use shared pool, there was some more reasons... need search in
>> history.
>>
>> > --
>> > Best regards,
>> >  Jesper Dangaard Brouer
>> >  MSc.CS, Principal Kernel Engineer at Red Hat
>> >  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
