Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:51273 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgDKH56 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 11 Apr 2020 03:57:58 -0400
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 48znLC3sfMzySd
        for <xdp-newbies@vger.kernel.org>; Sat, 11 Apr 2020 09:57:55 +0200 (CEST)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id 6MS9rTzoOQRT for <xdp-newbies@vger.kernel.org>;
        Sat, 11 Apr 2020 09:57:55 +0200 (CEST)
Received: from BADWLRZ-SWMBB04.ads.mwn.de (BADWLRZ-SWMBB04.ads.mwn.de [IPv6:2001:4ca0:0:108::155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBB04", Issuer "BADWLRZ-SWMBB04" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 48znLC22ZnzySY
        for <xdp-newbies@vger.kernel.org>; Sat, 11 Apr 2020 09:57:55 +0200 (CEST)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: virtio and XDP: How to do flow steering + shared umem
Date: Sat, 11 Apr 2020 07:57:54 +0000
Message-ID: <d661a87f825d4740b63b2dc5c4b0ca9f@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

I set up a kvm with virt-manager using Debian buster upgraded to Kernel 5.4=
 to test my AF-XDP program. I am using the NIC which I usually use on my ho=
st-server with macvtap driver set to virtio and passthrough inside the gues=
t system.

The first time I started my program inside the VM I noticed this error mess=
age:

=09virtio_net virtio0 eth1: request 2 queues but max is 1.

After searching Google I found the solution. Changing my interface config t=
o this (always with just 1 virtual CPU):

   <interface type=3D'direct' trustGuestRxFilters=3D'yes'>
      <mac address=3D'52:54:00:b7:7d:c2'/>
      <source dev=3D'eth20' mode=3D'passthrough'/>
      <model type=3D'virtio'/>
      <driver name=3D'vhost' queues=3D'2'/>
      <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x03' fu=
nction=3D'0x0'/>
    </interface>

To observe what's happening on which RX-Queue I setup up a BPF_MAP_TYPE_ARR=
AY in my XDP-program which contains the amount of packets arrived on each R=
X-Queue (observed with `bpftool map dump id xx`):

=09const int rx_queue_idx =3D ctx->rx_queue_index;
=09unsigned long *idx_counter =3D bpf_map_lookup_elem(&rx_queue_pckt_counte=
r_map, &rx_queue_idx);
=09if(idx_counter !=3D NULL) {
=09=09  *idx_counter +=3D 1;
=09}

Because I found no way how to do Receive Side Steering with macvtap (KVM/QE=
MU virtio (macvtap): Is RSS possible?) I am only testing a single RX-Queue =
with multiple AF-XDP sockets (they are sharing the same umem). Each socket =
is responsible to process packets from a single multicast-source.

Now what I am observing is that some packets are received on another queue =
even though I set

=09sudo ethtool -L eth1 combined 1

In case I am trying to process one multicast-source (this means `setsockopt=
(fd, IP_ADD_MULTICAST)`), the bpf-map looks like this:

=09$ sudo bpftool map dump id 57
=09key: 00 00 00 00  value: 00 00 00 00 00 00 00 00
=09key: 01 00 00 00  value: 29 dd 2d 00 00 00 00 00

It's a bit odd that virtio doesn't start with the first RX-Queue but okay, =
I can adapt my program. Packet loss is around 0.2% total at around 270kpps.

In case I use two multicast streams (again with IP_ADD_MULTICAST), this is =
the bpf-map:

=09$ sudo bpftool map dump id 61
=09key: 00 00 00 00  value: 00 00 00 00 00 00 00 00
=09key: 01 00 00 00  value: 76 a4 4b 00 00 00 00 00

Packet loss is now at around 16% at 455kpps which is nowhere near the origi=
nal performance (is this normal??).

In case I add another multicast stream (3 total), this is the bpf-map:

=09$ sudo bpftool map dump id 65
=09key: 00 00 00 00  value: 2f 6a 0e 00 00 00 00 00
=09key: 01 00 00 00  value: 77 d9 20 00 00 00 00 00

As you can see, there are packets on RX-Queue 0 and RX-Queue 1. Why is that=
 and how can I prevent that from happening?

I don't understand why ethtool shows me this:=20

=09$ sudo ethtool -S eth1
=09NIC statistics:
=09=09 rx_queue_0_packets: 80341229
=09=09 rx_queue_0_bytes: 119871244125
=09=09 rx_queue_0_drops: 79419999
=09=09 rx_queue_0_xdp_packets: 80332151
=09=09 rx_queue_0_xdp_tx: 0
=09=09 rx_queue_0_xdp_redirects: 79922548
=09=09 rx_queue_0_xdp_drops: 79419999
=09=09 rx_queue_0_kicks: 1586
=09=09 tx_queue_0_packets: 165
=09=09 tx_queue_0_bytes: 13552
=09=09 tx_queue_0_xdp_tx: 0
=09=09 tx_queue_0_xdp_tx_drops: 0
=09=09 tx_queue_0_kicks: 165

even though I have evidence that there are multiple RX-queues where packets=
 are received on?

To summarize my problem:

- Somehow I have more than one RX-Queue even though I set `ethtool -L eth1 =
combined 1`.
- Furthermore, I am fine with multiple RX-Queues but not if I am not able t=
o decide where packets arrive via `ethtool -N eth1 flow-type udp4 ...`.
