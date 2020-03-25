Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vs1-f53.google.com ([209.85.217.53]:44259 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCYJlW (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 25 Mar 2020 05:41:22 -0400
Received: by mail-vs1-f53.google.com with SMTP id e138so1052527vsc.11
        for <xdp-newbies@vger.kernel.org>; Wed, 25 Mar 2020 02:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <018e8071725b48399141cc46b63641e1@hm.edu>
In-Reply-To: <018e8071725b48399141cc46b63641e1@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Wed, 25 Mar 2020 10:41:10 +0100
Message-ID: <CAJ8uoz1Vh+zj6msumTNWgtZY6jdOeYgoyDBoizfna1dzhC465A@mail.gmail.com>
Subject: Re: Shared Umem and reducing ksoftirqd-Load
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Wed, Mar 25, 2020 at 10:04 AM Gaul, Maximilian
<maximilian.gaul@hm.edu> wrote:
>
> I am running a Multi-AF-XDP-Socket approach per RX-Queue (using Shared Umem).
>
> Unfortunately I am noticing, that at around 650k pps, the *ksoftirqd*-thread of that RX-Queue ramps up to 100% thus leading to packet loss.
> I tried setting *XDP_USE_NEED_WAKEUP* on *xsk_socket_cfg.bind_flags* but those bind_flags are only taken into account if *umem->refcount > 1* (libbpf/xsk.c - xsk_socket__create()).
> As far as I understand this correctly, only the first socket is able to set *XDP_USE_NEED_WAKEUP* because for all sockets after, *umem->refcount* is going to be at least 2.

Yes, the other sockets just inherit the settings of the first one.

Are you using the SKB mode? What is your packet size? Sounds like a
low number unless you have large packets and are using the SKB mode.

> I didn't observe a dramatic change as I've hoped to. Are there some other ways to reduce interrupt load (user-space application and ksoftirq are already running on different CPUs)?

The need_wakeup flag has a big impact when you run the softirq and the
application thread on the same core. When using two cores for this, it
has less of an impact.

/Magnus

> NIC: Mellanox Technologies MT27800
>
> Best regards
>
> Max
>
