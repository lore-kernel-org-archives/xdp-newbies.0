Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbfIJOi4 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 10 Sep 2019 10:38:56 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D427D9820
        for <xdp-newbies@vger.kernel.org>; Tue, 10 Sep 2019 14:38:56 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id a7so6435019edt.13
        for <xdp-newbies@vger.kernel.org>; Tue, 10 Sep 2019 07:38:55 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: bidirectional: => AF_XDP , <= XDP_REDIRECT
In-Reply-To: <e83a6f5d-785e-d3c7-6bd8-63d972973427@yandex.ru>
References: <d52b5b48-06cf-42dc-180d-896601cf3efb@yandex.ru> <87imq0ut8l.fsf@toke.dk> <e83a6f5d-785e-d3c7-6bd8-63d972973427@yandex.ru>
Date: Tue, 10 Sep 2019 15:38:52 +0100
Message-ID: <87a7bcusg3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Goslhtein <ilejn@yandex.ru>, xdp-newbies@vger.kernel.org

Ilya Goslhtein <ilejn@yandex.ru> writes:

> Hello Toke,
>
> thanks for the response.
>
> I do not think that it is the case.
>
> The interface I am trying to share is outgoing for xdpbridge and 
> incoming for xdp_bridge_map.
>
> xdpbridge does not load xdp program for outgoing interface (while loads 
> for incoming).
>
> xdp_bridge_map loads dummy XDP program for outgoing redirect, while it 
> is Ok if it is already exists.
>
>
> It seems that if I use different queues for incoming and outgoing 
> packets, everything is Ok, while I am not 100% sure yet. Does it look 
> realistic?

Oh, right, yeah, the AF_XDP socket will need to configure a hardware
queue to use; depending on your hardware, that could be incompatible
with running a regular XDP program on the same hardware queue.

Incidently, we are working on a way to make this work better; talk
starts in five minutes at LPC:
https://linuxplumbersconf.org/event/4/contributions/462/

-Toke
