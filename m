Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qv1-f51.google.com ([209.85.219.51]:33406 "EHLO
        mail-qv1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLJk6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Mar 2020 05:40:58 -0400
Received: by mail-qv1-f51.google.com with SMTP id cz10so2263217qvb.0
        for <xdp-newbies@vger.kernel.org>; Thu, 12 Mar 2020 02:40:57 -0700 (PDT)
MIME-Version: 1.0
References: <fd5e40efd5c1426cb4a5942682407ea2@hm.edu> <CAJ+HfNghFctg3L=3QdeoWyqDdj4wP4EKWjYyF01=SmCO5+=32g@mail.gmail.com>
 <a80ec2c07cb9493eafabb9decf479c60@hm.edu> <CAJ+HfNjiDCdaQm_PocHXC+gHABAO67b6H+f2pf+ZdHRu2uhMVA@mail.gmail.com>
 <69569dcbc4ce450eb5b2c1905bf11208@hm.edu> <CAJ+HfNi5sstcz20EGq2sak0RpYdBwVO5P+NLX8cALBuG_xsnHw@mail.gmail.com>
 <046ac5d67f6a447f98266eacaa2c25e5@hm.edu>
In-Reply-To: <046ac5d67f6a447f98266eacaa2c25e5@hm.edu>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Thu, 12 Mar 2020 10:40:45 +0100
Message-ID: <CAJ+HfNjNMhxzXTrwKjOZALO5=3UTgQz0ytyAMs5zoGB0HX29DA@mail.gmail.com>
Subject: Re: Shared Umem between processes
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Thu, 12 Mar 2020 at 10:17, Gaul, Maximilian <maximilian.gaul@hm.edu> wro=
te:
>
[...]
>
> Thank you so much Bj=C3=B6rn!
>
> just to wrap things up:
>
> - if I want to distribute packet processing from a single RX-Queue to mul=
tiple sockets I have to use shared umem because it is not possible to bind =
multiple af-xdp sockets onto the same RX-Queue

Correct! And you need a tailored XDP program that spreads over the
shared umem sockets!

> - furthermore, you would recommend to go with a single process / multiple=
 threads solution in case of shared umem
>

Yes, and while possible to do multi-process, the solution would be
complex with little gain (IMO).

And please reach out if you have any more questions!
