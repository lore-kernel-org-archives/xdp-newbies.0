Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43777 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUDfh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Nov 2019 22:35:37 -0500
Received: by mail-pf1-f194.google.com with SMTP id 3so905662pfb.10
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Nov 2019 19:35:36 -0800 (PST)
Subject: Re: error loading xdp program on virtio nic
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
 <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
Date: Wed, 20 Nov 2019 20:35:33 -0700
MIME-Version: 1.0
In-Reply-To: <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jason Wang <jasowang@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 11/20/19 8:26 PM, Jason Wang wrote:
> 
> On 2019/11/21 上午1:52, David Ahern wrote:
>> Hi:
>>
>> Trying to load an XDP program on a virtio based nic is failing with:
>>
>> virtio_net: XDP expects header/data in single page, any_header_sg
>> required
>>
>> I have not encountered this error before and not able to find what is
>> missing. Any tips?
> 
> 
> Hi David:
> 
> What qemu + guest kernel version did you use? And could you share you
> qemu cli?
> 
> Old qemu requires vnet header to be placed into a separate sg which
> breaks the assumption of XDP. Recent qemu doesn't have such limitation
> (any_header_sg feature).
> 
>

Hi Jason,

When I run qemu via my older vm-tools scripts XDP works fine. This is
the first time I am trying to use XDP with guests started by libvirt.

We isolated it to a libvirt xml file using an old machine type
(pc-i440fx-1.5) - basically any machine with VIRTIO_F_VERSION_1 not set.
Using a newer one move the problem forward.

The current error message is:
  virtio_net: Too few free TX rings available
again, looking for some libvirt setting for the vm create.
