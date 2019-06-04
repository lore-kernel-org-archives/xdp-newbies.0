Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfFDJQB (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 4 Jun 2019 05:16:01 -0400
Date: Tue, 4 Jun 2019 11:15:54 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Bad XDP performance with mlx5
Message-ID: <20190604111554.749ddd87@carbon>
In-Reply-To: <9f116335-0fad-079b-4070-89f24af4ab55@kth.se>
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
        <20190529191602.71eb6c87@carbon>
        <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
        <20190530094053.364b1147@carbon>
        <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
        <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
        <20190531181817.34039c9f@carbon>
        <19ca7cd9a878b2ecc593cd2838b8ae0412463593.camel@mellanox.com>
        <9f116335-0fad-079b-4070-89f24af4ab55@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Tom Barbette <barbette@kth.se>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "toke@redhat.com" <toke@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, brouer@redhat.com, =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Tue, 4 Jun 2019 09:28:22 +0200
Tom Barbette <barbette@kth.se> wrote:

> Thanks Jesper for looking into this!
> 
> I don't think I will be of much help further on this matter. My take
> out would be: as a first-time user looking into XDP after watching a
> dozen of XDP talks, I would have expected XDP default settings to be
> identical to SKB, so I don't have to watch out for a set of
> per-driver parameter checklist to avoid increasing my CPU consumption
> by 15% when inserting "a super efficient and light BPF program". But
> I understand it's not that easy...

The gap should not be this large, but as I demonstrated it was primarily
because you hit an unfortunate interaction with TCP and how the mlx5
driver does page-caching (p.s. we are working on removing this driver
local recycle-cache).
  When loading an XDP/eBPF-prog then the driver change the underlying RX
memory model, which waste memory to gain packets-per-sec speed, but TCP
sees this memory waste and gives us a penalty.

It is important to understand, that XDP is not optimized for TCP.  XDP
is designed and optimized for L2-L3 handling of packets (TCP is L4).
Before XDP these L2-L3 use-cases were "slow", because the kernel
netstack assumes a L4/socket use-case (full SKB), when less was really
needed.

This is actually another good example of why XDP programs per RX-queue,
will be useful (notice: which is not implemented upstream, yet...).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
