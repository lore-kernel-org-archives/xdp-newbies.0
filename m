Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60690 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726817AbgCLLBC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Mar 2020 07:01:02 -0400
Received: by mail-wm1-f72.google.com with SMTP id i24so5206wml.1
        for <xdp-newbies@vger.kernel.org>; Thu, 12 Mar 2020 04:01:00 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Shared Umem between processes
In-Reply-To: <CAJ+HfNjNMhxzXTrwKjOZALO5=3UTgQz0ytyAMs5zoGB0HX29DA@mail.gmail.com>
References: <fd5e40efd5c1426cb4a5942682407ea2@hm.edu> <CAJ+HfNghFctg3L=3QdeoWyqDdj4wP4EKWjYyF01=SmCO5+=32g@mail.gmail.com> <a80ec2c07cb9493eafabb9decf479c60@hm.edu> <CAJ+HfNjiDCdaQm_PocHXC+gHABAO67b6H+f2pf+ZdHRu2uhMVA@mail.gmail.com> <69569dcbc4ce450eb5b2c1905bf11208@hm.edu> <CAJ+HfNi5sstcz20EGq2sak0RpYdBwVO5P+NLX8cALBuG_xsnHw@mail.gmail.com> <046ac5d67f6a447f98266eacaa2c25e5@hm.edu> <CAJ+HfNjNMhxzXTrwKjOZALO5=3UTgQz0ytyAMs5zoGB0HX29DA@mail.gmail.com>
Date: Thu, 12 Mar 2020 12:00:56 +0100
Message-ID: <87sgidon13.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

Björn Töpel <bjorn.topel@gmail.com> writes:

> On Thu, 12 Mar 2020 at 10:17, Gaul, Maximilian <maximilian.gaul@hm.edu> wrote:
>>
> [...]
>>
>> Thank you so much Björn!
>>
>> just to wrap things up:
>>
>> - if I want to distribute packet processing from a single RX-Queue to
>> multiple sockets I have to use shared umem because it is not possible
>> to bind multiple af-xdp sockets onto the same RX-Queue
>
> Correct! And you need a tailored XDP program that spreads over the
> shared umem sockets!

Could we lift this restriction? Not with zero-copy, obviously, but if
there's a copy involved it seems it should be possible to support
several sockets on the same RXQ? That would make it possible to use XDP
as a per-CPU load balancer for a single RXQ, like we can do with cpumap
for packets hitting the stack today?

-Toke
