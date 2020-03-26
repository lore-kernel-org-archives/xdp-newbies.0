Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout2.mail.lrz.de ([129.187.255.138]:39891 "EHLO
        postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgCZNfu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 26 Mar 2020 09:35:50 -0400
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 48p5bR4BWpzymG
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Mar 2020 14:35:47 +0100 (CET)
Received: from postout2.mail.lrz.de ([127.0.0.1])
        by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id 6cCxscgbxzIg for <xdp-newbies@vger.kernel.org>;
        Thu, 26 Mar 2020 14:35:47 +0100 (CET)
Received: from BADWLRZ-SWMBX03.ads.mwn.de (BADWLRZ-SWMBX03.ads.mwn.de [IPv6:2001:4ca0:0:108::159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX03", Issuer "BADWLRZ-SWMBX03" (not verified))
        by postout2.mail.lrz.de (Postfix) with ESMTPS id 48p5bR2V6Vzyft
        for <xdp-newbies@vger.kernel.org>; Thu, 26 Mar 2020 14:35:47 +0100 (CET)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Is there a way to process multiple shared umem sockets on same
 RX-queue in parallel?
Date: Thu, 26 Mar 2020 13:35:47 +0000
Message-ID: <c442671a3c7145a7b76b1f871e2b01cf@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

*xdpsock_user.c* (https://github.com/torvalds/linux/blob/master/samples/bpf=
/xdpsock_user.c) implements multiple AF-XDP sockets on the same RX-Queue us=
ing shared Umem.
The sockets are then processed in a for-loop like this (1:1 copy):

=09=09struct pollfd fds[MAX_SOCKS] =3D {};
=09=09int i, ret;

=09=09for (i =3D 0; i < num_socks; i++) {
=09=09=09fds[i].fd =3D xsk_socket__fd(xsks[i]->xsk);
=09=09=09fds[i].events =3D POLLIN;
=09=09}

=09=09for (;;) {
=09=09=09if (opt_poll) {
=09=09=09=09ret =3D poll(fds, num_socks, opt_timeout);
=09=09=09=09if (ret <=3D 0)
=09=09=09=09=09continue;
=09=09=09}

=09=09=09for (i =3D 0; i < num_socks; i++)
=09=09=09=09rx_drop(xsks[i], fds);

=09=09=09if (benchmark_done)
=09=09=09=09break;
=09=09}

This approach works fine in my implementation as well but I was wondering i=
f it is possible to spawn a thread for every socket and let those threads p=
rocess receiving packets in a parallel fashion.
After processing is done (right before they go to sleep to wait for the nex=
t batch of packets), those threads are adding an entry to a message queue, =
instructing another thread (which is processing the queue) to free Umem-Fil=
l-Queue and RX-Ring memory of that socket.
I know that Umem is only single producer / single consumer so I went into t=
he implementation with the mindset that it probably wouldn't work out - and=
 it didn't. But now I am wondering whether this is not possible by design (=
this means that indeed every socket of a RX-Queue using shared umem has to =
be processed sequentially) or if I did something wrong.
So this is how a thread processes incoming packets:

=09=09uint32_t idx_rx =3D 0;
=09=09const int rcvd =3D xsk_ring_cons__peek(&xsk_socket->rx, INT32_MAX, &i=
dx_rx);
=09=09if (rcvd =3D=3D 0) {
=09=09=09continue;
=09=09}

=09=09uint32_t idx_fq =3D 0;
=09=09const int ret =3D xsk_ring_prod__reserve(&xsk_socket->umem->fq, rcvd,=
 &idx_fq);
                /* continue checking if ret !=3D rcvd ... */
=09=09if(ret =3D=3D rcvd) {
=09=09=09for (uint32_t i =3D idx_rx; i < (idx_rx + rcvd); i++) {
=09=09=09=09const struct xdp_desc *desc =3D xsk_ring_cons__rx_desc(&xsk_soc=
ket->rx, i);
=09=09=09=09uint64_t addr =3D desc->addr;
=09=09=09=09const uint32_t len =3D desc->len;
=09=09=09=09const uint64_t orig =3D xsk_umem__extract_addr(addr);

=09=09=09=09addr =3D xsk_umem__add_offset_to_addr(addr);

=09=09=09=09const int hdr_size =3D process_packet(xsk_socket, addr, len);
=09=09=09=09*xsk_ring_prod__fill_addr(&xsk_socket->umem->fq, idx_fq++) =3D =
orig;
=09=09=09=09
=09=09=09=09xsk_socket->stats.rx_bytes +=3D (len - hdr_size);
=09=09=09}

=09=09=09xsk_socket->stats.rx_packets +=3D rcvd;

=09=09=09struct xsk_thread_msg msg;
=09=09=09msg.xsk_rx =3D &xsk_socket->rx;
=09=09=09msg.xsk_rx_rcvd =3D rcvd;
=09=09=09msg.xsk_prod_reserve_amnt =3D ret;
=09=09=09if(msgsnd(msg_queue_id, (void*)(&msg), sizeof(struct xsk_thread_ms=
g), 0) < 0) {
=09=09=09=09fprintf(stderr, "Failed to add msg from xsk-socket: %s\n", stre=
rror(errno));
=09=09=09}
=09=09
=09=09}

and those messages are then received by another thread:

=09=09struct xsk_thread_msg msg;
=09=09while(!global_exit) {
=09=09=09memset(&msg, 0, sizeof(struct xsk_thread_msg));
=09=09=09if(msgrcv(msg_queue_id, (void*)(&msg), sizeof(struct xsk_thread_ms=
g), 0, 0) =3D=3D -1) {
=09=09=09=09fprintf(stderr, "Failed to receive message: %s\n", strerror(err=
no));
=09=09=09} else {
=09=09=09=09xsk_ring_cons__release(msg.xsk_rx, msg.xsk_rx_rcvd);
=09=09=09=09xsk_ring_prod__submit(&umem_info->fq, msg.xsk_prod_reserve_amnt=
);
=09=09=09}
=09=09}

What I am observing is that it works for a few seconds or so and then packe=
t loss gradually increases to 100% (e.g. sequence numbers don't match up) b=
ut the amount of received packets stays the same.
