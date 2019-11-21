Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f174.google.com ([209.85.160.174]:44647 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUPuD (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Nov 2019 10:50:03 -0500
Received: by mail-qt1-f174.google.com with SMTP id o11so4141656qtr.11
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Nov 2019 07:50:02 -0800 (PST)
Subject: Re: error loading xdp program on virtio nic
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
 <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
 <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
 <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
 <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
 <20191121072625.3573368f@carbon>
 <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <df4ae5e7-3f79-fd28-ea2e-43612ff61e6f@gmail.com>
Date: Thu, 21 Nov 2019 08:49:57 -0700
MIME-Version: 1.0
In-Reply-To: <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Jason Wang <jasowang@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 11/21/19 12:02 AM, Jason Wang wrote:
> By specifying queues property like:
>=20
> <devices>
>=20
> =C2=A0 <interface type=3D'network'>
> =C2=A0=C2=A0=C2=A0 <source network=3D'default'/>
> =C2=A0=C2=A0=C2=A0 <target dev=3D'vnet1'/>
> =C2=A0=C2=A0=C2=A0 <model type=3D'virtio'/>
> =C2=A0=C2=A0=C2=A0 <driver name=3D'vhost' txmode=3D'iothread' ioeventfd=
=3D'on'
> event_idx=3D'off' queues=3D'5' rx_queue_size=3D'256' tx_queue_size=3D'256=
'>

I can not check this because the 3.0 version of libvirt does not support
tx_queue_size. It is multiqueue (queues=3D5 in the example) setting that
needs to be set to 2*Nvcpus for XDP, correct?

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <host csum=3D'off' gso=3D'off' tso4=3D'off=
' tso6=3D'off' ecn=3D'off'
> ufo=3D'off' mrg_rxbuf=3D'off'/>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 <guest csum=3D'off' tso4=3D'off' tso6=3D'o=
ff' ecn=3D'off' ufo=3D'off'/>
> =C2=A0=C2=A0=C2=A0 </driver>
> =C2=A0=C2=A0=C2=A0 </interface>
> </devices>
>=20
>=20

The virtio_net driver suggests the queues are needed for XDP_TX:

       /* XDP requires extra queues for XDP_TX */
        if (curr_qp + xdp_qp > vi->max_queue_pairs) {
                NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings
available");
                netdev_warn(dev, "request %i queues but max is %i\n",
                            curr_qp + xdp_qp, vi->max_queue_pairs);
                return -ENOMEM;
        }

Doubling the number of queues for each tap device adds overhead to the
hypervisor if you only want to allow XDP_DROP or XDP_DIRECT. Am I
understanding that correctly?
