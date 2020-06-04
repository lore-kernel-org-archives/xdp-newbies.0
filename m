Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:36635 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728476AbgFDTZ2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jun 2020 15:25:28 -0400
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 49dG2X60G4zyYQ
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 21:25:24 +0200 (CEST)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id C8i1G4yPd6NL for <xdp-newbies@vger.kernel.org>;
        Thu,  4 Jun 2020 21:25:24 +0200 (CEST)
Received: from BADWLRZ-SWMBX05.ads.mwn.de (BADWLRZ-SWMBX05.ads.mwn.de [IPv6:2001:4ca0:0:108::161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX05", Issuer "BADWLRZ-SWMBX05" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 49dG2X4JBhzyYL
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 21:25:24 +0200 (CEST)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Intel 10G 2P X520 Adapter doesn't receive anything with AF XDP
Date: Thu, 4 Jun 2020 19:25:23 +0000
Message-ID: <7ec53b8f30524ffba36bb264c6d023fc@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

Sorry to ask another question but I don't get this working.

I have this AF_XDP test program which creates an ordinary SOCK_RAW socket a=
nd adds a multicast address to it via IP_ADD_MEMBERSHIP.
Then it loads a BPF program and launches an AF_XDP socket which then proces=
ses packets of that multicast.

This works fine on my Mellanox ConnectX5 card, but it doesn't work on my In=
tel 10G 2P X520 (Kernel 5.6.0 and driver ixgbe 5.1.0-k).
I have an array map in the BPF program which counts the amount of packets r=
eceived on each RX-Queue:

=09=09SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx) {

=09=09=09const void *data =3D (void*)(unsigned long)ctx->data;
=09=09=09const void *data_end =3D (void*)(unsigned long)ctx->data_end;
=09=09=09const int rx_queue_idx =3D ctx->rx_queue_index;

=09=09=09const struct ethhdr *eth =3D (struct ethhdr*)(data);

=09=09=09unsigned long *idx_counter =3D bpf_map_lookup_elem(&rx_queue_pckt_=
counter_map, &rx_queue_idx);
=09=09=09if(idx_counter !=3D NULL) {
=09=09=09=09*idx_counter +=3D 1;
=09=09=09}

I can then look at this map via bpftool. What I found is that almost no pac=
kets are received: only like 4 packets on RX-Queues 1, 2, 3, 4 which I assu=
me are random pings in the network or something but nothing significant (th=
e multicast stream would have a packet rate of 270k pps).

The strange thing now is that everything works fine if I just use that gene=
ric Linux socket to receive the packets (without any XDP / AF_XDP / BPF inv=
olved).

Any ideas why that is?

Best regards

Max
