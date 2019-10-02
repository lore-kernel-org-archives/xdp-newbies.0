Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43022 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJBQ3H (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 2 Oct 2019 12:29:07 -0400
Received: by mail-lj1-f195.google.com with SMTP id n14so17765534ljj.10
        for <xdp-newbies@vger.kernel.org>; Wed, 02 Oct 2019 09:29:06 -0700 (PDT)
Date: Wed, 2 Oct 2019 18:28:57 +0200
From: Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: xdpsock problem testing multiple queues
Message-ID: <20191002182755.00000657@gmail.com>
In-Reply-To: <CAJ+HfNh58fN=BU5ADzTs=vbCD1j5fs0i1EKhAQQdByjiVHz4BQ@mail.gmail.com>
References: <ccfd36d0372547099b96ea494e2c6369@pantheon.tech>
        <CAJ+HfNh58fN=BU5ADzTs=vbCD1j5fs0i1EKhAQQdByjiVHz4BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc: =?ISO-8859-1?Q?J=FAlius?= Milan <Julius.Milan@pantheon.tech>, Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>, Marek =?ISO-8859-1?Q?Z=E1vodsk=FD?= <marek.zavodsky@pantheon.tech>, Jesper Dangaard Brouer <brouer@redhat.com>, William Tu <u9012063@gmail.com>, Eelco Chaudron <echaudro@redhat.com>

On Wed, 2 Oct 2019 15:52:04 +0200
Bj=F6rn T=F6pel <bjorn.topel@gmail.com> wrote:

> On Wed, 2 Oct 2019 at 14:11, J=FAlius Milan <Julius.Milan@pantheon.tech> =
wrote:
> >
> > Hi all
> >
> > We are trying to test multiple RX queues with sample program xdpsock fr=
om kernel on vmware virtual machine with 2 queues.
> > The driver on the NIC is:
> > # ethtool -i ens192
> > driver: vmxnet3
> > version: 1.4.16.0-k-NAPI
> >
> > NIC has 2 queues, I can check it by ethtool -S.
> >
> > But when I try to use queue 1, I am getting following:
> > # ./xdpsock -i ens192 -q 1
> > /home/jmilan/ws/pt-xdp/linux/samples/bpf/xdpsock_user.c:xsk_configure_s=
ocket:315: errno: 1/"Operation not permitted"
> >
> > Any ideas what the problem could be? Maybe vmxnet3 driver does not supp=
ort some necessary operations related to queues?
> > =20
>=20
> XDP support is missing for that driver, but the XDP_SKB/generic mode
> is available, and should work.
>=20
> Can you run the xdp1 application in the samples directory, to rule out
> that you can run XDP.

xdp1 should work fine but I think the reason for a reported failure is beca=
use
vmxnet3 driver doesn't expose the {set,get}_channels ethtool API (at least I
don't see it?) which is used by libbpf's xsk part for querying the underlyi=
ng
driver how many queues does it has and use that info for creating that many
entries in XSKMAP.

So in that case you're limited to use queue 0 because the XSKMAP map has
only single entry.

Maciej

>=20
>=20
> Bj=F6rn
>=20
> > Best Regards
> > J=FAlius =20
