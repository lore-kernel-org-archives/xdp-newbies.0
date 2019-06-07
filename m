Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59550 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfFGGgY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 7 Jun 2019 02:36:24 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190607063622euoutp022eed90dba2bbee29f0c3259a558adab0~l1yEC4KfC0964409644euoutp02g
        for <xdp-newbies@vger.kernel.org>; Fri,  7 Jun 2019 06:36:22 +0000 (GMT)
Subject: Re: [PATCH] net: Fix hang while unregistering device bound to xdp
 socket
From: Ilya Maximets <i.maximets@samsung.com>
Message-ID: <3014f882-3042-cb6a-2356-ea3a754840a7@samsung.com>
Date: Fri, 7 Jun 2019 09:36:19 +0300
MIME-Version: 1.0
In-Reply-To: <4414B6B6-3FE2-4CF2-A67A-159FCF6B9ECF@gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20190606124020eucas1p2007396ae8f23a426a17e0e5481636187@eucas1p2.samsung.com>
        <20190606124014.23231-1-i.maximets@samsung.com>
        <4414B6B6-3FE2-4CF2-A67A-159FCF6B9ECF@gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>

On 06.06.2019 21:03, Jonathan Lemon wrote:
> On 6 Jun 2019, at 5:40, Ilya Maximets wrote:
> 
>> Device that bound to XDP socket will not have zero refcount until the
>> userspace application will not close it. This leads to hang inside
>> 'netdev_wait_allrefs()' if device unregistering requested:
>>
>>   # ip link del p1
>>   < hang on recvmsg on netlink socket >
>>
>>   # ps -x | grep ip
>>   5126  pts/0    D+   0:00 ip link del p1
>>
>>   # journalctl -b
>>
>>   Jun 05 07:19:16 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>
>>   Jun 05 07:19:27 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>   ...
>>
>> Fix that by counting XDP references for the device and failing
>> RTM_DELLINK with EBUSY if device is still in use by any XDP socket.
>>
>> With this change:
>>
>>   # ip link del p1
>>   RTNETLINK answers: Device or resource busy
>>
>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>
>> Another option could be to force closing all the corresponding AF_XDP
>> sockets, but I didn't figure out how to do this properly yet.
>>
>>  include/linux/netdevice.h | 25 +++++++++++++++++++++++++
>>  net/core/dev.c            | 10 ++++++++++
>>  net/core/rtnetlink.c      |  6 ++++++
>>  net/xdp/xsk.c             |  7 ++++++-
>>  4 files changed, 47 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 44b47e9df94a..24451cfc5590 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -1705,6 +1705,7 @@ enum netdev_priv_flags {
>>   *	@watchdog_timer:	List of timers
>>   *
>>   *	@pcpu_refcnt:		Number of references to this device
>> + *	@pcpu_xdp_refcnt:	Number of XDP socket references to this device
>>   *	@todo_list:		Delayed register/unregister
>>   *	@link_watch_list:	XXX: need comments on this one
>>   *
>> @@ -1966,6 +1967,7 @@ struct net_device {
>>  	struct timer_list	watchdog_timer;
>>
>>  	int __percpu		*pcpu_refcnt;
>> +	int __percpu		*pcpu_xdp_refcnt;
>>  	struct list_head	todo_list;
> 
> 
> I understand the intention here, but don't think that putting a XDP reference
> into the generic netdev structure is the right way of doing this.  Likely the
> NETDEV_UNREGISTER notifier should be used so the socket and umem unbinds from
> the device.
> 

Thanks for the pointer! That is exactly what I looked for.
I'll make a new version that will unbind resources using netdevice notifier.

Best regards, Ilya Maximets.
