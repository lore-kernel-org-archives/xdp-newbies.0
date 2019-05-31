Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:40480 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaGvs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 May 2019 02:51:48 -0400
Subject: Re: Bad XDP performance with mlx5
From: Tom Barbette <barbette@kth.se>
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
 <20190529191602.71eb6c87@carbon>
 <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
 <20190530094053.364b1147@carbon>
 <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
Message-ID: <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
Date: Fri, 31 May 2019 08:51:43 +0200
MIME-Version: 1.0
In-Reply-To: <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org, =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>Saeed Mahameed <saeedm@mellanox.com>

CCing mlx5 maintainers and commiters of bce2b2b. TLDK: there is a huge 
CPU increase on CX5 when introducing a XDP program. See 
https://www.youtube.com/watch?v=o5hlJZbN4Tk&feature=youtu.be around 
0:40. We're talking something like 15% while it's near 0 for other 
drivers. The machine is a recent Skylake. For us it makes XDP unusable. 
Is that a known problem?

I wonder if it doesn't simply come from mlx5/en_main.c:

rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;

Which would be inline from my observation that memory access seems 
heavier. I guess this is for the XDP_TX case.

If this is indeed the problem. Any chance we can:
a) detect automatically that a program will not return XDP_TX (I'm not 
quite sure about what the BPF limitations allow to guess in advance) or
b) add a flag to such as XDP_FLAGS_NO_TX to avoid such hit in 
performance when not needed?

Thanks,

Tom
