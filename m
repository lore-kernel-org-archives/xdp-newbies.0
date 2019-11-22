Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42848 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRm6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Nov 2019 12:42:58 -0500
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
 <20191122175749.47728e42@carbon>
From: David Ahern <dsahern@gmail.com>
Message-ID: <1fc9364a-ab96-e085-1fc5-9ed29f43f815@gmail.com>
Date: Fri, 22 Nov 2019 10:42:53 -0700
MIME-Version: 1.0
In-Reply-To: <20191122175749.47728e42@carbon>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On 11/22/19 9:57 AM, Jesper Dangaard Brouer wrote:
> Implementation wise, I would not add flags to xdp_buff / xdp_md.
> Instead I propose in[1] slide 46, that the verifier should detect the
> XDP features used by a BPF-prog.  If you XDP prog doesn't use e.g.
> XDP_TX, then you should be allowed to run it on a virtio_net device
> with less queue configured, right?

Thanks for the reference and yes, that is the goal: allow XDP in the
most use cases possible. e.g., Why limit XDP_DROP which requires no
resources because XDP_TX does not work?

I agree a flag in the api is an ugly way to allow it. For the verifier
approach, you mean add an internal flag (e.g., bitmask of return codes)
that the program uses and the NIC driver can check at attach time?
