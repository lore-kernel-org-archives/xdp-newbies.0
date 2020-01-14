Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f46.google.com ([209.85.210.46]:35736 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANJ7b (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Jan 2020 04:59:31 -0500
Received: by mail-ot1-f46.google.com with SMTP id i15so12061066oto.2
        for <xdp-newbies@vger.kernel.org>; Tue, 14 Jan 2020 01:59:30 -0800 (PST)
MIME-Version: 1.0
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu> <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <20200113151159.GB68570@smtp.ads.isi.edu>
In-Reply-To: <20200113151159.GB68570@smtp.ads.isi.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 14 Jan 2020 10:59:19 +0100
Message-ID: <CAJ8uoz1Ax5CAfO4wfo0Pj+jieeRN+gj0s2LpeeJ53uTorFP0ng@mail.gmail.com>
Subject: Re: zero-copy between interfaces
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Ryan Goodfellow <rgoodfel@isi.edu>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Mon, Jan 13, 2020 at 4:12 PM Ryan Goodfellow <rgoodfel@isi.edu> wrote:
>
> On Mon, Jan 13, 2020 at 10:16:47AM +0100, Magnus Karlsson wrote:
> > Thanks for taking XDP and AF_XDP for a sping. I will start by fixing
> > this out-of-memory issue. With your umem size, we are hitting the size
> > limit of kmalloc. I will fix this by using kvmalloc that tries to
> > allocate with vmalloc if kmalloc fails. Should hopefully make it
> > possible for you to allocate larger umems.
> >
>
> Thanks!

Just sent out a patch on the mailing list. Would be great if you could
try it out.

/Magnus

> --
> ~ ry
