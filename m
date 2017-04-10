Return-path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34329 "EHLO
 mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with
 ESMTP id S1751140AbdDJUpN (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
 Mon, 10 Apr 2017 16:45:13 -0400
Received: by mail-pf0-f177.google.com with SMTP id c198so27409685pfc.1 for
 <xdp-newbies@vger.kernel.org>; Mon, 10 Apr 2017 13:45:13 -0700 (PDT)
Subject: Re: xdp on virtio_net
References: <8ec1432f-b032-0e2c-5e07-cee4550f97b7@klipix.org>
 <20170408140110.27d0fe80@redhat.com> <20170410161833.GK4714@microsoft.com>
 <20170410224319.28a70776@redhat.com>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <eefb8af4-a09f-93a8-9112-f6c1da41ef98@cumulusnetworks.com>
Date: Mon, 10 Apr 2017 14:45:10 -0600
MIME-Version: 1.0
In-Reply-To: <20170410224319.28a70776@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Jesper Dangaard Brouer <brouer@redhat.com>, Julien Desfossez <ju@klipix.org>
Cc: John Fastabend <john.fastabend@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 4/10/17 2:43 PM, Jesper Dangaard Brouer wrote:
>> So now, all I need is to make this check pass:
>> if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
>>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO)) {
>> 	netdev_warn(dev, "can't set XDP while host is implementing LRO, disable LRO first\n");
>> 	return -EOPNOTSUPP;
>> }
>>
>> I know running ethtool commands to disable those features does not change the
>> result.
>>
>> If you have an idea on how to solve this problem that would be great.
> 
> Maybe someone on the xdp-newbies@vger.kernel.org list can help?
> 

Pass this on the qemu command line for the device you want to run xdp:

"gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off"
