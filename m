Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54307 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725842AbfKUG0h (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Nov 2019 01:26:37 -0500
Date: Thu, 21 Nov 2019 07:26:25 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: error loading xdp program on virtio nic
Message-ID: <20191121072625.3573368f@carbon>
In-Reply-To: <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
        <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
        <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
        <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
        <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: David Ahern <dsahern@gmail.com>
Cc: brouer@redhat.com, Jason Wang <jasowang@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Wed, 20 Nov 2019 21:05:48 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 11/20/19 8:54 PM, Jason Wang wrote:
> >>
> >> The current error message is:
> >> =C2=A0=C2=A0 virtio_net: Too few free TX rings available
> >> again, looking for some libvirt setting for the vm create.
> >> =20
> >=20
> > Make sure you have sufficient queues, e.g if you N vcpus with multiqueu=
e
> > enabled, you need 2*N queues for virtio-net. =20
>=20
> yep, that did the trick and now I can attach xdp programs. Thanks for
> the help.

How did you configure number of queues in libbvirt?=20

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
