Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from q2relay107.mxroute.com ([160.202.107.107]:35955 "EHLO
        q2relay107.mxroute.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWVnx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Jan 2020 16:43:53 -0500
Received: from filter003.mxroute.com [168.235.111.26] (Authenticated sender: mN4UYu2MZsgR)
 by q2relay107.mxroute.com (ZoneMTA) with ESMTPSA id 16fd457ecec00098e2.001
 for <xdp-newbies@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Thu, 23 Jan 2020 21:38:49 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id C260A6003E
        for <xdp-newbies@vger.kernel.org>; Thu, 23 Jan 2020 21:38:47 +0000 (UTC)
Subject: Re: Measuring/Debugging XDP Performance
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
 <20200123141122.3783e298@carbon>
 <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
 <20200123213808.7a1f200b@carbon>
From: Christian Deacon <gamemann@gflclan.com>
Message-ID: <fdd597bf-7da9-f9bd-d97f-f1bd90f14281@gflclan.com>
Date: Thu, 23 Jan 2020 15:38:43 -0600
MIME-Version: 1.0
In-Reply-To: <20200123213808.7a1f200b@carbon>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org

Hey Jesper,


Thank you for the information and that makes a lot more sense! I didn't 
realize we had a NIC that doesn't support XDP-native. I will see if I 
can get a better NIC card for this dedicated server (I don't believe our 
current NIC card supports any other drivers besides `igb`).


In the meantime, I have stopped announcing my dedicated server to our 
Anycast network and have started announcing the four-core VPS that had 
similar issues before ordering the dedicated server (even though I feel 
this VPS should be able to handle the traffic load). The CPU is 
virtualized and running at 2.5 GHz per core. The VPS's OS is Ubuntu 
18.10 and the kernel is '4.18.0-20'. The NIC driver is "virtio-pci", 
which I believe is supported (please correct me if I'm wrong, I do see 
'virtio_net' in the list of supported XDP drivers which I'd assume is 
the same thing).


I will execute the 'perf' commands tonight when we have higher traffic 
load and reply with the output.


Thank you for your help!


On 1/23/2020 2:38 PM, Jesper Dangaard Brouer wrote:
> On Thu, 23 Jan 2020 11:22:31 -0600
> Christian Deacon <gamemann@gflclan.com> wrote:
>
>> Thank you for the information and I will try these commands tonight when
>> there is higher traffic load! The 'perf' command seems interesting.
> Thanks for the perf output in the private email thread. From the output
> I can clearly see the problem (some copy pasted below signature).  You
> are using the driver igb which does not support XDP-native, and is thus
> using generic-XDP.
>
> This driver only have 192 bytes headroom, where 256 is needed.  Thus,
> running XDP-generic will be slower than running the normal network
> stack, as every packet will get reallocated and copied.
>
