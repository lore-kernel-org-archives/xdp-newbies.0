Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbfKWN1z (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 23 Nov 2019 08:27:55 -0500
Received: by mail-lf1-f72.google.com with SMTP id t28so2385711lfq.6
        for <xdp-newbies@vger.kernel.org>; Sat, 23 Nov 2019 05:27:51 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: error loading xdp program on virtio nic
In-Reply-To: <1fc9364a-ab96-e085-1fc5-9ed29f43f815@gmail.com>
References: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com> <89f56317-5955-e692-fcf0-ee876aae068b@redhat.com> <3dc7b9d8-bcb2-1a90-630e-681cbf0f1ace@gmail.com> <18659bd0-432e-f317-fa8a-b5670a91c5b9@redhat.com> <f7b8df14-ef7f-be76-a990-b9d71139bcaa@gmail.com> <20191121072625.3573368f@carbon> <4686849f-f3b8-dd1d-0fe4-3c176a37b67a@redhat.com> <df4ae5e7-3f79-fd28-ea2e-43612ff61e6f@gmail.com> <f7b19bae-a9cf-d4bf-7eee-bfe644d87946@redhat.com> <8324a37e-5507-2ae6-53f6-949c842537e0@gmail.com> <20191122175749.47728e42@carbon> <1fc9364a-ab96-e085-1fc5-9ed29f43f815@gmail.com>
Date: Sat, 23 Nov 2019 14:27:48 +0100
Message-ID: <87k17q3ep7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: David Ahern <dsahern@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

David Ahern <dsahern@gmail.com> writes:

> On 11/22/19 9:57 AM, Jesper Dangaard Brouer wrote:
>> Implementation wise, I would not add flags to xdp_buff / xdp_md.
>> Instead I propose in[1] slide 46, that the verifier should detect the
>> XDP features used by a BPF-prog.  If you XDP prog doesn't use e.g.
>> XDP_TX, then you should be allowed to run it on a virtio_net device
>> with less queue configured, right?
>
> Thanks for the reference and yes, that is the goal: allow XDP in the
> most use cases possible. e.g., Why limit XDP_DROP which requires no
> resources because XDP_TX does not work?
>
> I agree a flag in the api is an ugly way to allow it. For the verifier
> approach, you mean add an internal flag (e.g., bitmask of return codes)
> that the program uses and the NIC driver can check at attach time?

Yes, that's more or less what we've discussed. With the actual set of
flags, and the API for the driver (new ndo?) TBD. Suggestions welcome; I
anticipate this is something Jesper and I need to circle back to soonish
in any case (unless someone beats us to it!).

-Toke
