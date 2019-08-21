Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f43.google.com ([209.85.210.43]:36609 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfHUQAw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Aug 2019 12:00:52 -0400
Received: by mail-ot1-f43.google.com with SMTP id k18so2555503otr.3
        for <xdp-newbies@vger.kernel.org>; Wed, 21 Aug 2019 09:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <c4ba6c71-89e0-e8c3-1353-184b2e9f99a8@yandex.ru>
In-Reply-To: <c4ba6c71-89e0-e8c3-1353-184b2e9f99a8@yandex.ru>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Wed, 21 Aug 2019 18:00:39 +0200
Message-ID: <CAJ8uoz1LyGyUwKzkLsAr+__ch+immBHvWHEfd5UApLELpb16pA@mail.gmail.com>
Subject: Re: l2fwd between interfaces
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Golshtein <ilejn@yandex.ru>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Wed, Aug 21, 2019 at 5:52 PM Ilya Golshtein <ilejn@yandex.ru> wrote:
>
> Hello,
>
> l2fwd mode of xdpsock sample puts a packet back into the same interface.
> Is there a good example how xdpsock can be modified to read a packet
> from one interface and to send it to another?
>
> I've failed to find such example and created my own app
> https://github.com/ilejn/xdpbridge.
>
> Do hope that such a thing already exists.

None exists as far as I know, so great that you are contributing
this.But could you please move your implementation over to the libbpf
interface? This will simplify it greatly.

> If not, I appreciate if anyone can review the code of my application. In
> particular I am concerned about the ENOSPC case in xq_enq_copy.

Do you not just come back and retry in this case? Looks correct, or am
I missing something?

> Basically the thing works Ok, but not as fast as I expected.
>
> I've tried to share umem to get rid of memcpy, but bind returns EINVAL
> in this case. Exploring xsk_bind (net/xdp/xsk.c) in 4.18 kernel I can
> see, that there is an explicit check umem_xs->dev != dev . Is it a
> fundamental limitaion?

Can you try supplying the same umem memory range to two different
sockets and their respective setsockopts?

Thanks: Magnus

> Thanks.
>
> --
> Regards,
> Ilya Golshtein
>
