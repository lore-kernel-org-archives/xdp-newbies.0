Return-Path: <xdp-newbies-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C18C433DB
	for <xdp-newbies@archiver.kernel.org>; Thu, 25 Mar 2021 18:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 792FE61963
	for <xdp-newbies@archiver.kernel.org>; Thu, 25 Mar 2021 18:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCYSvv (ORCPT <rfc822;xdp-newbies@archiver.kernel.org>);
        Thu, 25 Mar 2021 14:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCYSvn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 25 Mar 2021 14:51:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82767C06174A
        for <xdp-newbies@vger.kernel.org>; Thu, 25 Mar 2021 11:51:43 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w18so3669250edc.0
        for <xdp-newbies@vger.kernel.org>; Thu, 25 Mar 2021 11:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7qL78CkXA6nZlChQLtj8YwUKdbCuChyqrry5HWW/CC8=;
        b=Ric9xaKqE8Nh62Ex781mJ3s4mCDED1fZzvwvGMvfoafyZ7KaJrV41DLwyyjG+ZkY1D
         usgbadvbi8SVvAyexfWawAluep9V8g60C05wUk6ki73D/DjYFYOL3XD6ip0M5xgsowYS
         ayFQIR56LrdwSl9xx0DVt6ekAWTzDQcug62zaxNRg/3VGgr/TZsVwBUC2K7T2XOqijIu
         bk9e9ZIskFErITXS/XlBtOgvTpv7eGbSVF5dQirup2VI6Z+QSEUVxvAGCtUvVuO42fIR
         /Tgi9KVOGrn1KOBGzyBDDxgCdZFolEpSRQA2HHDob/4nmL+HSyZp/AmfBRw6u8ailFWC
         pv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7qL78CkXA6nZlChQLtj8YwUKdbCuChyqrry5HWW/CC8=;
        b=mP8hWcBY2YQl73EEx2pycQwQZx47OWJfvAtrdnhCkLLBgGF4s6olCnPg1vPFBPCgLa
         FEOamBey0Gbas5UhDtamJPM0p0JJWbORBg0tpU5FnQvsmeQJM2P1J3FEodPRXZtcc8CK
         DGxL1YhgVMeiz5HSjQ+hVeTiOglckdvaJp90t4rh9fLzRkp2K8yG93FFETgUhG1zCk3/
         bk4ziD7FPSU02JzLjSm1snaV+klCrXkD5V+bL5JY1inoARFeoZFGQ6xvJPucIOu9sRnL
         KPOVng1UpwAoXTQDtqMw0ngs5UgStnbNj286kb93QpBVPGkvQcUemmehseH7CRQnFThJ
         27VA==
X-Gm-Message-State: AOAM5304BUU88bvIO1fwU2pNmqcyqQKye1zYAEDTjvtg4uSsM/7NZzQl
        Mt1dUMKcZUPVf4PHb6fHgK9bsKhF64//FjolYl0=
X-Google-Smtp-Source: ABdhPJwkmUsNoz10J8E4eyC+7Xa9grOqAMvoNDeH3Gkc19tYAbfpGwvR8k6D6dRgdzLlhzpIvLj5GGiOPQNokNmpGyg=
X-Received: by 2002:a05:6402:22bb:: with SMTP id cx27mr10645898edb.148.1616698302130;
 Thu, 25 Mar 2021 11:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAHAzn3peP-j-oL76FxmyRgHg=QbMfeykA4rQdoDRA-0c6iQ4mg@mail.gmail.com>
 <CAJ8uoz1VyA7OvtPzXUqUfZRPUv18RxEs3szR03k2vgDuwq3N3w@mail.gmail.com>
In-Reply-To: <CAJ8uoz1VyA7OvtPzXUqUfZRPUv18RxEs3szR03k2vgDuwq3N3w@mail.gmail.com>
From:   Konstantinos Kaffes <kkaffes@gmail.com>
Date:   Thu, 25 Mar 2021 11:51:31 -0700
Message-ID: <CAHAzn3rE7Xhvi3tW7EQ6+RAmRwY-Ldx4HiJbjzs7dxXoW=RcoA@mail.gmail.com>
Subject: Re: AF_XDP sockets across multiple NIC queues
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <xdp-newbies.vger.kernel.org>
X-Mailing-List: xdp-newbies@vger.kernel.org

Great, thanks for the info! I will look into implementing this.

For the time being, I implemented a version of my design with N^2
sockets. I observed that when all traffic is directed to a single NIC
queue, the throughput is higher than when I use all N NIC queues. I am
using spinlocks to guard concurrent access to UMEM and the
fill/completion rings. When I use a single NIC queue, I achieve
~1Mpps; when I use multiple ~550Kpps. Are these numbers reasonable,
and this bad scaling behavior expected?


On Thu, 25 Mar 2021 at 00:24, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
>
> On Thu, Mar 25, 2021 at 7:25 AM Konstantinos Kaffes <kkaffes@gmail.com> wrote:
> >
> > Hello everyone,
> >
> > I want to write a multi-threaded AF_XDP server where all N threads can
> > read from all N NIC queues. In my design, each thread creates N AF_XDP
> > sockets, each associated with a different queue. I have the following
> > questions:
> >
> > 1. Do sockets associated with the same queue need to share their UMEM
> > area and fill and completion rings?
>
> Yes. In zero-copy mode this is natural since the NIC HW will DMA the
> packet into a umem that was decided long before the packet was even
> received. And this is of course before we even get to pick what socket
> it should go to. This restriction is currently carried over to
> copy-mode, however, in theory there is nothing preventing supporting
> multiple umems on the same netdev and queue id in copy-mode. It is
> just that nobody has implemented support for it.
>
> > 2. Will there be a single XSKMAP holding all N^2 sockets? If yes, what
> > happens if my XDP program redirects a packet to a socket that is
> > associated with a different NIC queue than the one in which the packet
> > arrived?
>
> You can have multiple XSKMAPs but you would in any case have to have
> N^2 sockets in total to be able to cover all cases. Sockets are tied
> to a specific netdev and queue id. If you try to redirect to socket
> with a queue id or netdev that the packet was not received on, it will
> be dropped. Again, for copy-mode, it would from a theoretical
> perspective be perfectly fine to redirect to another queue id and/or
> netdev since the packet is copied anyway. Maybe you want to add
> support for it :-).
>
> > I must mention that I am using the XDP skb mode with copies.
> >
> > Thank you in advance,
> > Kostis



-- 
Kostis Kaffes
PhD Student in Electrical Engineering
Stanford University
