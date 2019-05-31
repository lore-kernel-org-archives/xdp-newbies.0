Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:47390 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfEaSAv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 May 2019 14:00:51 -0400
Date: Fri, 31 May 2019 11:00:50 -0700 (PDT)
Message-Id: <20190531.110050.517935401011629843.davem@davemloft.net>
Subject: Re: Bad XDP performance with mlx5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190531181817.34039c9f@carbon>
References: <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
        <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
        <20190531181817.34039c9f@carbon>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: barbette@kth.se, xdp-newbies@vger.kernel.org, toke@redhat.com, saeedm@mellanox.com, leonro@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 31 May 2019 18:18:17 +0200

> On Fri, 31 May 2019 08:51:43 +0200 Tom Barbette <barbette@kth.se> wrote:
> 
>> I wonder if it doesn't simply come from mlx5/en_main.c:
>> rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
>> 
> 
> Nope, that is not the problem.

And it's easy to test this theory by forcing DMA_FROM_DEVICE.
