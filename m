Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:53821 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgCYMkT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 25 Mar 2020 08:40:19 -0400
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Shared Umem and reducing ksoftirqd-Load
Date: Wed, 25 Mar 2020 12:40:16 +0000
Message-ID: <883111619d9e429fb5f1fb239afdb478@hm.edu>
References: <018e8071725b48399141cc46b63641e1@hm.edu>
 <CAJ8uoz1Vh+zj6msumTNWgtZY6jdOeYgoyDBoizfna1dzhC465A@mail.gmail.com>
 <9616cd5986c74058b51ffd1eb3311b85@hm.edu>
 <CAJ8uoz1-Nub4RKembg5maQ4Cj1J+O90eR_PcP41yNHuq7pShaQ@mail.gmail.com>
 <35eed7a7481a44bc93e8e5f7e59d9e5a@hm.edu>,<CAJ8uoz3D=nw_aD0+Kj9Mh_DivRBvse0+G0Mtfw+eR8UJdDT0jw@mail.gmail.com>
In-Reply-To: <CAJ8uoz3D=nw_aD0+Kj9Mh_DivRBvse0+G0Mtfw+eR8UJdDT0jw@mail.gmail.com>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Wed, Mar 25, 2020 at 12:04 AM Karlsson, Magnus
magnus.karlsson@gmail.com> wrote:

> On Wed, Mar 25, 2020 at 11:45 AM Gaul, Maximilian
> <maximilian.gaul@hm.edu> wrote:
> >
> > On Wed, Mar 25, 2020 at 11:24 AM Karlsson, Magnus
> > <magnus.karlsson@gmail.com> wrote:
> >
> > > On Wed, Mar 25, 2020 at 11:02 AM Gaul, Maximilian
> > > <maximilian.gaul@hm.edu> wrote:
> > > >
> > > > On Wed, Mar 25, 2020 at 10:41 AM Karlsson, Magnus
> > > > <magnus.karlsson@gmail.com> wrote:
> > > >
> > > > > On Wed, Mar 25, 2020 at 10:04 AM Gaul, Maximilian
> > > > > <maximilian.gaul@hm.edu> wrote:
> > > > > >
> > > > > > I am running a Multi-AF-XDP-Socket approach per RX-Queue (using=
 Shared Umem).
> > > > > >
> > > > > > Unfortunately I am noticing, that at around 650k pps, the *ksof=
tirqd*-thread of that RX-Queue ramps up to 100% thus leading to packet loss=
.
> > > > > > I tried setting *XDP_USE_NEED_WAKEUP* on *xsk_socket_cfg.bind_f=
lags* but those bind_flags are only taken into account if *umem->refcount >=
 1* (libbpf/xsk.c - xsk_socket__create()).
> > > > > > As far as I understand this correctly, only the first socket is=
 able to set *XDP_USE_NEED_WAKEUP* because for all sockets after, *umem->re=
fcount* is going to be at least 2.
> > > > >
> > > > > Yes, the other sockets just inherit the settings of the first one=
.
> > > > >
> > > > > Are you using the SKB mode? What is your packet size? Sounds like=
 a
> > > > > low number unless you have large packets and are using the SKB mo=
de.
> > > > >
> > > >
> > > > These are the flags I set right before calling `xsk_socket__create`=
:
> > > >
> > > >=A0=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.xdp_flags =3D cfg->xdp_flags=
 | XDP_FLAGS_DRV_MODE | XDP_ZEROCOPY;
> > > >=A0=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.bind_flags =3D cfg->xsk_bind=
_flags | XDP_USE_NEED_WAKEUP;
> > >
> > > XDP_ZEROCOPY is a bind flag not an XDP flag, so please move it there.
> > > If you get an error when you have it set, it means that your setup
> > > does not support zero-copy for some reason. Check what kernel version
> > > you are using and the the driver you are using supports zero-copy. I
> > > believe you need to use a queue id>=3D32 in the Mellanox driver for i=
t
> > > to work in zero-copy mode. Below 32, you will get copy mode.
> > >
> > > > Packet size is around 1492 bytes.
> > >
> > > Seems that you are using SKB mode then, not zero-copy.
> > >
> > > /Magnus
> > >
> >
> > Thank you for the hint. As you correctly said, I get an error if I use =
*XDP_ZEROCOPY*. But as far as I understand, packet rates should be higher i=
n Driver-Mode even without zero-copy?
>=20
> Yes, I would expect that too.
>=20
> > I just updated to the latest driver- and firmware version:
> >
> >=A0=A0=A0=A0=A0=A0=A0=A0 $ sudo ethtool -i <if>
> >=A0=A0=A0=A0=A0=A0=A0=A0 driver: mlx5_core
> >=A0=A0=A0=A0=A0=A0=A0=A0 version: 5.0-0
> >=A0=A0=A0=A0=A0=A0=A0=A0 firmware-version: 16.27.1016 (MT_0000000012)
>=20
> What kernel version are you using? And you should use the driver from
> that same kernel.
>=20

I am using

        $ uname -a
        Linux 5.4.0-4-amd64 #1 SMP Debian 5.4.19-1 (2020-02-13) x86_64 GNU/=
Linux

At the moment, Mellanox only supports Debian until version 10.0 (https://ww=
w.mellanox.com/products/infiniband-drivers/linux/mlnx_ofed) which is Kernel=
 4.19.
But because in Kernel 4.19, not all AF-XDP features are available, I had to=
 upgrade. I was not sure which Kernel-Version would be the minimum in order=
 to be able to use AF-XDP completely so I went with 5.4.
Installation was successfull  (with *--skip-distro-check*) so I thought thi=
s should work?

> > I actually have to correct myself: Incomming packets are 1442 bytes.
> > Can you give me the link between packet size and whether the NIC is run=
ning in SKB or DRV mode?
>=20
> Sorry, do not understand this. Could you please elaborate?
>=20

You answered to my reply that packets are 1492 bytes "Seems that you are us=
ing SKB mode then, not zero-copy." so because of this I thought there is a =
relation between packet size and SKB mode?

> > Mr. Brouer held a talk about (https://people.netfilter.org/hawk/present=
ations/driving-IT2017/driving-IT-2017_XDP_eBPF_technology_Jesper_Brouer.pdf=
)  about XDP, mentioning in slide 11/27 that *mlx5 (v4.9)* has native XDP s=
upport.
>=20
> Yes, but only if you use queue id>=3D 32. What queue id are you binding t=
o?
>=20

Usually it is queue 0 but I also tried queue 32 and queue 36 - but that did=
n't change anything on the behavior.

> /Magnus
>=20
> >
> > > > Just to make sure: Those 650k packets are arriving on the same RX-Q=
ueue (even though this NIC has multiple RX-Queues I want to test maximum ba=
ndwith for a single RX-Queue).
> > > >
> > > > > > I didn't observe a dramatic change as I've hoped to. Are there =
some other ways to reduce interrupt load (user-space application and ksofti=
rq are already running on different CPUs)?
> > > > >
> > > > > The need_wakeup flag has a big impact when you run the softirq an=
d the
> > > > > application thread on the same core. When using two cores for thi=
s, it
> > > > > has less of an impact.
> > > > >
> > > > > /Magnus
> > > > >
> > > > > > NIC: Mellanox Technologies MT27800
> > > > > >
> > > > > > Best regards
> > > > > >
> > > > > > Max
> > > > > >
> > > >
> >
