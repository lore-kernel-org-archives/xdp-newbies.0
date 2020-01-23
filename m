Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from q2relay90.mxroute.com ([160.202.107.90]:34337 "EHLO
        q2relay90.mxroute.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgAWRWl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Jan 2020 12:22:41 -0500
Received: from filter003.mxroute.com [168.235.111.26] (Authenticated sender: mN4UYu2MZsgR)
 by q2relay90.mxroute.com (ZoneMTA) with ESMTPSA id 16fd36d5c4a00198e2.001
 for <xdp-newbies@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Thu, 23 Jan 2020 17:22:37 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id 927136003E
        for <xdp-newbies@vger.kernel.org>; Thu, 23 Jan 2020 17:22:35 +0000 (UTC)
Subject: Re: Measuring/Debugging XDP Performance
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
 <20200123141122.3783e298@carbon>
From: Christian Deacon <gamemann@gflclan.com>
Message-ID: <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
Date: Thu, 23 Jan 2020 11:22:31 -0600
MIME-Version: 1.0
In-Reply-To: <20200123141122.3783e298@carbon>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org

Hey Vincent and Jesper,

Thank you for the information and I will try these commands tonight when 
there is higher traffic load! The 'perf' command seems interesting.

Jesper, I do believe my kernel supports BPF Trace. I was able to use 
this function in our software while I was debugging it for a separate 
issue that I resolved earlier this week. With that said, the IPIP 
traffic is handled in the XDP program. We only redirect a certain packet 
to the AF_XDP program so it can be cached via a Redis server (needed in 
the user space). However, this doesn't happen that often and other 
packets handled by the XDP program itself are being dropped. Therefore, 
I doubt the AF_XDP program is causing anything.

Thank you!

On 1/23/2020 7:11 AM, Jesper Dangaard Brouer wrote:
> On Wed, 22 Jan 2020 12:02:23 -0600
> Christian Deacon <gamemann@gflclan.com> wrote:
>
>> Hey everyone,
>>
>> I am new to XDP + AF_XDP (along with C programming in general), but I am
>> very interested in it and I've been learning a lot recently. I own an
>> Anycast network and our POP servers are running custom software our
>> developer created that processes packets using XDP. This software
>> basically forwards specific traffic to another machine via an IPIP
>> tunnel.
> Why are you using AF_XDP to implement a simple IPIP tunnel header?
>
> You can easily implement it in BPF.
> Example here:
>   https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_tx_iptunnel_kern.c#L110-L112
