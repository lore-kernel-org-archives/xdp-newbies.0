Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout2.mail.lrz.de ([129.187.255.138]:47079 "EHLO
        postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgCYKC5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 25 Mar 2020 06:02:57 -0400
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Shared Umem and reducing ksoftirqd-Load
Date: Wed, 25 Mar 2020 10:02:53 +0000
Message-ID: <9616cd5986c74058b51ffd1eb3311b85@hm.edu>
References: <018e8071725b48399141cc46b63641e1@hm.edu>,<CAJ8uoz1Vh+zj6msumTNWgtZY6jdOeYgoyDBoizfna1dzhC465A@mail.gmail.com>
In-Reply-To: <CAJ8uoz1Vh+zj6msumTNWgtZY6jdOeYgoyDBoizfna1dzhC465A@mail.gmail.com>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Wed, Mar 25, 2020 at 10:41 AM Karlsson, Magnus
<magnus.karlsson@gmail.com> wrote:

> On Wed, Mar 25, 2020 at 10:04 AM Gaul, Maximilian
> <maximilian.gaul@hm.edu> wrote:
> >
> > I am running a Multi-AF-XDP-Socket approach per RX-Queue (using Shared =
Umem).
> >
> > Unfortunately I am noticing, that at around 650k pps, the *ksoftirqd*-t=
hread of that RX-Queue ramps up to 100% thus leading to packet loss.
> > I tried setting *XDP_USE_NEED_WAKEUP* on *xsk_socket_cfg.bind_flags* bu=
t those bind_flags are only taken into account if *umem->refcount > 1* (lib=
bpf/xsk.c - xsk_socket__create()).
> > As far as I understand this correctly, only the first socket is able to=
 set *XDP_USE_NEED_WAKEUP* because for all sockets after, *umem->refcount* =
is going to be at least 2.
>=20
> Yes, the other sockets just inherit the settings of the first one.
>=20
> Are you using the SKB mode? What is your packet size? Sounds like a
> low number unless you have large packets and are using the SKB mode.
>=20

These are the flags I set right before calling `xsk_socket__create`:

=09xsk_socket_cfg.xdp_flags =3D cfg->xdp_flags | XDP_FLAGS_DRV_MODE | XDP_Z=
EROCOPY;
=09xsk_socket_cfg.bind_flags =3D cfg->xsk_bind_flags | XDP_USE_NEED_WAKEUP;

Packet size is around 1492 bytes.

Just to make sure: Those 650k packets are arriving on the same RX-Queue (ev=
en though this NIC has multiple RX-Queues I want to test maximum bandwith f=
or a single RX-Queue).

> > I didn't observe a dramatic change as I've hoped to. Are there some oth=
er ways to reduce interrupt load (user-space application and ksoftirq are a=
lready running on different CPUs)?
>=20
> The need_wakeup flag has a big impact when you run the softirq and the
> application thread on the same core. When using two cores for this, it
> has less of an impact.
>=20
> /Magnus
>=20
> > NIC: Mellanox Technologies MT27800
> >
> > Best regards
> >
> > Max
> >
   =20
