Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from relay0114.mxlogin.com ([199.181.239.114]:37475 "EHLO
        relay0114.mxlogin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgEXSNc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 24 May 2020 14:13:32 -0400
Received: from filter003.mxroute.com ([168.235.111.26] 168-235-111-26.cloud.ramnode.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by relay0114.mxlogin.com (ZoneMTA) with ESMTPSA id 17247e3cee800054f2.001
 for <xdp-newbies@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Sun, 24 May 2020 18:13:31 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id 6958160013
        for <xdp-newbies@vger.kernel.org>; Sun, 24 May 2020 18:13:30 +0000 (UTC)
Subject: Re: AF_XDP Side Of Project Breaking With XDP-Native
References: <50fe1ab5-55e7-980b-54d4-cd1d5e864865@gflclan.com>
 <20200522175136.5a6fdc55@carbon>
 <cd32e639-018e-2346-9570-f2167dfe651e@gflclan.com>
 <6709130c-a676-127d-ac9d-d0ab35397b0d@gmail.com>
From: Christian Deacon <gamemann@gflclan.com>
Message-ID: <2ed7d441-1a98-b4c1-8799-733ae286ed5e@gflclan.com>
Date: Sun, 24 May 2020 13:13:27 -0500
MIME-Version: 1.0
In-Reply-To: <6709130c-a676-127d-ac9d-d0ab35397b0d@gmail.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: David Ahern <dsahern@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org

Hey David,


Thank you for your response!


The VM only has one CPU right now. It's possible the cluster has 8 RX 
queues I'd imagine, but I don't have that information sadly. I executed 
the same command on another VM I have with two CPUs (not being used for 
the XDP-native testing):


```

root@Test:~# ethtool -l ens3
Channel parameters for ens3:
Pre-set maximums:
RX:             0
TX:             0
Other:          0
Combined:       8
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       2
```


I did receive this from my hosting provider when asking which NIC driver 
they use:


```

Hello,

Thanks for your inquiry.

We do not pass through the host node's NIC to your VPS.

Because of that, it's not relevant what NIC driver we are using on our 
host nodes.

Thanks for your patience.

```


To my understanding, if the NIC isn't offloading packets directly to our 
VPS, wouldn't this destroy the purpose of using XDP-native over 
XDP-generic/SKB mode for performance in our case? I was under the 
assumption that was the point of XDP-native. If so, I'm not sure why the 
program is loading with XDP-native without any issues besides the AF_XDP 
program.


I will admit I've been wondering what the difference is between 
`XDP_FLAGS_DRV_MODE` (XDP-native) and `XDP_FLAGS_HW_MODE` since I 
thought XDP-native was offloading packets from the NIC.


Thank you for the help!


On 5/24/2020 12:35 PM, David Ahern wrote:
> On 5/22/20 10:12 AM, Christian Deacon wrote:
>> Hey Jesper,
>>
>>
>> I apologize for not providing that information before. The driver is
>> `virtio_net`. Unfortunately, I'm not sure what the NIC driver on the
>> cluster is. Once my program's code is confirmed to be correct, I will
>> try reaching out to our hosting provider to see if they can provide this
>> information if the NIC's driver is the suspected cause to this issue.
>>
>> ```
>>
>> root@SEAV21:~/AF_XDP-Test# ethtool -i ens3
>> driver: virtio_net
>> version: 1.0.0
>> firmware-version:
>> expansion-rom-version:
>> bus-info: 0000:00:03.0
>> supports-statistics: yes
>> supports-test: no
>> supports-eeprom-access: no
>> supports-register-dump: no
>> supports-priv-flags: no
>> ```
>>
>>
> Is this a 4-cpu VM or 8 cpu VM?
>
> A previous response had:
>
> root@SEAV21:~/AF_XDP-Test# ethtool -l ens3
> Channel parameters for ens3:
> Pre-set maximums:
> RX:             0
> TX:             0
> Other:          0
> Combined:       8
> Current hardware settings:
> RX:             0
> TX:             0
> Other:          0
> Combined:       1
>
> The 8 for pre-set max says the nic has 8 queues. If it is a 4-vcpu vm,
> then try
>
> ethtool -L ens3 combined 4
>
> which leaves 4 for xdp. If it is an 8 cpu VM I believe you are out of
> luck given current requirements.
