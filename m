Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:45210 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751315AbdLOKzL (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 15 Dec 2017 05:55:11 -0500
Message-ID: <1513333486.28703.9.camel@regit.org>
Subject: ixgbe tuning reset when XDP is setup
From: Eric Leblond <eric@regit.org>
Date: Fri, 15 Dec 2017 11:24:46 +0100
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org
Cc: Peter Manev <pmanev@stamus-networks.com>

Hello,

When using an ixgbe card with Suricata we are using the following
commands to get a symmetric hash on RSS load balancing:

./set_irq_affinity 0-15 eth3
ethtool -X eth3 hkey 6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A equal 16
ethtool -x eth3
ethtool -n eth3

Then we start Suricata.

In my current experiment on XDP, I have Suricata that inject the eBPF
program when starting. The consequence of that when using an ixgbe card
is that the load balancing get reset and all interrupts are reaching
the first core.

My analysis is that in the ixgbe_xdp_setup() function we call
ixgbe_setup_tc() that reset the hash tuning parameter.

If we run the affinity script and the ethtool commands after XDP is
loaded then things are going normal again. But this is not an optimal
behavior.

Is this really what is happening ? Is there a known workaround for this
issue ?

BR,
-- 
Eric Leblond <eric@regit.org>
