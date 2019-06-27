Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56346 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfF0HXg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 27 Jun 2019 03:23:36 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190627072334euoutp01306211fb94c4c46758ed8781ffba7042~r-U_xRYv00403804038euoutp01O
        for <xdp-newbies@vger.kernel.org>; Thu, 27 Jun 2019 07:23:34 +0000 (GMT)
Subject: Re: [PATCH bpf v4 2/2] xdp: fix hang while unregistering device
 bound to xdp socket
From: Ilya Maximets <i.maximets@samsung.com>
Message-ID: <30d4e214-f53b-ac2d-e7f7-99bbd7b96b8f@samsung.com>
Date: Thu, 27 Jun 2019 10:23:27 +0300
MIME-Version: 1.0
In-Reply-To: <20190626113427.761cc845@cakuba.netronome.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <20190626181515.1640-1-i.maximets@samsung.com>
        <CGME20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826@eucas1p1.samsung.com>
        <20190626181515.1640-3-i.maximets@samsung.com>
        <20190626113427.761cc845@cakuba.netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>

On 26.06.2019 21:34, Jakub Kicinski wrote:
> On Wed, 26 Jun 2019 21:15:15 +0300, Ilya Maximets wrote:
>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>> index 267b82a4cbcf..56729e74cbea 100644
>> --- a/net/xdp/xdp_umem.c
>> +++ b/net/xdp/xdp_umem.c
>> @@ -140,34 +140,38 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
>>  	return err;
>>  }
>>  
>> -static void xdp_umem_clear_dev(struct xdp_umem *umem)
>> +void xdp_umem_clear_dev(struct xdp_umem *umem)
>>  {
>> +	bool lock = rtnl_is_locked();
> 
> How do you know it's not just locked by someone else?  You need to pass
> the locked state in if this is called from different paths, some of
> which already hold rtnl.

Oh. That's a shame. I need more sleep.

Thanks for spotting. I'll re-work this part.

Best regards, Ilya Maximets.

> 
> Preferably factor the code which needs the lock out into a separate
> function like this:
> 
> void __function()
> {
> 	do();
> 	the();
> 	things();
> 	under();
> 	the();
> 	lock();
> }
> 
> void function()
> {
> 	rtnl_lock();
> 	__function();
> 	rtnl_unlock();
> }
> 
>>  	struct netdev_bpf bpf;
>>  	int err;
>>  
>> +	if (!lock)
>> +		rtnl_lock();
> 
> 
> 
