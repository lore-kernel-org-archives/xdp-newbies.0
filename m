Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51588 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1IBT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 28 Jun 2019 04:01:19 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190628080117euoutp010829ba6d6d75d95966f50f4d08834a32~sTfMNl6SX1355813558euoutp01V
        for <xdp-newbies@vger.kernel.org>; Fri, 28 Jun 2019 08:01:17 +0000 (GMT)
Subject: Re: [PATCH bpf v5 2/2] xdp: fix hang while unregistering device
 bound to xdp socket
From: Ilya Maximets <i.maximets@samsung.com>
Message-ID: <2190070e-db72-6fbe-8dc9-7567847e48ff@samsung.com>
Date: Fri, 28 Jun 2019 11:01:09 +0300
MIME-Version: 1.0
In-Reply-To: <74C6C13C-651D-4CD1-BCA1-1B8998A4FA31@gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
References: <20190627101529.11234-1-i.maximets@samsung.com>
        <CGME20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934@eucas1p1.samsung.com>
        <20190627101529.11234-3-i.maximets@samsung.com>
        <74C6C13C-651D-4CD1-BCA1-1B8998A4FA31@gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>

On 28.06.2019 1:04, Jonathan Lemon wrote:
> On 27 Jun 2019, at 3:15, Ilya Maximets wrote:
> 
>> Device that bound to XDP socket will not have zero refcount until the
>> userspace application will not close it. This leads to hang inside
>> 'netdev_wait_allrefs()' if device unregistering requested:
>>
>>   # ip link del p1
>>   < hang on recvmsg on netlink socket >
>>
>>   # ps -x | grep ip
>>   5126  pts/0    D+   0:00 ip link del p1
>>
>>   # journalctl -b
>>
>>   Jun 05 07:19:16 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>
>>   Jun 05 07:19:27 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>   ...
>>
>> Fix that by implementing NETDEV_UNREGISTER event notification handler
>> to properly clean up all the resources and unref device.
>>
>> This should also allow socket killing via ss(8) utility.
>>
>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>  include/net/xdp_sock.h |  5 +++
>>  net/xdp/xdp_umem.c     | 10 ++---
>>  net/xdp/xdp_umem.h     |  1 +
>>  net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
>>  4 files changed, 87 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> index d074b6d60f8a..82d153a637c7 100644
>> --- a/include/net/xdp_sock.h
>> +++ b/include/net/xdp_sock.h
>> @@ -61,6 +61,11 @@ struct xdp_sock {
>>      struct xsk_queue *tx ____cacheline_aligned_in_smp;
>>      struct list_head list;
>>      bool zc;
>> +    enum {
>> +        XSK_UNINITIALIZED = 0,
>> +        XSK_BINDED,
>> +        XSK_UNBINDED,
>> +    } state;
> 
> I'd prefer that these were named better, perhaps:
>    XSK_READY,
>    XSK_BOUND,
>    XSK_UNBOUND,

Sure. Thanks for suggestion!

> 
> Other than that:
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 

I'll send a new version with the new state names keeping your ACK.

Best regards, Ilya Maximets.
