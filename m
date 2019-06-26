Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44241 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfFZSed (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 26 Jun 2019 14:34:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id p144so2504189qke.11
        for <xdp-newbies@vger.kernel.org>; Wed, 26 Jun 2019 11:34:33 -0700 (PDT)
Date: Wed, 26 Jun 2019 11:34:27 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH bpf v4 2/2] xdp: fix hang while unregistering device
 bound to xdp socket
Message-ID: <20190626113427.761cc845@cakuba.netronome.com>
In-Reply-To: <20190626181515.1640-3-i.maximets@samsung.com>
References: <20190626181515.1640-1-i.maximets@samsung.com>
        <CGME20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826@eucas1p1.samsung.com>
        <20190626181515.1640-3-i.maximets@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Maximets <i.maximets@samsung.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>

On Wed, 26 Jun 2019 21:15:15 +0300, Ilya Maximets wrote:
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 267b82a4cbcf..56729e74cbea 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -140,34 +140,38 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
>  	return err;
>  }
>  
> -static void xdp_umem_clear_dev(struct xdp_umem *umem)
> +void xdp_umem_clear_dev(struct xdp_umem *umem)
>  {
> +	bool lock = rtnl_is_locked();

How do you know it's not just locked by someone else?  You need to pass
the locked state in if this is called from different paths, some of
which already hold rtnl.

Preferably factor the code which needs the lock out into a separate
function like this:

void __function()
{
	do();
	the();
	things();
	under();
	the();
	lock();
}

void function()
{
	rtnl_lock();
	__function();
	rtnl_unlock();
}

>  	struct netdev_bpf bpf;
>  	int err;
>  
> +	if (!lock)
> +		rtnl_lock();
