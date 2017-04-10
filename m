Return-path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbdDJUna (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Apr 2017 16:43:30 -0400
Date: Mon, 10 Apr 2017 22:43:19 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: xdp on virtio_net
Message-ID: <20170410224319.28a70776@redhat.com>
In-Reply-To: <20170410161833.GK4714@microsoft.com>
References: <8ec1432f-b032-0e2c-5e07-cee4550f97b7@klipix.org>
        <20170408140110.27d0fe80@redhat.com>
        <20170410161833.GK4714@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Julien Desfossez <ju@klipix.org>
Cc: John Fastabend <john.fastabend@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Mon, 10 Apr 2017 12:18:33 -0400
Julien Desfossez <ju@klipix.org> wrote:

> > > Hi,
> > > 
> > > Following the presentation of Jesper on XDP, I have been trying to
> > > make the example work on KVM with virtio_net (and yes you are right,
> > > people try stuff when it is on github :-) ).  
> > 
> > Great to hear you pulled my github repo :-)
> >    
> > > I am testing on an Ubuntu 17.04 VM, I recompiled the 4.10 kernel,
> > > the code from the example compiles fine, but I get into trouble when
> > > trying to load the bpf/xdp code.
> > > 
> > > The first error I get is: virtio_net virtio0 enp0s3: can't set XDP
> > > while host is implementing LRO, disable LRO first
> > > 
> > > I have tried to disable the various features checked in this code
> > > with ethtool, but it seems to check if the feature is available, not
> > > necessarily enabled and I have no idea how to make those features
> > > not available.
> > > 
> > > I tried to comment the check to see if it would go somewhere, but
> > > then I got into a problem with the number of queues available (4
> > > vCPUs): virtio_net virtio0 enp0s3: request 5 queues but max is 1 And
> > > I don't know how to add more queues (I am launching the VM with
> > > libvirt/virt-manager).
> > > 
> > > So my question is: do you have a recipe that works well to test this
> > > virtio_net + XDP feature ?  Does the physical host need a special
> > > configuration ? Right now it is just a standard Ubuntu 16.04 (4.4
> > > kernel and libvirt 1.3.1).  
> > 
> > I have not tried to get XDP working on virtio_net ... but I'm hoping
> > John or Michael can provide some more info on this?  
> 
> Ok, I managed to solve the problem with the number of queues. Now with
> the checks for TSO, ECN and UFO commented in virtio_net.c, the
> xdp_ddos01_blacklist program works :-)
> 
> So now, all I need is to make this check pass:
> if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>     virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO)) {
> 	netdev_warn(dev, "can't set XDP while host is implementing LRO, disable LRO first\n");
> 	return -EOPNOTSUPP;
> }
> 
> I know running ethtool commands to disable those features does not change the
> result.
> 
> If you have an idea on how to solve this problem that would be great.

Maybe someone on the xdp-newbies@vger.kernel.org list can help?

(p.s. I will be flying out of Montreal heading home in approx 30 min)
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
