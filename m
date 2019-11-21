Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725842AbfKUDy7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Nov 2019 22:54:59 -0500
Subject: Re: error loading xdp program on virtio nic
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
 <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
 <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
Date: Thu, 21 Nov 2019 11:54:53 +0800
MIME-Version: 1.0
In-Reply-To: <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: David Ahern <dsahern@gmail.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


On 2019/11/21 =E4=B8=8A=E5=8D=8811:35, David Ahern wrote:
> On 11/20/19 8:26 PM, Jason Wang wrote:
>> On 2019/11/21 =E4=B8=8A=E5=8D=881:52, David Ahern wrote:
>>> Hi:
>>>
>>> Trying to load an XDP program on a virtio based nic is failing with:
>>>
>>> virtio_net: XDP expects header/data in single page, any_header_sg
>>> required
>>>
>>> I have not encountered this error before and not able to find what is
>>> missing. Any tips?
>>
>> Hi David:
>>
>> What qemu + guest kernel version did you use? And could you share you
>> qemu cli?
>>
>> Old qemu requires vnet header to be placed into a separate sg which
>> breaks the assumption of XDP. Recent qemu doesn't have such limitation
>> (any_header_sg feature).
>>
>>
> Hi Jason,
>
> When I run qemu via my older vm-tools scripts XDP works fine. This is
> the first time I am trying to use XDP with guests started by libvirt.
>
> We isolated it to a libvirt xml file using an old machine type
> (pc-i440fx-1.5) - basically any machine with VIRTIO_F_VERSION_1 not set.
> Using a newer one move the problem forward.


Yes, if VERSION_1 implies ANY_HEADER_SG, and if you're using old qemu,=20
make sure any_header_sg is enabled in qemu cli.


>
> The current error message is:
>    virtio_net: Too few free TX rings available
> again, looking for some libvirt setting for the vm create.
>

Make sure you have sufficient queues, e.g if you N vcpus with multiqueue=20
enabled, you need 2*N queues for virtio-net.

Thanks
