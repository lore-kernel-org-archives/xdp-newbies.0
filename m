Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37811 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730630AbfGHVi0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 17:38:26 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so15854754eds.4
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 14:38:25 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Should we remove xdp-newbies from kernel patch CC-list?
In-Reply-To: <20190708.143147.1283579050790858840.davem@davemloft.net>
References: <20190704161900.43cec3a7@carbon> <CAC1LvL2Rx4+9QCDPPFYhi3kZj_srEcfw9n6ODAM2yC5jgZvE5A@mail.gmail.com> <20190708.143147.1283579050790858840.davem@davemloft.net>
Date: Mon, 08 Jul 2019 23:38:23 +0200
Message-ID: <87wogsxl4g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>, zeffron@riotgames.com
Cc: brouer@redhat.com, xdp-newbies@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Zvi Effron <zeffron@riotgames.com>
> Date: Mon, 8 Jul 2019 12:28:52 -0500
>
>> On Thu, Jul 4, 2019 at 9:19 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>>>
>>>
>>> Question to people subscribed to xdp-newbies@vger.kernel.org mailing
>>> list.  As you likely have noticed, patches and kbuild-bot is sending
>>> XDP related kernel stuff to this mailing list.  This is caused by being
>>> listed in the kernel MAINTAINERS file[1].
>>>
>> 
>> I cast my vote for both. Having the named newbies channel send many,
>> many messages with kernel patches is intimidating to new people (and
>> somewhat spammy) which makes it harder to convince my team to sign up
>> for the list. At the same time, I've appreciated being able to see
>> what's happening on patches as well as questions and discussions.
>> 
>> Would it make sense/be possible to create a mailing list for the
>> maintainers file and discussions on patches that is separate from the
>> newbies channel? I have to say, the newbies channel is the only newbie
>> friendly kernel mailing list I've seen, and it's a big part of why I
>> pushed for my company to use XDP over DPDK.
>
> The bpf and netdev lists act as incubators for XDP discussion, so I don't
> know if it's worth making an xdp-devel or something like that.

I'd worry that it would fragment the discussion too much?

-Toke
