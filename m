Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42036 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730363AbfFGXcB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 7 Jun 2019 19:32:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so1989385pff.9
        for <xdp-newbies@vger.kernel.org>; Fri, 07 Jun 2019 16:32:01 -0700 (PDT)
Date: Fri, 7 Jun 2019 16:31:56 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH bpf v2] xdp: fix hang while unregistering device bound
 to xdp socket
Message-ID: <20190607163156.12cd3418@cakuba.netronome.com>
In-Reply-To: <20190607173143.4919-1-i.maximets@samsung.com>
References: <CGME20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e@eucas1p1.samsung.com>
        <20190607173143.4919-1-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>

On Fri,  7 Jun 2019 20:31:43 +0300, Ilya Maximets wrote:
> +static int xsk_notifier(struct notifier_block *this,
> +			unsigned long msg, void *ptr)
> +{
> +	struct sock *sk;
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct net *net = dev_net(dev);
> +	int i, unregister_count = 0;

Please order the var declaration lines longest to shortest.
(reverse christmas tree)

> +	mutex_lock(&net->xdp.lock);
> +	sk_for_each(sk, &net->xdp.list) {
> +		struct xdp_sock *xs = xdp_sk(sk);
> +
> +		mutex_lock(&xs->mutex);
> +		switch (msg) {
> +		case NETDEV_UNREGISTER:

You should probably check the msg type earlier and not take all the
locks and iterate for other types..
