Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-c.ads.isi.edu ([128.9.180.198]:14331 "EHLO
        mail-c.ads.isi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMP2C (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 13 Jan 2020 10:28:02 -0500
Date: Mon, 13 Jan 2020 10:28:00 -0500
From: Ryan Goodfellow <rgoodfel@isi.edu>
Subject: Re: zero-copy between interfaces
Message-ID: <20200113152759.GD68570@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
 <20200113124134.3974cbed@carbon>
MIME-Version: 1.0
In-Reply-To: <20200113124134.3974cbed@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Mon, Jan 13, 2020 at 12:41:34PM +0100, Jesper Dangaard Brouer wrote:
> On Mon, 13 Jan 2020 00:18:36 +0000
> Ryan Goodfellow <rgoodfel@isi.edu> wrote:
>=20
> > The numbers that I have been able to achive with this code are the foll=
owing. MTU
> > is 1500 in all cases.
> >=20
> >     mlx5: pps ~ 2.4 Mpps, 29 Gbps (driver mode, zero-copy)
> >     i40e: pps ~ 700 Kpps, 8 Gbps (skb mode, copy)
> >     virtio: pps ~ 200 Kpps, 2.4 Gbps (skb mode, copy, all qemu/kvm VMs)
> >=20
> > Are these numbers in the ballpark of what's expected?
>=20
> I would say they are too slow / low.
>=20
> Have you remembered to do bulking?
>=20

I am using a batch size of 256.

--=20
~ ry
