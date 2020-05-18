Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:38999 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERJRO (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 May 2020 05:17:14 -0400
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: How does the Kernel decide which Umem frame to choose for the
 next packet?
Date: Mon, 18 May 2020 09:17:06 +0000
Message-ID: <0f2212ea98c74001b5c0282bfb6718d7@hm.edu>
References: <ba88e0ff11b940fe8855a0dd43c947ae@hm.edu>,<CAJ8uoz1wQcCN6N_NPQhG5OFOyBp-a2Mqwh+nqeTGYqOeL_dCLw@mail.gmail.com>
In-Reply-To: <CAJ8uoz1wQcCN6N_NPQhG5OFOyBp-a2Mqwh+nqeTGYqOeL_dCLw@mail.gmail.com>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

> User-space decides this by what frames it enters into the fill ring.
> Kernel-space uses the frames in order from that ring.
>=20
> /Magnus

Thank you for your reply Magnus,

I am sorry to ask again but I am not so sure when this happens.
So I first check my socket RX-ring for new packets:

=09=09xsk_ring_cons__peek(&xsk_socket->rx, 1024, &idx_rx)

which looks like this:

=09=09static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
=09=09=09=09=09=09=09 size_t nb, __u32 *idx)
=09=09{
=09=09=09size_t entries =3D xsk_cons_nb_avail(cons, nb);

=09=09=09if (entries > 0) {
=09=09=09=09/* Make sure we do not speculatively read the data before
=09=09=09=09 * we have received the packet buffers from the ring.
=09=09=09=09 */
=09=09=09=09libbpf_smp_rmb();

=09=09=09=09*idx =3D cons->cached_cons;
=09=09=09=09cons->cached_cons +=3D entries;
=09=09=09}

=09=09=09return entries;
=09=09}

where `idx_rx` is the starting position of descriptors for the new packets =
in the RX-ring.

My first question here is: How can there already be descriptors of packets =
in my RX-ring if I didn't enter any frames into the fill ring of the umem y=
et?
So I assume libbpf did this for me already?

After this call I know how many packets are waiting. So I reserve exactly a=
s many Umem frames:

=09=09xsk_ring_prod__reserve(&umem_info->fq, rx_rcvd_amnt, &idx_fq);

which looks like this:

=09=09static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *pro=
d,
=09=09=09=09=09=09=09=09size_t nb, __u32 *idx)
=09=09{
=09=09=09if (xsk_prod_nb_free(prod, nb) < nb)
=09=09=09=09return 0;

=09=09=09*idx =3D prod->cached_prod;
=09=09=09prod->cached_prod +=3D nb;

=09=09=09return nb;
=09=09}

But what am I exactly reserving here? How can I reserve anything from the U=
mem without telling it the RX-ring of my socket?

After  this, I extract the RX-ring packet descriptors, starting at `idx_rx`=
:

=09=09const struct xdp_desc *desc =3D xsk_ring_cons__rx_desc(&xsk_socket->r=
x, idx_rx + i);

I am also not entirely certain with the zero-copy aspect of AF-XDP. As far =
as I know the NIC writes incoming packets via DMA directly into system memo=
ry. But this time system memory means the Umem area - right? Where with non=
-zero-copy this would be any position in memory and the Kernel first has to=
 copy the packets into the Umem area?

I am also a bit confused what the size of a RX-queue means in this context.=
 Assuming the output of ethtool:

=09=09$ ethtool -g eth20
=09=09Ring parameters for eth20:
=09=09Pre-set maximums:
=09=09RX:             8192
=09=09RX Mini:        0
=09=09RX Jumbo:       0
=09=09TX:             8192
=09=09Current hardware settings:
=09=09RX:             1024
=09=09RX Mini:        0
=09=09RX Jumbo:       0
=09=09TX:             1024

Does this mean that at the moment my NIC can store 1024 incoming packets in=
side its own memory? So there is no connection between the RX-queue size of=
 the NIC and the Umem area?

Sorry for this wall of text. Maybe you can answer a few of my questions, I =
hope they are not too confusing.

Thank you so much

Max
