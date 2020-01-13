Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-d.ads.isi.edu ([128.9.180.199]:1576 "EHLO
        mail-d.ads.isi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPMC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 13 Jan 2020 10:12:02 -0500
Date: Mon, 13 Jan 2020 10:11:59 -0500
From: Ryan Goodfellow <rgoodfel@isi.edu>
Subject: Re: zero-copy between interfaces
Message-ID: <20200113151159.GB68570@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
 <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Mon, Jan 13, 2020 at 10:16:47AM +0100, Magnus Karlsson wrote:
> Thanks for taking XDP and AF_XDP for a sping. I will start by fixing
> this out-of-memory issue. With your umem size, we are hitting the size
> limit of kmalloc. I will fix this by using kvmalloc that tries to
> allocate with vmalloc if kmalloc fails. Should hopefully make it
> possible for you to allocate larger umems.
>=20

Thanks!

--=20
~ ry
