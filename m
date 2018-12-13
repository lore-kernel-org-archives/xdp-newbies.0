Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:44733 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLMVCN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Dec 2018 16:02:13 -0500
Received: by mail-wr1-f53.google.com with SMTP id z5so3402279wrt.11
        for <xdp-newbies@vger.kernel.org>; Thu, 13 Dec 2018 13:02:11 -0800 (PST)
MIME-Version: 1.0
References: <CAEaYocZxBKoD72jrE3_YasxxYGfrh1nhkE7yBaXSwRWfe2f54w@mail.gmail.com>
 <810848dc-e8f6-783c-62f0-973f745b9866@gmail.com>
In-Reply-To: <810848dc-e8f6-783c-62f0-973f745b9866@gmail.com>
From: Rafael Vargas <vargas@khomp.com>
Date: Thu, 13 Dec 2018 19:01:58 -0200
Message-ID: <CAEaYocYwjyC5s16vUvW5v=77==YrL2=O6PN8r=onfMOcNMamnA@mail.gmail.com>
Subject: Re: Which interface is the program running...
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Cc: xdp-newbies@vger.kernel.org

Thanks David,

I was using the xdp_md context with only the data and data_end. Should
have dig deeper in the headers of the new kernel.

Rafael Vargas

Rafael Vargas
TELECOM

tel:  +55 48 3722 2900
cel:  +55 48 99612 0276
email:  vargas@khomp.com



Em qui, 13 de dez de 2018 =C3=A0s 18:58, David Ahern <dsahern@gmail.com> es=
creveu:
>
> On 12/13/18 1:54 PM, Rafael Vargas wrote:
> > Hi all,
> >
> > I've being doing some tests and could not find a way within the
> > program to know in which interface is the XDP program running.
> >
> > I install the same program to several interfaces (with
> > bpf_set_link_xdp_fd), is there any way to do that?
> >
>
> xdp_md is the context passed to XDP programs. xdp_md has:
>
>         __u32 ingress_ifindex; /* rxq->dev->ifindex */
>         __u32 rx_queue_index;  /* rxq->queue_index  */
