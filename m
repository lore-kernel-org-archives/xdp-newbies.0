Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33396 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726895AbfKYCsb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 24 Nov 2019 21:48:31 -0500
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
 <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <8041b387-5cfb-7a57-fc01-9be6967d8658@redhat.com>
Date: Mon, 25 Nov 2019 10:48:19 +0800
MIME-Version: 1.0
In-Reply-To: <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: David Ahern <dsahern@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


On 2019/11/22 =E4=B8=8B=E5=8D=8811:43, David Ahern wrote:
> On 11/21/19 11:09 PM, Jason Wang wrote:
>>> Doubling the number of queues for each tap device adds overhead to the
>>> hypervisor if you only want to allow XDP_DROP or XDP_DIRECT. Am I
>>> understanding that correctly?
>>
>> Yes, but there's almost impossible to know whether or not XDP_TX will be
>> used by the program. If we don't use per CPU TX queue, it must be
>> serialized through locks, not sure it's worth try that (not by default,
>> of course).
>>
> This restriction is going to prevent use of XDP in VMs in general cloud
> hosting environments. 2x vhost threads for vcpus is a non-starter.
>
> If one XDP feature has high resource needs, then we need to subdivide
> the capabilities to let some work and others fail. For example, a flag
> can be added to xdp_buff / xdp_md that indicates supported XDP features.
> If there are insufficient resources for XDP_TX, do not show support for
> it. If a program returns XDP_TX anyways, packets will be dropped.
>

Or we can just:
- If queues is sufficient, using per-cpu TX queue
- If not, synchronize through spinlocks (like what TAP did right now,=20
since there's no easy way to have more queues on the fly)

Thanks
