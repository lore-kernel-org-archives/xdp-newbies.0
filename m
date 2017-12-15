Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:52074 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932247AbdLOPxj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 15 Dec 2017 10:53:39 -0500
Date: Fri, 15 Dec 2017 10:53:38 -0500 (EST)
Message-Id: <20171215.105338.2092740911243038177.davem@davemloft.net>
Subject: Re: ixgbe tuning reset when XDP is setup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1513333486.28703.9.camel@regit.org>
References: <1513333486.28703.9.camel@regit.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: eric@regit.org
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, pmanev@stamus-networks.com

From: Eric Leblond <eric@regit.org>
Date: Fri, 15 Dec 2017 11:24:46 +0100

> Hello,
> 
> When using an ixgbe card with Suricata we are using the following
> commands to get a symmetric hash on RSS load balancing:
> 
> ./set_irq_affinity 0-15 eth3
> ethtool -X eth3 hkey 6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A equal 16
> ethtool -x eth3
> ethtool -n eth3
> 
> Then we start Suricata.
> 
> In my current experiment on XDP, I have Suricata that inject the eBPF
> program when starting. The consequence of that when using an ixgbe card
> is that the load balancing get reset and all interrupts are reaching
> the first core.

This definitely should _not_ be a side effect of enabling XDP on a device.
