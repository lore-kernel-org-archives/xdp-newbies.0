Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37450 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387808AbfFJIFr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Jun 2019 04:05:47 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190610080545euoutp013e6728051b659cbdfafec243c82fd0b7~mx79Mtv0A3083030830euoutp01z
        for <xdp-newbies@vger.kernel.org>; Mon, 10 Jun 2019 08:05:45 +0000 (GMT)
Subject: Re: [PATCH bpf v2] xdp: fix hang while unregistering device bound
 to xdp socket
From: Ilya Maximets <i.maximets@samsung.com>
Message-ID: <d8b2bc92-3b7e-dfe7-35ee-61a68d46ff02@samsung.com>
Date: Mon, 10 Jun 2019 11:05:41 +0300
MIME-Version: 1.0
In-Reply-To: <20190607163156.12cd3418@cakuba.netronome.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e@eucas1p1.samsung.com>
        <20190607173143.4919-1-i.maximets@samsung.com>
        <20190607163156.12cd3418@cakuba.netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>

On 08.06.2019 2:31, Jakub Kicinski wrote:
> On Fri,  7 Jun 2019 20:31:43 +0300, Ilya Maximets wrote:
>> +static int xsk_notifier(struct notifier_block *this,
>> +			unsigned long msg, void *ptr)
>> +{
>> +	struct sock *sk;
>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +	struct net *net = dev_net(dev);
>> +	int i, unregister_count = 0;
> 
> Please order the var declaration lines longest to shortest.
> (reverse christmas tree)

Hi.
I'm not a fan of mixing 'struct's with bare types in the declarations.
Moving the 'sk' to the third place will make a hole like this:

	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
	struct net *net = dev_net(dev);
	struct sock *sk;
	int i, unregister_count = 0;

Which is not looking good.
Moving to the 4th place:

	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
	struct net *net = dev_net(dev);
	int i, unregister_count = 0;
	struct sock *sk;

This variant doesn't look good for me because of mixing 'struct's with
bare integers.

Do you think I need to use one of above variants?

> 
>> +	mutex_lock(&net->xdp.lock);
>> +	sk_for_each(sk, &net->xdp.list) {
>> +		struct xdp_sock *xs = xdp_sk(sk);
>> +
>> +		mutex_lock(&xs->mutex);
>> +		switch (msg) {
>> +		case NETDEV_UNREGISTER:
> 
> You should probably check the msg type earlier and not take all the
> locks and iterate for other types..

Yeah. I thought about it too. Will fix in the next version.

Best regards, Ilya Maximets.
