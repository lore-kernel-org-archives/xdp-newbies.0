Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33032 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725819AbfKUD0T (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Nov 2019 22:26:19 -0500
Subject: Re: error loading xdp program on virtio nic
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
Date: Thu, 21 Nov 2019 11:26:12 +0800
MIME-Version: 1.0
In-Reply-To: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: David Ahern <dsahern@gmail.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


On 2019/11/21 =E4=B8=8A=E5=8D=881:52, David Ahern wrote:
> Hi:
>
> Trying to load an XDP program on a virtio based nic is failing with:
>
> virtio_net: XDP expects header/data in single page, any_header_sg require=
d
>
> I have not encountered this error before and not able to find what is
> missing. Any tips?


Hi David:

What qemu + guest kernel version did you use? And could you share you=20
qemu cli?

Old qemu requires vnet header to be placed into a separate sg which=20
breaks the assumption of XDP. Recent qemu doesn't have such limitation=20
(any_header_sg feature).

Thanks


>
> Thanks,
> David
>
