Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:60899
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfGWLVu (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 23 Jul 2019 07:21:50 -0400
From: Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Date: Tue, 23 Jul 2019 11:21:45 +0000
Message-ID: <535ebf16-c523-0799-3ffe-6cfbeee3ac57@mellanox.com>
References: <20190708125554.3863901-1-arnd@arndb.de>
 <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
In-Reply-To: <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <B63C6DA5B42A7848A8663B1C887CCD32@eurprd05.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Tariq Toukan <tariqt@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>

On 2019-07-08 18:16, Maxim Mikityanskiy wrote:
> On 2019-07-08 15:55, Arnd Bergmann wrote:
>> -	mlx5e_build_xsk_cparam(priv, params, xsk, &cparam);
>> +	cparam = kzalloc(sizeof(*cparam), GFP_KERNEL);
> 
> Similar code in mlx5e_open_channels (en_main.c) uses kvzalloc. Although
> the struct is currently smaller than a page anyway, and there should be
> no difference in behavior now, I suggest using the same alloc function
> to keep code uniform.
> 
>>    	/* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
>>    	 * triggered and NAPI to be called on the correct CPU.
>>    	 */
>> -	err = mlx5e_open_icosq(c, params, &cparam.icosq, &c->xskicosq);
>> +	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
>>    	if (unlikely(err))
>>    		goto err_close_icocq;
>>    
> 
> Here is kfree missing. It's a memory leak in the good path.

Arnd, I'm going to take over your patch and respin it, addressing my own 
comments, because it's been quite a while, and we want to have this fix.

Thanks for spotting it.
