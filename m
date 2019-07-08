Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:58716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbfGHVbs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 17:31:48 -0400
Date: Mon, 08 Jul 2019 14:31:47 -0700 (PDT)
Message-Id: <20190708.143147.1283579050790858840.davem@davemloft.net>
Subject: Re: Should we remove xdp-newbies from kernel patch CC-list?
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAC1LvL2Rx4+9QCDPPFYhi3kZj_srEcfw9n6ODAM2yC5jgZvE5A@mail.gmail.com>
References: <20190704161900.43cec3a7@carbon>
        <CAC1LvL2Rx4+9QCDPPFYhi3kZj_srEcfw9n6ODAM2yC5jgZvE5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: zeffron@riotgames.com
Cc: brouer@redhat.com, xdp-newbies@vger.kernel.org

From: Zvi Effron <zeffron@riotgames.com>
Date: Mon, 8 Jul 2019 12:28:52 -0500

> On Thu, Jul 4, 2019 at 9:19 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>>
>>
>> Question to people subscribed to xdp-newbies@vger.kernel.org mailing
>> list.  As you likely have noticed, patches and kbuild-bot is sending
>> XDP related kernel stuff to this mailing list.  This is caused by being
>> listed in the kernel MAINTAINERS file[1].
>>
> 
> I cast my vote for both. Having the named newbies channel send many,
> many messages with kernel patches is intimidating to new people (and
> somewhat spammy) which makes it harder to convince my team to sign up
> for the list. At the same time, I've appreciated being able to see
> what's happening on patches as well as questions and discussions.
> 
> Would it make sense/be possible to create a mailing list for the
> maintainers file and discussions on patches that is separate from the
> newbies channel? I have to say, the newbies channel is the only newbie
> friendly kernel mailing list I've seen, and it's a big part of why I
> pushed for my company to use XDP over DPDK.

The bpf and netdev lists act as incubators for XDP discussion, so I don't
know if it's worth making an xdp-devel or something like that.
