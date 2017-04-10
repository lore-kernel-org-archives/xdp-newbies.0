Return-path: <xdp-newbies-owner@vger.kernel.org>
Received: from albert.ini-tech.com ([192.99.4.57]:59222 "EHLO
        smtp.ini-tech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdDJXtm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Apr 2017 19:49:42 -0400
Date: Mon, 10 Apr 2017 19:39:52 -0400
From: Julien Desfossez <ju@klipix.org>
Subject: Re: xdp on virtio_net
Message-ID: <20170410233952.GA4836@microsoft.com>
References: <8ec1432f-b032-0e2c-5e07-cee4550f97b7@klipix.org>
 <20170408140110.27d0fe80@redhat.com>
 <20170410161833.GK4714@microsoft.com>
 <20170410224319.28a70776@redhat.com>
 <eefb8af4-a09f-93a8-9112-f6c1da41ef98@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eefb8af4-a09f-93a8-9112-f6c1da41ef98@cumulusnetworks.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: David Ahern <dsa@cumulusnetworks.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, John Fastabend <john.fastabend@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 10-Apr-2017 02:45:10 PM, David Ahern wrote:
> On 4/10/17 2:43 PM, Jesper Dangaard Brouer wrote:
> >> So now, all I need is to make this check pass:
> >> if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> >>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> >>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> >>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO)) {
> >> 	netdev_warn(dev, "can't set XDP while host is implementing LRO, disable LRO first\n");
> >> 	return -EOPNOTSUPP;
> >> }
> >>
> >> I know running ethtool commands to disable those features does not change the
> >> result.
> >>
> >> If you have an idea on how to solve this problem that would be great.
> > 
> > Maybe someone on the xdp-newbies@vger.kernel.org list can help?
> > 
> 
> Pass this on the qemu command line for the device you want to run xdp:
> 
> "gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off"

Awesome, it works !

If others want to do it with libvirt/virsh instead of the qemu command line,
here is the right incantation to add to the "interface" section (with 4 vCPUs):
<driver name='vhost' queues='8'>
    <host tso4='off' tso6='off' ecn='off' ufo='off'/>
    <guest tso4='off' tso6='off' ecn='off' ufo='off'/>
</driver>

Thanks !

Julien
