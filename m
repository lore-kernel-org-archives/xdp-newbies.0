Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from q2relay26.mxroute.com ([160.202.107.26]:33235 "EHLO
        q2relay26.mxroute.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVSHg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 22 Jan 2020 13:07:36 -0500
Received: from filter003.mxroute.com [168.235.111.26] (Authenticated sender: mN4UYu2MZsgR)
 by q2relay26.mxroute.com (ZoneMTA) with ESMTPSA id 16fce6b8a3400098e2.001
 for <xdp-newbies@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Wed, 22 Jan 2020 18:02:31 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id 829986003F
        for <xdp-newbies@vger.kernel.org>; Wed, 22 Jan 2020 18:02:30 +0000 (UTC)
From: Christian Deacon <gamemann@gflclan.com>
Subject: Measuring/Debugging XDP Performance
Message-ID: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
Date: Wed, 22 Jan 2020 12:02:23 -0600
MIME-Version: 1.0
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: xdp-newbies@vger.kernel.org

Hey everyone,

I am new to XDP + AF_XDP (along with C programming in general), but I am 
very interested in it and I've been learning a lot recently. I own an 
Anycast network and our POP servers are running custom software our 
developer created that processes packets using XDP. This software 
basically forwards specific traffic to another machine via an IPIP 
tunnel. One issue I've been noticing is the packets our software is 
processing and forwarding to another machine keep dropping at higher 
traffic loads. I can't tell if this is dropping at the POP level or if 
the machine the software is forwarding this specific traffic to is. I've 
even tried upgrading the POP server from a two-core VPS (2.5 GHz CPUs) 
to a dedicated server (Intel E3-1230v6 @ 3.5 GHz, 4 cores, and 8 
threads). If this is being dropped at the POP level, I'm wondering if 
the software is being limited to one core on this specific POP (other 
POPs are able to use more than one core specifically). However, I have 
no way to confirm that. To my understanding XDP programs should be able 
to use more than one core.

My questions are the following:

1. Is there a way to see how much CPU the XDP program is using or the 
load of the NIC? To my understanding, you cannot tell the XDP program's 
CPU usage based off of something like `top` or `htop` due to that being 
in the user space (XDP happens at the NIC driver level in the kernel IIRC).

2. Are there any known bugs with XDP somehow being limited to one core 
(e.g. not multi-threaded)? The POP is running Ubuntu 18.04 on kernel 
'4.18.0-25'. The AF_XDP part of the software is also using `pthreads` 
and from what I saw, using them correctly. However, not much traffic 
gets forwarded to the AF_XDP program. Therefore, I doubt that's even an 
issue. I wasn't able to find any known bugs when researching this, but 
figured I'd ask this question just in case there's something I missed.

I would like to note that the NIC has 4 RX queues and the software makes 
use of all four. I'm not sure if that would make a difference or not.

If you need any additional information, please let me know.

Any help is highly appreciated!

Thank you for your time.
