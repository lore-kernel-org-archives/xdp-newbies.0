Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua1-f44.google.com ([209.85.222.44]:42607 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCYLEX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 25 Mar 2020 07:04:23 -0400
Received: by mail-ua1-f44.google.com with SMTP id m18so555382uap.9
        for <xdp-newbies@vger.kernel.org>; Wed, 25 Mar 2020 04:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <018e8071725b48399141cc46b63641e1@hm.edu> <CAJ8uoz1Vh+zj6msumTNWgtZY6jdOeYgoyDBoizfna1dzhC465A@mail.gmail.com>
 <9616cd5986c74058b51ffd1eb3311b85@hm.edu> <CAJ8uoz1-Nub4RKembg5maQ4Cj1J+O90eR_PcP41yNHuq7pShaQ@mail.gmail.com>
 <35eed7a7481a44bc93e8e5f7e59d9e5a@hm.edu>
In-Reply-To: <35eed7a7481a44bc93e8e5f7e59d9e5a@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Wed, 25 Mar 2020 12:04:11 +0100
Message-ID: <CAJ8uoz3D=nw_aD0+Kj9Mh_DivRBvse0+G0Mtfw+eR8UJdDT0jw@mail.gmail.com>
Subject: Re: Shared Umem and reducing ksoftirqd-Load
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Wed, Mar 25, 2020 at 11:45 AM Gaul, Maximilian
<maximilian.gaul@hm.edu> wrote:
>
> On Wed, Mar 25, 2020 at 11:24 AM Karlsson, Magnus
> <magnus.karlsson@gmail.com> wrote:
>
> > On Wed, Mar 25, 2020 at 11:02 AM Gaul, Maximilian
> > <maximilian.gaul@hm.edu> wrote:
> > >
> > > On Wed, Mar 25, 2020 at 10:41 AM Karlsson, Magnus
> > > <magnus.karlsson@gmail.com> wrote:
> > >
> > > > On Wed, Mar 25, 2020 at 10:04 AM Gaul, Maximilian
> > > > <maximilian.gaul@hm.edu> wrote:
> > > > >
> > > > > I am running a Multi-AF-XDP-Socket approach per RX-Queue (using Shared Umem).
> > > > >
> > > > > Unfortunately I am noticing, that at around 650k pps, the *ksoftirqd*-thread of that RX-Queue ramps up to 100% thus leading to packet loss.
> > > > > I tried setting *XDP_USE_NEED_WAKEUP* on *xsk_socket_cfg.bind_flags* but those bind_flags are only taken into account if *umem->refcount > 1* (libbpf/xsk.c - xsk_socket__create()).
> > > > > As far as I understand this correctly, only the first socket is able to set *XDP_USE_NEED_WAKEUP* because for all sockets after, *umem->refcount* is going to be at least 2.
> > > >
> > > > Yes, the other sockets just inherit the settings of the first one.
> > > >
> > > > Are you using the SKB mode? What is your packet size? Sounds like a
> > > > low number unless you have large packets and are using the SKB mode.
> > > >
> > >
> > > These are the flags I set right before calling `xsk_socket__create`:
> > >
> > >         xsk_socket_cfg.xdp_flags = cfg->xdp_flags | XDP_FLAGS_DRV_MODE | XDP_ZEROCOPY;
> > >         xsk_socket_cfg.bind_flags = cfg->xsk_bind_flags | XDP_USE_NEED_WAKEUP;
> >
> > XDP_ZEROCOPY is a bind flag not an XDP flag, so please move it there.
> > If you get an error when you have it set, it means that your setup
> > does not support zero-copy for some reason. Check what kernel version
> > you are using and the the driver you are using supports zero-copy. I
> > believe you need to use a queue id>=32 in the Mellanox driver for it
> > to work in zero-copy mode. Below 32, you will get copy mode.
> >
> > > Packet size is around 1492 bytes.
> >
> > Seems that you are using SKB mode then, not zero-copy.
> >
> > /Magnus
> >
>
> Thank you for the hint. As you correctly said, I get an error if I use *XDP_ZEROCOPY*. But as far as I understand, packet rates should be higher in Driver-Mode even without zero-copy?

Yes, I would expect that too.

> I just updated to the latest driver- and firmware version:
>
>         $ sudo ethtool -i <if>
>         driver: mlx5_core
>         version: 5.0-0
>         firmware-version: 16.27.1016 (MT_0000000012)

What kernel version are you using? And you should use the driver from
that same kernel.

> I actually have to correct myself: Incomming packets are 1442 bytes.
> Can you give me the link between packet size and whether the NIC is running in SKB or DRV mode?

Sorry, do not understand this. Could you please elaborate?

> Mr. Brouer held a talk about (https://people.netfilter.org/hawk/presentations/driving-IT2017/driving-IT-2017_XDP_eBPF_technology_Jesper_Brouer.pdf) about XDP, mentioning in slide 11/27 that *mlx5 (v4.9)* has native XDP support.

Yes, but only if you use queue id>= 32. What queue id are you binding to?

/Magnus

>
> > > Just to make sure: Those 650k packets are arriving on the same RX-Queue (even though this NIC has multiple RX-Queues I want to test maximum bandwith for a single RX-Queue).
> > >
> > > > > I didn't observe a dramatic change as I've hoped to. Are there some other ways to reduce interrupt load (user-space application and ksoftirq are already running on different CPUs)?
> > > >
> > > > The need_wakeup flag has a big impact when you run the softirq and the
> > > > application thread on the same core. When using two cores for this, it
> > > > has less of an impact.
> > > >
> > > > /Magnus
> > > >
> > > > > NIC: Mellanox Technologies MT27800
> > > > >
> > > > > Best regards
> > > > >
> > > > > Max
> > > > >
> > >
>
