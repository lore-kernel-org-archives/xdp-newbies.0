Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout2.mail.lrz.de ([129.187.255.138]:46041 "EHLO
        postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgCZMav (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 26 Mar 2020 08:30:51 -0400
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Shared Umem and reducing ksoftirqd-Load
Date: Thu, 26 Mar 2020 12:30:46 +0000
Message-ID: <b4e8bdfd96d8484d904b6b91ece81324@hm.edu>
References: <018e8071725b48399141cc46b63641e1@hm.edu>
 <CAJ8uoz1Vh+zj6msumTNWgtZY6jdOeYgoyDBoizfna1dzhC465A@mail.gmail.com>
 <9616cd5986c74058b51ffd1eb3311b85@hm.edu>
 <CAJ8uoz1-Nub4RKembg5maQ4Cj1J+O90eR_PcP41yNHuq7pShaQ@mail.gmail.com>
 <35eed7a7481a44bc93e8e5f7e59d9e5a@hm.edu>
 <CAJ8uoz3D=nw_aD0+Kj9Mh_DivRBvse0+G0Mtfw+eR8UJdDT0jw@mail.gmail.com>
 <883111619d9e429fb5f1fb239afdb478@hm.edu>,<CAJ8uoz2OZOrERz3D+L9fe-WhYAHOZOd_ZOzYjUTKwyZ1ic7AaA@mail.gmail.com>
In-Reply-To: <CAJ8uoz2OZOrERz3D+L9fe-WhYAHOZOd_ZOzYjUTKwyZ1ic7AaA@mail.gmail.com>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Wed, Mar 25, 2020 at 14:36 AM Karlsson, Magnus
magnus.karlsson@gmail.com> wrote:

> On Wed, Mar 25, 2020 at 1:40 PM Gaul, Maximilian <maximilian.gaul@hm.edu>=
 wrote:
> >
> > On Wed, Mar 25, 2020 at 12:04 AM Karlsson, Magnus
> > magnus.karlsson@gmail.com> wrote:
> >
> > > On Wed, Mar 25, 2020 at 11:45 AM Gaul, Maximilian
> > > <maximilian.gaul@hm.edu> wrote:
> > > >
> > > > On Wed, Mar 25, 2020 at 11:24 AM Karlsson, Magnus
> > > > <magnus.karlsson@gmail.com> wrote:
> > > >
> > > > > On Wed, Mar 25, 2020 at 11:02 AM Gaul, Maximilian
> > > > > <maximilian.gaul@hm.edu> wrote:
> > > > > >
> > > > > > On Wed, Mar 25, 2020 at 10:41 AM Karlsson, Magnus
> > > > > > <magnus.karlsson@gmail.com> wrote:
> > > > > >
> > > > > > > On Wed, Mar 25, 2020 at 10:04 AM Gaul, Maximilian
> > > > > > > <maximilian.gaul@hm.edu> wrote:
> > > > > > > >
> > > > > > > > I am running a Multi-AF-XDP-Socket approach per RX-Queue (u=
sing Shared Umem).
> > > > > > > >
> > > > > > > > Unfortunately I am noticing, that at around 650k pps, the *=
ksoftirqd*-thread of that RX-Queue ramps up to 100% thus leading to packet =
loss.
> > > > > > > > I tried setting *XDP_USE_NEED_WAKEUP* on *xsk_socket_cfg.bi=
nd_flags* but those bind_flags are only taken into account if *umem->refcou=
nt > 1* (libbpf/xsk.c - xsk_socket__create()).
> > > > > > > > As far as I understand this correctly, only the first socke=
t is able to set *XDP_USE_NEED_WAKEUP* because for all sockets after, *umem=
->refcount* is going to be at least 2.
> > > > > > >
> > > > > > > Yes, the other sockets just inherit the settings of the first=
 one.
> > > > > > >
> > > > > > > Are you using the SKB mode? What is your packet size? Sounds =
like a
> > > > > > > low number unless you have large packets and are using the SK=
B mode.
> > > > > > >
> > > > > >
> > > > > > These are the flags I set right before calling `xsk_socket__cre=
ate`:
> > > > > >
> > > > > >=A0=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.xdp_flags =3D cfg->xdp_f=
lags | XDP_FLAGS_DRV_MODE | XDP_ZEROCOPY;
> > > > > >=A0=A0=A0=A0=A0=A0=A0=A0 xsk_socket_cfg.bind_flags =3D cfg->xsk_=
bind_flags | XDP_USE_NEED_WAKEUP;
> > > > >
> > > > > XDP_ZEROCOPY is a bind flag not an XDP flag, so please move it th=
ere.
> > > > > If you get an error when you have it set, it means that your setu=
p
> > > > > does not support zero-copy for some reason. Check what kernel ver=
sion
> > > > > you are using and the the driver you are using supports zero-copy=
. I
> > > > > believe you need to use a queue id>=3D32 in the Mellanox driver f=
or it
> > > > > to work in zero-copy mode. Below 32, you will get copy mode.
> > > > >
> > > > > > Packet size is around 1492 bytes.
> > > > >
> > > > > Seems that you are using SKB mode then, not zero-copy.
> > > > >
> > > > > /Magnus
> > > > >
> > > >
> > > > Thank you for the hint. As you correctly said, I get an error if I =
use *XDP_ZEROCOPY*. But as far as I understand, packet rates should be high=
er in Driver-Mode even without zero-copy?
> > >
> > > Yes, I would expect that too.
> > >
> > > > I just updated to the latest driver- and firmware version:
> > > >
> > > >=A0=A0=A0=A0=A0=A0=A0=A0 $ sudo ethtool -i <if>
> > > >=A0=A0=A0=A0=A0=A0=A0=A0 driver: mlx5_core
> > > >=A0=A0=A0=A0=A0=A0=A0=A0 version: 5.0-0
> > > >=A0=A0=A0=A0=A0=A0=A0=A0 firmware-version: 16.27.1016 (MT_0000000012=
)
> > >
> > > What kernel version are you using? And you should use the driver from
> > > that same kernel.
> > >
> >
> > I am using
> >
> >=A0=A0=A0=A0=A0=A0=A0=A0 $ uname -a
> >=A0=A0=A0=A0=A0=A0=A0=A0 Linux 5.4.0-4-amd64 #1 SMP Debian 5.4.19-1 (202=
0-02-13) x86_64 GNU/Linux
> >
> > At the moment, Mellanox only supports Debian until version 10.0 (https:=
//www.mellanox.com/products/infiniband-drivers/linux/mlnx_ofed) which is Ke=
rnel 4.19.
> > But because in Kernel 4.19, not all AF-XDP features are available, I ha=
d to upgrade. I was not sure which Kernel-Version would be the minimum in o=
rder to be able to use AF-XDP completely so I went with 5.4.
> > Installation was successfull=A0 (with *--skip-distro-check*) so I thoug=
ht this should work?
>=20
> You better contact somebody from Mellanox for this info. I do not
> know. But Mellanox has zero-copy support in kernel 5.4.
>=20
> > > > I actually have to correct myself: Incomming packets are 1442 bytes=
.
> > > > Can you give me the link between packet size and whether the NIC is=
 running in SKB or DRV mode?
> > >
> > > Sorry, do not understand this. Could you please elaborate?
> > >
> >
> > You answered to my reply that packets are 1492 bytes "Seems that you ar=
e using SKB mode then, not zero-copy." so because of this I thought there i=
s a relation between packet size and SKB mode?
>=20
> There is no relationship between SKB mode and packet size. They are
> orthogonal. Though there is a relationship between packet size and
> performance and of course SKB mode vs zero-copy mode and performance.
>=20
> > > > Mr. Brouer held a talk about (https://people.netfilter.org/hawk/pre=
sentations/driving-IT2017/driving-IT-2017_XDP_eBPF_technology_Jesper_Brouer=
.pdf)=A0  about XDP, mentioning in slide 11/27 that *mlx5 (v4.9)* has nativ=
e XDP support.
> > >
> > > Yes, but only if you use queue id>=3D 32. What queue id are you bindi=
ng to?
> > >
> >
> > Usually it is queue 0 but I also tried queue 32 and queue 36 - but that=
 didn't change anything on the behavior.
>=20
> It should make a difference, if I remember correctly, but somebody
> from Mellanox certainly knows better. Try sending a mail to Maxim who
> wrote the Mellanox driver support. Maxim Mikityanskiy
> <maximmi@mellanox.com>.
>=20
> /Magnus
>=20

Thank you!
Just one more question regarding *ksoftirqd*-load. This paper seems to talk=
 about the mentioned issue: http://vger.kernel.org/lpc_net2018_talks/lpc18_=
paper_af_xdp_perf-v2.pdf that *ksoftirqd* is producing high load. A stated =
solution to this problem would be *busy polling*. I am not sure if *busy po=
lling* is something I have to assign via *setsockopt* in my userspace progr=
am or if this already taken care of by libbpf?
Nevertheless, I tried it like this:

=09=09$ cat /boot/config-5.4.0-4-amd64 | grep "CONFIG_NET_RX_BUSY_POLL"
=09=09CONFIG_NET_RX_BUSY_POLL=3Dy

=09=09$ sysctl net.core.busy_poll=3D50
=09=09
and in my user-space program:

=09=09int busy_poll_usec =3D 50;
=09=09if(setsockopt(xsk_socket__fd(xsk_sockets[i]->xsk), SOL_SOCKET, SO_BUS=
Y_POLL, (char *)&busy_poll_usec, sizeof(busy_poll_usec)) < 0) {
=09=09=09fprintf(stderr, "Failed to set `SO_BUSY_POLL`: %s\n", strerror(err=
no));
=09=09=09break;
=09=09}
=09=09
=09=09/* some code inbetween */

=09=09while(!global_exit) {
=09=09=09const int ret =3D poll(fds, fd_count, 2);
=09=09=09if (ret <=3D 0) {
=09=09=09=09continue;
=09=09=09}

=09=09=09for(int i =3D 0; i < fd_count; i++) {
=09=09=09=09struct xsk_socket_info *socket =3D xsk_sockets[i];
=09=09=09=09if(atomic_exchange(&socket->stats_sync.lock, 1) =3D=3D 0) {
=09=09=09=09=09handle_receive_packets(socket);
=09=09=09=09=09atomic_fetch_xor(&socket->stats_sync.lock, 1); /* release so=
cket-lock */
=09=09=09=09}
=09=09=09}
=09=09}

but this only has the effect that my userspace program is now at 50% load (=
previously around 13%) with *ksoftirqd* still running at 100% (and even wor=
se pps).
Is this the expected effect on what I did?

> > > /Magnus
> > >
> > > >
> > > > > > Just to make sure: Those 650k packets are arriving on the same =
RX-Queue (even though this NIC has multiple RX-Queues I want to test maximu=
m bandwith for a single RX-Queue).
> > > > > >
> > > > > > > > I didn't observe a dramatic change as I've hoped to. Are th=
ere some other ways to reduce interrupt load (user-space application and ks=
oftirq are already running on different CPUs)?
> > > > > > >
> > > > > > > The need_wakeup flag has a big impact when you run the softir=
q and the
> > > > > > > application thread on the same core. When using two cores for=
 this, it
> > > > > > > has less of an impact.
> > > > > > >
> > > > > > > /Magnus
> > > > > > >
> > > > > > > > NIC: Mellanox Technologies MT27800
> > > > > > > >
> > > > > > > > Best regards
> > > > > > > >
> > > > > > > > Max
> > > > > > > >
> > > > > >
> > > >
