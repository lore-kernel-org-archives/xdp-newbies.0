Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:42037 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgCYJEI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 25 Mar 2020 05:04:08 -0400
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 48nMcN674qzyZ1
        for <xdp-newbies@vger.kernel.org>; Wed, 25 Mar 2020 10:04:04 +0100 (CET)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id Ae1yW5wecpgw for <xdp-newbies@vger.kernel.org>;
        Wed, 25 Mar 2020 10:04:04 +0100 (CET)
Received: from BADWLRZ-SWMBX03.ads.mwn.de (BADWLRZ-SWMBX03.ads.mwn.de [IPv6:2001:4ca0:0:108::159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX03", Issuer "BADWLRZ-SWMBX03" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 48nMcN4mvMzyZ0
        for <xdp-newbies@vger.kernel.org>; Wed, 25 Mar 2020 10:04:04 +0100 (CET)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Shared Umem and reducing ksoftirqd-Load
Date: Wed, 25 Mar 2020 09:04:04 +0000
Message-ID: <018e8071725b48399141cc46b63641e1@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

I am running a Multi-AF-XDP-Socket approach per RX-Queue (using Shared Umem=
).

Unfortunately I am noticing, that at around 650k pps, the *ksoftirqd*-threa=
d of that RX-Queue ramps up to 100% thus leading to packet loss.
I tried setting *XDP_USE_NEED_WAKEUP* on *xsk_socket_cfg.bind_flags* but th=
ose bind_flags are only taken into account if *umem->refcount > 1* (libbpf/=
xsk.c - xsk_socket__create()).
As far as I understand this correctly, only the first socket is able to set=
 *XDP_USE_NEED_WAKEUP* because for all sockets after, *umem->refcount* is g=
oing to be at least 2.

I didn't observe a dramatic change as I've hoped to. Are there some other w=
ays to reduce interrupt load (user-space application and ksoftirq are alrea=
dy running on different CPUs)?

NIC: Mellanox Technologies MT27800

Best regards

Max
