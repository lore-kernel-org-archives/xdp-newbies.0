Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:49992 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfE2QKG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 May 2019 12:10:06 -0400
Received: from smtp-3.sys.kth.se (localhost.localdomain [127.0.0.1])
        by smtp-3.sys.kth.se (Postfix) with ESMTP id 40C25A293
        for <xdp-newbies@vger.kernel.org>; Wed, 29 May 2019 18:03:09 +0200 (CEST)
Received: from smtp-3.sys.kth.se ([127.0.0.1])
        by smtp-3.sys.kth.se (smtp-3.sys.kth.se [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 4ALzcmj_Xn5U for <xdp-newbies@vger.kernel.org>;
        Wed, 29 May 2019 18:03:08 +0200 (CEST)
Received: from [130.237.20.142] (s2587.it.kth.se [130.237.20.142])
        by smtp-3.sys.kth.se (Postfix) with ESMTPSA id 88023A29F
        for <xdp-newbies@vger.kernel.org>; Wed, 29 May 2019 18:03:08 +0200 (CEST)
From: Tom Barbette <barbette@kth.se>
Subject: Bad XDP performance with mlx5
Message-ID: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
Date: Wed, 29 May 2019 18:03:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I've got a very simple eBPF program that counts packets per queue in a 
per-cpu map.

I use IPerf in TCP mode, I limit the CPU cores to 2 so performance is 
limited by CPU (always at 100%).

With a XL710 NIC 40G link, with the XDP program loaded, I get 32.5. 
Without I get ~33.3Gbps. Pretty similar, somehow expected.

With a ConnectX 5 100G link, I get ~33.3Gbps without the XDP program but 
~26 with it. The behavior seems similar with a simple XDP_PASS program.

Any idea why MLX5 driver behaves like this? perf top is not conclusive 
at first glance. I'd say check_object_size and 
copy_user_enhanced_fast_string rise up but the stack is unclear from where.

I use 5.1-rc3, compiled myself using Ubuntu 18.04's latest .config file.

Thanks,
Tom
