Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from qrelay90.mxroute.com ([172.82.139.90]:45581 "EHLO
        qrelay90.mxroute.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726948AbgA3Oxu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 30 Jan 2020 09:53:50 -0500
Received: from filter003.mxroute.com [168.235.111.26] (Authenticated sender: mN4UYu2MZsgR)
 by qrelay90.mxroute.com (ZoneMTA) with ESMTPA id 16ff6f19509000f036.001
 for <xdp-newbies@vger.kernel.org>;
 Thu, 30 Jan 2020 14:53:45 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id 1542A60045
        for <xdp-newbies@vger.kernel.org>; Thu, 30 Jan 2020 14:53:44 +0000 (UTC)
Subject: Re: Measuring/Debugging XDP Performance
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
 <20200123141122.3783e298@carbon>
 <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
 <20200123213808.7a1f200b@carbon>
 <fdd597bf-7da9-f9bd-d97f-f1bd90f14281@gflclan.com>
 <b1d478e6-555c-97da-f967-4f10f879f589@gflclan.com>
 <20200129152624.2d0dde2a@carbon>
From: Christian Deacon <gamemann@gflclan.com>
Message-ID: <b124306c-6f88-bdf8-81a8-b1410625b0ef@gflclan.com>
Date: Thu, 30 Jan 2020 08:53:43 -0600
MIME-Version: 1.0
In-Reply-To: <20200129152624.2d0dde2a@carbon>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org

Hey Jesper and Matheus,

Thank you for the information and assistance! I really appreciate it!

Matheus, I was able to confirm that my POP servers (running as VPSs with 
the "virtio_net" driver) are indeed using XDP generic based off of the 
command you provided. I didn't realize it included "xdpgeneric" on the 
link list. This is definitely an easier way to tell if you're using XDP 
generic compared to looking at the 'perf' results.

Jesper, thank you for those two patches! I've recompiled the 4.19 kernel 
with those implemented and have it running on my POP server now. I've 
started announcing the POP server to the network again and I will let 
you know how it goes along with getting results from the 'perf' command. 
Do you think it would be worth trying to implement XDP support into the 
`igb` driver? I understand if it can't be supported officially, but once 
I gain more experience, etc. I might give it a try if it would increase 
performance.

I figured the physical NIC card used to host the VPSs would need to 
support XDP-native, but I just wanted to make sure. I tried asking my 
hosting provider if the NIC card uses a driver that is on the XDP-native 
supported list. They came back stating some nodes do and some do not, 
sadly. What type of offloads would need to be disabled in order to get 
it working (in the case the node's NIC driver does support XDP-native)?

Thank you for your time.


On 1/29/2020 8:26 AM, Jesper Dangaard Brouer wrote:
> On Tue, 28 Jan 2020 12:42:21 -0600
> Christian Deacon <gamemann@gflclan.com> wrote:
>
>> With that said, it appears my other POP servers that are using the
>> "virtio_net" NIC driver are using XDP generic according to the 'perf'
>> results as well (they're similar to the above). They're also on
>> kernel 4.18.
> First of all 'virtio_net' is tricky to get working with 'native-XDP',
> because you need to disable a number of offloads.  This have gotten a
> bit easier on newer kernels.
>
> That said, it is important to understand that getting raw "fast" frames
> into your "virtio_net" virtual netcard is a two-stage "rocket".   The
> owner of the hardware box also need a native-XDP netcard that runs XDP
> which XDP-redirect frames into your virtual NIC, else there is not
> performance advantage.
>
