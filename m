Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:35539 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgCTRyV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 20 Mar 2020 13:54:21 -0400
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 48kWcT6vSSzycD
        for <xdp-newbies@vger.kernel.org>; Fri, 20 Mar 2020 18:54:17 +0100 (CET)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id TJwXKI1kCe0Q for <xdp-newbies@vger.kernel.org>;
        Fri, 20 Mar 2020 18:54:17 +0100 (CET)
Received: from BADWLRZ-SWMBX03.ads.mwn.de (BADWLRZ-SWMBX03.ads.mwn.de [IPv6:2001:4ca0:0:108::159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX03", Issuer "BADWLRZ-SWMBX03" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 48kWcT2zRtzycC
        for <xdp-newbies@vger.kernel.org>; Fri, 20 Mar 2020 18:54:17 +0100 (CET)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Is there a problem with UDP-packets of size 371 bytes and less?
Date: Fri, 20 Mar 2020 17:54:17 +0000
Message-ID: <f9c9f8d39ddf4f6ba915b3e6e087c63c@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

This question is related to: https://marc.info/?l=3Dxdp-newbies&m=3D1584627=
35008364&w=3D2

Is there a known (or maybe unknown) bug regarding the size of packets in th=
e AF-XDP socket framework (+ libbpf)?

I am experiencing a strange packet loss for my application:

IPv4/UDP/RTP packet stream with all packets being the same size (1442 bytes=
): no packet loss
IPv4/UDP/RTP packet stream where pretty much all packets are the same size =
(1492 bytes) except a special "marker" packet (only 357 bytes but they are =
also IPv4/UDP-packets): all marker packets get lost
I added a bpf_printk statement in my XDP-Kernelprogram for further validati=
on:

const int len =3D bpf_ntohs(iph->tot_len);
if(len < 400) {
    bpf_printk("FOUND PACKET LEN < 400: %d.\n", len);
}

This output is never observed via *cat /sys/kernel/debug/tracing/trace_pipe=
*. So these small RTP-marker packets aren't even received by my kernel filt=
er - no wonder why I don't receive them in userspace.

ethtool -S <if> shows me this number: rx_256_to_511_bytes_phy. This number =
is increasing in a similar rate as marker-packets should come in (about 30/=
s). So this means that my NIC does receive the packets (and so does a gener=
ic Linux socket), but my XDP-program doesn't - why?

I made further testing with *nping* which is able to generate packets with =
arbitrary sizes:

nping --udp -p <port> --dest-ip <ip> --data-length 372 -c 50000000 --rate 2=
50 -N

Packets of size *372 bytes* are received but anything less is not received =
(ordinary linux socket does receive those packets as I said though).

The only idea that came to my mind was UMEM chunk size alignment related (o=
ption *XDP_UMEM_UNALIGNED_CHUNK_FLAG* with *MAP_HUGETLB*) - but this didn't=
 change anything (I also don't know if changing UMEM-settings changes anyth=
ing on the XDP-Kernelside).

Any idea what could be the cause of this problem?
