Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:42312 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932247AbdLOQDS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 15 Dec 2017 11:03:18 -0500
Subject: Re: ixgbe tuning reset when XDP is setup
References: <1513333486.28703.9.camel@regit.org>
 <20171215.105338.2092740911243038177.davem@davemloft.net>
From: John Fastabend <john.fastabend@gmail.com>
Message-ID: <c677440b-46c5-e32b-5038-21a760ba738b@gmail.com>
Date: Fri, 15 Dec 2017 08:03:01 -0800
MIME-Version: 1.0
In-Reply-To: <20171215.105338.2092740911243038177.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>, eric@regit.org
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, pmanev@stamus-networks.com, Alexander Duyck <alexander.duyck@gmail.com>, Emil Tantilov <emil.s.tantilov@intel.com>

On 12/15/2017 07:53 AM, David Miller wrote:
> From: Eric Leblond <eric@regit.org>
> Date: Fri, 15 Dec 2017 11:24:46 +0100
> 
>> Hello,
>>
>> When using an ixgbe card with Suricata we are using the following
>> commands to get a symmetric hash on RSS load balancing:
>>
>> ./set_irq_affinity 0-15 eth3
>> ethtool -X eth3 hkey 6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A:6D:5A equal 16
>> ethtool -x eth3
>> ethtool -n eth3
>>
>> Then we start Suricata.
>>
>> In my current experiment on XDP, I have Suricata that inject the eBPF
>> program when starting. The consequence of that when using an ixgbe card
>> is that the load balancing get reset and all interrupts are reaching
>> the first core.
> 
> This definitely should _not_ be a side effect of enabling XDP on a device.
> 

Agreed, CC Emil and Alex we should restore these settings after the
reconfiguration done to support a queue per core.

.John
