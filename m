Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f42.google.com ([209.85.166.42]:44358 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfKVPny (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Nov 2019 10:43:54 -0500
Received: by mail-io1-f42.google.com with SMTP id j20so8450027ioo.11
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Nov 2019 07:43:53 -0800 (PST)
Subject: Re: error loading xdp program on virtio nic
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
 <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com>
 <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com>
 <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com>
 <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com>
 <20191121072625.3573368f@carbon>
 <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com>
 <df4ae5e7-3f79-fd28-ea2e-43612ff61e6f@gmail.com>
 <f7b19bae-a9cf-d4bf-7eee-bfe644d87946@redhat.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com>
Date: Fri, 22 Nov 2019 08:43:50 -0700
MIME-Version: 1.0
In-Reply-To: <f7b19bae-a9cf-d4bf-7eee-bfe644d87946@redhat.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jason Wang <jasowang@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 11/21/19 11:09 PM, Jason Wang wrote:
>> Doubling the number of queues for each tap device adds overhead to the
>> hypervisor if you only want to allow XDP_DROP or XDP_DIRECT. Am I
>> understanding that correctly?
> 
> 
> Yes, but there's almost impossible to know whether or not XDP_TX will be
> used by the program. If we don't use per CPU TX queue, it must be
> serialized through locks, not sure it's worth try that (not by default,
> of course).
> 

This restriction is going to prevent use of XDP in VMs in general cloud
hosting environments. 2x vhost threads for vcpus is a non-starter.

If one XDP feature has high resource needs, then we need to subdivide
the capabilities to let some work and others fail. For example, a flag
can be added to xdp_buff / xdp_md that indicates supported XDP features.
If there are insufficient resources for XDP_TX, do not show support for
it. If a program returns XDP_TX anyways, packets will be dropped.
