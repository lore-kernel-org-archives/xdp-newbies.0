Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:43794 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfFDH23 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 4 Jun 2019 03:28:29 -0400
From: Tom Barbette <barbette@kth.se>
Subject: Re: Bad XDP performance with mlx5
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
 <20190529191602.71eb6c87@carbon>
 <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
 <20190530094053.364b1147@carbon>
 <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
 <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
 <20190531181817.34039c9f@carbon>
 <19ca7cd9a878b2ecc593cd2838b8ae0412463593.camel@mellanox.com>
Message-ID: <9f116335-0fad-079b-4070-89f24af4ab55@kth.se>
Date: Tue, 4 Jun 2019 09:28:22 +0200
MIME-Version: 1.0
In-Reply-To: <19ca7cd9a878b2ecc593cd2838b8ae0412463593.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Saeed Mahameed <saeedm@mellanox.com>, "brouer@redhat.com" <brouer@redhat.com>
Cc: "toke@redhat.com" <toke@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>

Le 31/05/2019 à 20:06, Saeed Mahameed a écrit :
> 
> The question is, On the same packet rate/bandwidth do you see higher
> cpu utilization on mlx5 compared to other drivers? you have to compare
> apples to apples.
> 
I meant relative increase. Of course at 40G the XL710 is using less CPU, 
but activating XDP is nearly free. As XDP is purely per packet I would 
expect the cost of it to be similar. Eg, a few instructions per packet.


Thanks Jesper for looking into this!

I don't think I will be of much help further on this matter. My take out 
would be: as a first-time user looking into XDP after watching a dozen 
of XDP talks, I would have expected XDP default settings to be identical 
to SKB, so I don't have to watch out for a set of per-driver parameter 
checklist to avoid increasing my CPU consumption by 15% when inserting 
"a super efficient and light BPF program". But I understand it's not 
that easy...

Tom
