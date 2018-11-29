Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbeK2QzQ (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 29 Nov 2018 11:55:16 -0500
Subject: Re: qemu-kvm XDP forwarding with virtio_net
From: Jason Wang <jasowang@redhat.com>
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
 <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com>
 <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
 <20181120191412.088c68fb@redhat.com>
 <b9da9c67-e31c-f469-6515-c7913a89dd26@redhat.com>
 <CAHOxX0zY5WM4oK7W6owem2LpkuyokCw_oLSXArdp2OMAU9-Wng@mail.gmail.com>
 <c9f1233e-bcc8-e8db-3f25-ca572a104d80@redhat.com>
Message-ID: <13c7d34b-dd0a-1ba9-e72d-b89955249ea8@redhat.com>
Date: Thu, 29 Nov 2018 13:50:57 +0800
MIME-Version: 1.0
In-Reply-To: <c9f1233e-bcc8-e8db-3f25-ca572a104d80@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>
Cc: brouer@redhat.com, David Ahern <dsahern@gmail.com>, xdp-newbies@vger.kernel.org


On 2018/11/26 下午2:36, Jason Wang wrote:
>
> On 2018/11/24 上午1:09, Pavel Popa wrote:
>> Hi Jason,
>>
>> I confirm that the patch you sent me, together with "[PATCH net 1/2]
>> virtio-net: disable guest csum during XDP set" and "[PATCH net 2/2]
>> virtio-net: fail XDP set if guest csum is negotiated", have fixed the
>> "bad gso" issue.
>>
>> Cheers
>
>
> Thanks for the testing.
>
> Let me post a formal patch.


Actually, there's a typo in the patch I attached.

The check xdp_prog != NULL should be !xdp_prog.

I will fix this and post soon.

Thanks
