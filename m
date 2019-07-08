Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43391 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfGHR3E (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 13:29:04 -0400
Received: by mail-ed1-f65.google.com with SMTP id e3so15256094edr.10
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 10:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190704161900.43cec3a7@carbon>
In-Reply-To: <20190704161900.43cec3a7@carbon>
From: Zvi Effron <zeffron@riotgames.com>
Date: Mon, 8 Jul 2019 12:28:52 -0500
Message-ID: <CAC1LvL2Rx4+9QCDPPFYhi3kZj_srEcfw9n6ODAM2yC5jgZvE5A@mail.gmail.com>
Subject: Re: Should we remove xdp-newbies from kernel patch CC-list?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Thu, Jul 4, 2019 at 9:19 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>
> Question to people subscribed to xdp-newbies@vger.kernel.org mailing
> list.  As you likely have noticed, patches and kbuild-bot is sending
> XDP related kernel stuff to this mailing list.  This is caused by being
> listed in the kernel MAINTAINERS file[1].
>

I cast my vote for both. Having the named newbies channel send many,
many messages with kernel patches is intimidating to new people (and
somewhat spammy) which makes it harder to convince my team to sign up
for the list. At the same time, I've appreciated being able to see
what's happening on patches as well as questions and discussions.

Would it make sense/be possible to create a mailing list for the
maintainers file and discussions on patches that is separate from the
newbies channel? I have to say, the newbies channel is the only newbie
friendly kernel mailing list I've seen, and it's a big part of why I
pushed for my company to use XDP over DPDK.

--Zvi
