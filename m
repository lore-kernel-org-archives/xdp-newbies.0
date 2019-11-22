Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59212 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726633AbfKVQ6B (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Nov 2019 11:58:01 -0500
Date: Fri, 22 Nov 2019 17:57:49 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: error loading xdp program on virtio nic
Message-ID: <20191122175749.47728e42@carbon>
In-Reply-To: <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com>
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
        <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
        <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
        <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
        <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
        <20191121072625.3573368f@carbon>
        <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com>
        <df4ae5e7-3f79-fd28-ea2e-43612ff61e6f@gmail.com>
        <f7b19bae-a9cf-d4bf-7eee-bfe644d87946@redhat.com>
        <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: David Ahern <dsahern@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, brouer@redhat.com, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Fri, 22 Nov 2019 08:43:50 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 11/21/19 11:09 PM, Jason Wang wrote:
> >> Doubling the number of queues for each tap device adds overhead to the
> >> hypervisor if you only want to allow XDP_DROP or XDP_DIRECT. Am I
> >> understanding that correctly?  
> > 
> > 
> > Yes, but there's almost impossible to know whether or not XDP_TX will be
> > used by the program. If we don't use per CPU TX queue, it must be
> > serialized through locks, not sure it's worth try that (not by default,
> > of course).
> >   
> 
> This restriction is going to prevent use of XDP in VMs in general cloud
> hosting environments. 2x vhost threads for vcpus is a non-starter.
> 
> If one XDP feature has high resource needs, then we need to subdivide
> the capabilities to let some work and others fail. For example, a flag
> can be added to xdp_buff / xdp_md that indicates supported XDP features.
> If there are insufficient resources for XDP_TX, do not show support for
> it. If a program returns XDP_TX anyways, packets will be dropped.
> 

This sounds like concrete use-case and solid argument why we need XDP
feature detection and checks. (Last part of LPC talk[1] were about
XDP features).

An interesting perspective you bring up, is that XDP features are not
static per device driver.  It actually needs to be dynamic, as your
XDP_TX feature request depend on the queue resources available.

Implementation wise, I would not add flags to xdp_buff / xdp_md.
Instead I propose in[1] slide 46, that the verifier should detect the
XDP features used by a BPF-prog.  If you XDP prog doesn't use e.g.
XDP_TX, then you should be allowed to run it on a virtio_net device
with less queue configured, right?


[1] http://people.netfilter.org/hawk/presentations/LinuxPlumbers2019/xdp-distro-view.pdf
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
