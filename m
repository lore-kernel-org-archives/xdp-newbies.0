Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f50.google.com ([209.85.167.50]:40159 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfFXOaf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 24 Jun 2019 10:30:35 -0400
Received: by mail-lf1-f50.google.com with SMTP id a9so10219099lff.7
        for <xdp-newbies@vger.kernel.org>; Mon, 24 Jun 2019 07:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAEaYocYhic1UC2p60gO6rzJYzHaHob=0-GUN1Z2e0XgMaPoMBg@mail.gmail.com>
 <28F29E84-6392-4794-A1AB-0566B8ADE5A1@redhat.com>
In-Reply-To: <28F29E84-6392-4794-A1AB-0566B8ADE5A1@redhat.com>
From: Rafael Vargas <vargas@khomp.com>
Date: Mon, 24 Jun 2019 11:30:21 -0300
Message-ID: <CAEaYocaJQ97dqJWT=ydH2Vnz6NY_3xv1oOi1GschHdFRQsrXzw@mail.gmail.com>
Subject: Re: AF_XDP only releasing from FQ in batches
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Em seg, 24 de jun de 2019 =C3=A0s 07:21, Eelco Chaudron
<echaudro@redhat.com> escreveu:

>         /* Stuff the ring with as much frames as possible */
>         stock_frames =3D xsk_ring_prod__free(&xsk->umem->fq);
>         stock_frames =3D MIN(stock_frames, xsk_umem_free_frames(xsk));
>
>         if (stock_frames > 0) {
>
>                 ret =3D xsk_ring_prod__reserve(&xsk->umem->fq, stock_fram=
es,
>                                              &idx_fq);
>                 while (ret !=3D stock_frames)
>                         ret =3D xsk_ring_prod__reserve(&xsk->umem->fq, rc=
vd,
>                                                      &idx_fq);
once you've checked before the number of free entries, this while is
still needed?


> Where  xsk_ring_prod__free() is as follows (sent patch upstream for
> adding it as an API):
>
> static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
> {
>         r->cached_cons =3D *r->consumer + r->size;
>         return r->cached_cons - r->cached_prod;
> }

this is basically  xsk_prod_nb_free, but always triggering the cache
refresh, right?

>
> And the following is an API around my UMEM frame handling:
>
> xsk_umem_free_frames() -> How many buffers do I have available on my
> stack
>
> xsk_free_umem_frame()  -> return a buffer to my buffer stack
>
> xsk_alloc_umem_frame() -> Get a buffer from my buffer stack
>

Is this API using another local ring or stack buffer or is it using
some clever trick I'm not figuring out?

I'll try this approach, thanks!
