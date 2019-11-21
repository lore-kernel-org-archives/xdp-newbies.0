Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f179.google.com ([209.85.210.179]:38008 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKUEFx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Nov 2019 23:05:53 -0500
Received: by mail-pf1-f179.google.com with SMTP id c13so957485pfp.5
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Nov 2019 20:05:51 -0800 (PST)
Subject: Re: error loading xdp program on virtio nic
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
 <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
 <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
 <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
Date: Wed, 20 Nov 2019 21:05:48 -0700
MIME-Version: 1.0
In-Reply-To: <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Jason Wang <jasowang@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 11/20/19 8:54 PM, Jason Wang wrote:
>>
>> The current error message is:
>> =C2=A0=C2=A0 virtio_net: Too few free TX rings available
>> again, looking for some libvirt setting for the vm create.
>>
>=20
> Make sure you have sufficient queues, e.g if you N vcpus with multiqueue
> enabled, you need 2*N queues for virtio-net.

yep, that did the trick and now I can attach xdp programs. Thanks for
the help.
