Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f177.google.com ([209.85.160.177]:44262 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfCFLxC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 6 Mar 2019 06:53:02 -0500
Received: by mail-qt1-f177.google.com with SMTP id d2so12409457qti.11
        for <xdp-newbies@vger.kernel.org>; Wed, 06 Mar 2019 03:53:01 -0800 (PST)
MIME-Version: 1.0
References: <CAHOxX0w8JcbOuq2r8eVVH9ceGEo2sR6ZSpm3khVUBQ-RxVL1XQ@mail.gmail.com>
In-Reply-To: <CAHOxX0w8JcbOuq2r8eVVH9ceGEo2sR6ZSpm3khVUBQ-RxVL1XQ@mail.gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Wed, 6 Mar 2019 12:52:50 +0100
Message-ID: <CAJ+HfNhpAGK91rUx1ftSx5h47YaRjTNr+WObO2fW=4JP43orig@mail.gmail.com>
Subject: Re: AF_XDP ring pairs handling
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On Wed, 20 Feb 2019 at 10:09, Pavel Popa <pashinho1990@gmail.com> wrote:
>
> Hi all,
>
> I'd like to know a detail regarding the handling of AF_XDP's
> <producer, consumer> ring pairs  (i.e <fill, rx>, <completion, tx>).
> When writing in a producer ring the values {0, 1, 2, 3} exactly in
> this order and updating the head pointer by +=3D 4, will the consumer
> ring will be populated with these values {0, 1, 2, 3} in exactly this
> order?
>

No, items completion/rx can be in a different order than tx/fill. IOW,
in-order cannot be assumed.


Bj=C3=B6rn

> Thanks
