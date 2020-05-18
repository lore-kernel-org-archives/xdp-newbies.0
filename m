Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgERNOa (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 May 2020 09:14:30 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F41C061A0C
        for <xdp-newbies@vger.kernel.org>; Mon, 18 May 2020 06:14:30 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id d7so904475vsh.0
        for <xdp-newbies@vger.kernel.org>; Mon, 18 May 2020 06:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <ba88e0ff11b940fe8855a0dd43c947ae@hm.edu> <CAJ8uoz1wQcCN6N_NPQhG5OFOyBp-a2Mqwh+nqeTGYqOeL_dCLw@mail.gmail.com>
 <0f2212ea98c74001b5c0282bfb6718d7@hm.edu>
In-Reply-To: <0f2212ea98c74001b5c0282bfb6718d7@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 18 May 2020 15:14:18 +0200
Message-ID: <CAJ8uoz33iGMze_Au6RQDqzsM8Po_E20ZxSxT21TFCwJwkKdW1g@mail.gmail.com>
Subject: Re: How does the Kernel decide which Umem frame to choose for the
 next packet?
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Mon, May 18, 2020 at 11:17 AM Gaul, Maximilian
<maximilian.gaul@hm.edu> wrote:
>
> > User-space decides this by what frames it enters into the fill ring.
> > Kernel-space uses the frames in order from that ring.
> >
> > /Magnus
>
> Thank you for your reply Magnus,
>
> I am sorry to ask again but I am not so sure when this happens.
> So I first check my socket RX-ring for new packets:
>
>                 xsk_ring_cons__peek(&xsk_socket->rx, 1024, &idx_rx)
>
> which looks like this:
>
>                 static inline size_t xsk_ring_cons__peek(struct xsk_ring_=
cons *cons,
>                                                          size_t nb, __u32=
 *idx)
>                 {
>                         size_t entries =3D xsk_cons_nb_avail(cons, nb);
>
>                         if (entries > 0) {
>                                 /* Make sure we do not speculatively read=
 the data before
>                                  * we have received the packet buffers fr=
om the ring.
>                                  */
>                                 libbpf_smp_rmb();
>
>                                 *idx =3D cons->cached_cons;
>                                 cons->cached_cons +=3D entries;
>                         }
>
>                         return entries;
>                 }
>
> where `idx_rx` is the starting position of descriptors for the new packet=
s in the RX-ring.
>
> My first question here is: How can there already be descriptors of packet=
s in my RX-ring if I didn't enter any frames into the fill ring of the umem=
 yet?
> So I assume libbpf did this for me already?

Yes, that is correct.

> After this call I know how many packets are waiting. So I reserve exactly=
 as many Umem frames:
>
>                 xsk_ring_prod__reserve(&umem_info->fq, rx_rcvd_amnt, &idx=
_fq);
>
> which looks like this:
>
>                 static inline size_t xsk_ring_prod__reserve(struct xsk_ri=
ng_prod *prod,
>                                                                 size_t nb=
, __u32 *idx)
>                 {
>                         if (xsk_prod_nb_free(prod, nb) < nb)
>                                 return 0;
>
>                         *idx =3D prod->cached_prod;
>                         prod->cached_prod +=3D nb;
>
>                         return nb;
>                 }
>
> But what am I exactly reserving here? How can I reserve anything from the=
 Umem without telling it the RX-ring of my socket?

You are reserving descriptor slots in a producer ring.

> After  this, I extract the RX-ring packet descriptors, starting at `idx_r=
x`:
>
>                 const struct xdp_desc *desc =3D xsk_ring_cons__rx_desc(&x=
sk_socket->rx, idx_rx + i);
>
> I am also not entirely certain with the zero-copy aspect of AF-XDP. As fa=
r as I know the NIC writes incoming packets via DMA directly into system me=
mory. But this time system memory means the Umem area - right? Where with n=
on-zero-copy this would be any position in memory and the Kernel first has =
to copy the packets into the Umem area?

In zero-copy mode, the NIC DMA:s the packet straight into the umem, so
they are immediately seen by the user space process.

> I am also a bit confused what the size of a RX-queue means in this contex=
t. Assuming the output of ethtool:
>
>                 $ ethtool -g eth20
>                 Ring parameters for eth20:
>                 Pre-set maximums:
>                 RX:             8192
>                 RX Mini:        0
>                 RX Jumbo:       0
>                 TX:             8192
>                 Current hardware settings:
>                 RX:             1024
>                 RX Mini:        0
>                 RX Jumbo:       0
>                 TX:             1024
>
> Does this mean that at the moment my NIC can store 1024 incoming packets =
inside its own memory?

The NIC does not have its own memory. This just means that their can
be 1024 packets that will be processed by the NIC or have been
processed by the NIC but not handled by the driver. Nothing you need
to care about unless you are performance optimizing, or writing a
driver of course :-).

> So there is no connection between the RX-queue size of the NIC and the Um=
em area?

Correct.

/Magnus

> Sorry for this wall of text. Maybe you can answer a few of my questions, =
I hope they are not too confusing.
>
> Thank you so much
>
> Max
