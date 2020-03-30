Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from relay0141.mxlogin.com ([199.181.239.141]:44643 "EHLO
        relay0141.mxlogin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbgC3QQ4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 30 Mar 2020 12:16:56 -0400
Received: from filter004.mxroute.com ([149.28.56.236] 149.28.56.236.vultr.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by relay0141.mxlogin.com (ZoneMTA) with ESMTPSA id 1712c36a4a40000766.001
 for <xdp-newbies@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Mon, 30 Mar 2020 16:11:50 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter004.mxroute.com (Postfix) with ESMTPS id A816F3EDAB
        for <xdp-newbies@vger.kernel.org>; Mon, 30 Mar 2020 16:11:49 +0000 (UTC)
From: Christian Deacon <gamemann@gflclan.com>
Subject: Using AF_XDP To Modify Outgoing Packets
Message-ID: <7902d2f1-1c21-f3e8-5035-352bba130d50@gflclan.com>
Date: Mon, 30 Mar 2020 11:11:49 -0500
MIME-Version: 1.0
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: xdp-newbies@vger.kernel.org

Hey everyone,


I am fairly new to XDP and AF_XDP programming. Therefore, I apologize if 
this question sounds silly.


To my understanding, an XDP program cannot process outgoing packets 
since it doesn't support the TX path. However, I read that AF_XDP 
sockets support both receiving and transmitting packets inside the user 
space while achieving zero-copy. I am trying to create a C program that 
modifies outgoing packets on an interface and trying to do this the 
fastest way possible. Unfortunately, I cannot use IPTables for this.


I wanted to know if there is any way to use AF_XDP sockets to modify 
outgoing packets on an interface. I wasn't sure if the AF_XDP sockets 
only support receiving traffic from the XDP program when using the 
redirect function or not.


If this isn't possible, are there any plans to add TX path support into 
XDP in the future? I'm also not sure what else I can do to achieve fast 
packet processing for this. I looked into using standard AF_PACKET 
sockets. However, since that makes a copy of the packet from the kernel, 
I'd assume that's pretty slow and I'd have to find a way to block the 
original packets (probably doing something with IPTables). I might also 
look into DPDK, but I want to see if using AF_XDP sockets for outgoing 
packet processing is possible first because it looks like it's going to 
take a while to learn DPDK.


Any help is highly appreciated and thank you for your time!
