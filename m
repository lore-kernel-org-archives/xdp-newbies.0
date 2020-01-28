Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from qrelay22.mxroute.com ([172.82.139.22]:45615 "EHLO
        qrelay22.mxroute.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726162AbgA1TBC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Jan 2020 14:01:02 -0500
Received: from filter003.mxroute.com [168.235.111.26] (Authenticated sender: mN4UYu2MZsgR)
 by qrelay22.mxroute.com (ZoneMTA) with ESMTPA id 16fed829c7c000f036.001
 for <xdp-newbies@vger.kernel.org>;
 Tue, 28 Jan 2020 18:55:57 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id 8930E60012
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Jan 2020 18:55:56 +0000 (UTC)
Subject: Re: Measuring/Debugging XDP Performance
From: Christian Deacon <gamemann@gflclan.com>
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
 <20200123141122.3783e298@carbon>
 <23ec64c0-e0d7-a60b-ecc4-6ca401dc4896@gflclan.com>
 <20200123213808.7a1f200b@carbon>
 <fdd597bf-7da9-f9bd-d97f-f1bd90f14281@gflclan.com>
Message-ID: <f5242b7e-6c26-8682-9bc6-61f39497ca8e@gflclan.com>
Date: Tue, 28 Jan 2020 12:55:51 -0600
MIME-Version: 1.0
In-Reply-To: <fdd597bf-7da9-f9bd-d97f-f1bd90f14281@gflclan.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

Hey everyone,


The only NIC our hosting provider could replace our old NIC with is=20
using the `e1000e` driver (it's a one gigabit NIC card). I dug through=20
some older mailing list threads and read XDP isn't very effective with=20
one gigabit NICs (the preferred minimum is 10 gbps IIRC). These were=20
threads from 2017 and I'm not sure if this is still the case. However,=20
if it is, I'm still hoping I can use XDP, but hopefully have the=20
performance equal to the network stack at the very least.


I understand the `e1000e` driver doesn't have XDP support upstream.=20
Therefore, I tried implementing the driver patch that adds XDP support here=
:


https://github.com/adjavon/e1000e_xdp


Unfortunately, this patch was based off of kernel 4.10.2 (I'm using=20
4.19). Therefore, I had to manually implement the patch code (this is my=20
first time messing with NIC driver code). Sadly, it doesn't seem like=20
the patch worked based off of the 'perf' results which are linked below.=20
I still see "do_xdp_generic" calls:


```

xxx@xxx/xxxx/xxxx# cat results_2.log | grep "xdp"
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 do_xdp_generic
 =C2=A0=C2=A0=C2=A0=C2=A0 0.33%=C2=A0 006=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
do_xdp_generic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
 =C2=A0=C2=A0=C2=A0=C2=A0 0.09%=C2=A0 006=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
bpf_xdp_adjust_head=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -
 =C2=A0=C2=A0=C2=A0=C2=A0 0.09%=C2=A0 005=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
do_xdp_generic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
 =C2=A0=C2=A0=C2=A0=C2=A0 0.07%=C2=A0 006=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
generic_xdp_tx=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
 =C2=A0=C2=A0=C2=A0=C2=A0 0.07%=C2=A0 004=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
do_xdp_generic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
 =C2=A0=C2=A0=C2=A0=C2=A0 0.05%=C2=A0 003=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
do_xdp_generic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
 =C2=A0=C2=A0=C2=A0=C2=A0 0.02%=C2=A0 004=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
generic_xdp_tx=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
 =C2=A0=C2=A0=C2=A0=C2=A0 0.01%=C2=A0 005=C2=A0 swapper=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [kernel.kallsyms]=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 [k]=20
generic_xdp_tx=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
```


With that said, it appears my other POP servers that are using the=20
"virtio_net" NIC driver are using XDP generic according to the 'perf'=20
results as well (they're similar to the above). They're also on kernel 4.18=
.


My question is, how would you know if you're using XDP-native or not? Is=20
it possible you're still using XDP-native, even when there are XDP=20
generic calls from the 'perf' command?


Here's a link to the outputs of the 'perf' command discussed above for=20
anyone interested:


https://g.gflclan.com/6sHmHPlo3W.zip


Any help is highly appreciated and thank you for your time!


On 1/23/2020 3:38 PM, Christian Deacon wrote:
> Hey Jesper,
>
>
> Thank you for the information and that makes a lot more sense! I=20
> didn't realize we had a NIC that doesn't support XDP-native. I will=20
> see if I can get a better NIC card for this dedicated server (I don't=20
> believe our current NIC card supports any other drivers besides `igb`).
>
>
> In the meantime, I have stopped announcing my dedicated server to our=20
> Anycast network and have started announcing the four-core VPS that had=20
> similar issues before ordering the dedicated server (even though I=20
> feel this VPS should be able to handle the traffic load). The CPU is=20
> virtualized and running at 2.5 GHz per core. The VPS's OS is Ubuntu=20
> 18.10 and the kernel is '4.18.0-20'. The NIC driver is "virtio-pci",=20
> which I believe is supported (please correct me if I'm wrong, I do see=20
> 'virtio_net' in the list of supported XDP drivers which I'd assume is=20
> the same thing).
>
>
> I will execute the 'perf' commands tonight when we have higher traffic=20
> load and reply with the output.
>
>
> Thank you for your help!
>
>
> On 1/23/2020 2:38 PM, Jesper Dangaard Brouer wrote:
>> On Thu, 23 Jan 2020 11:22:31 -0600
>> Christian Deacon <gamemann@gflclan.com> wrote:
>>
>>> Thank you for the information and I will try these commands tonight=20
>>> when
>>> there is higher traffic load! The 'perf' command seems interesting.
>> Thanks for the perf output in the private email thread. From the output
>> I can clearly see the problem (some copy pasted below signature).=C2=A0 =
You
>> are using the driver igb which does not support XDP-native, and is thus
>> using generic-XDP.
>>
>> This driver only have 192 bytes headroom, where 256 is needed. Thus,
>> running XDP-generic will be slower than running the normal network
>> stack, as every packet will get reallocated and copied.
>>
