Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27989 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731057AbfJNKFW (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 14 Oct 2019 06:05:22 -0400
Received: by mail-lj1-f198.google.com with SMTP id v24so3224541ljh.23
        for <xdp-newbies@vger.kernel.org>; Mon, 14 Oct 2019 03:05:18 -0700 (PDT)
MIME-Version: 1.0
References: <CALn2wre+wvE6DmryyT1=1NL5vShk4eqKQwTErZJbQnrg6V7jzg@mail.gmail.com>
In-Reply-To: <CALn2wre+wvE6DmryyT1=1NL5vShk4eqKQwTErZJbQnrg6V7jzg@mail.gmail.com>
From: Matteo Croce <mcroce@redhat.com>
Date: Mon, 14 Oct 2019 12:04:41 +0200
Message-ID: <CAGnkfhyt65=1XaeBs34y=u30Gk3gFVjXnOe7y0vARVjSUZ-gdg@mail.gmail.com>
Subject: Re: XDP performance and benchmarks on generic not supported NICs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Vladimir Soldatov <solardatov@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On Fri, Oct 11, 2019 at 3:46 PM Vladimir Soldatov <solardatov@gmail.com> wr=
ote:
>
> Hi guys, I could not find any XDP benchmark for the not supported NICs
> to figure out is there any benefits / performance improvements when we
> will use XDP on NICs without XDP support. Could you please share such
> benchmarks or your thoughts?
>
> Thanks in advance,
> Vladimir

Hi Vladimir,

I don't have the numbers, but it should be just slighty faster than tc.
That's say, still much faster than traversing the whole network stack.

Regards,
--=20
Matteo Croce
per aspera ad upstream
