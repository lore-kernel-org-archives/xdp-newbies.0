Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:58850 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfE3I4A (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 30 May 2019 04:56:00 -0400
Subject: Re: Bad XDP performance with mlx5
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
 <20190529191602.71eb6c87@carbon>
 <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
 <20190530094053.364b1147@carbon>
From: Tom Barbette <barbette@kth.se>
Message-ID: <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
Date: Thu, 30 May 2019 10:55:51 +0200
MIME-Version: 1.0
In-Reply-To: <20190530094053.364b1147@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org, =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>

Le 30/05/2019 à 09:40, Jesper Dangaard Brouer a écrit :
>> server$ sudo ethtool -X dpdk1 equal 2
> 
> Interesting use of ethtool -X (Set Rx flow hash indirection table), I
> could use that myself in some of my tests.  I usually change the number
> of RX-queue via ethtool -L (or --set-channels), which the i40e/XL710
> have issues with...

Yes and it doesn't kill the existing queues for multiple seconds, and 
keeps the affinity of the IRQs.

> 
> What SMP affinity script are you using?
> 
> The mellanox drivers uses another "layout"/name-scheme
> in /proc/irq/*/*name*/../smp_affinity_list.
> 
> Normal Intel based nics I use this:
> 
> echo " --- Align IRQs ---"
> # I've named my NICs ixgbe1 + ixgbe2
> for F in /proc/irq/*/ixgbe*-TxRx-*/../smp_affinity_list; do
>     # Extract irqname e.g. "ixgbe2-TxRx-2"
>     irqname=$(basename $(dirname $(dirname $F))) ;
>     # Substring pattern removal
>     hwq_nr=${irqname#*-*-}
>     echo $hwq_nr > $F
>     #grep . -H $F;
> done
> grep -H . /proc/irq/*/ixgbe*/../smp_affinity_list
> 
> But for Mellanox I had to use this:
> 
> echo " --- Align IRQs : mlx5 ---"
> for F in /proc/irq/*/mlx5_comp*/../smp_affinity; do
>          dir=$(dirname $F) ;
>          cat $dir/affinity_hint > $F
> done
> grep -H . /proc/irq/*/mlx5_comp*/../smp_affinity_list
> 

Correct, I used the Mellanox script installed by the mellanox OFED for 
all. I think that one works for all. Anyway this could explain why the 
netperf case did go to the same core with I40E, but with my iperf one, 
the 50 flows where distributed all the way around.

I made a video (enable subtitles). I just re-compiled with clean 5.1.5 
(no RSS modification or anything), it's the same thing that you can see 
on the video. The iperf is the normal iperf2 also in the video. Enabling 
the xdp_pass program create a huge CPU increase with CX5. With XL710 I 
get only a 1 or 2 % per CPU increase.

https://www.youtube.com/watch?v=o5hlJZbN4Tk&feature=youtu.be


>>
>> I do have one patch to copy the RSS hash in the xdp_buff, but the field
>> is read even if xdp is disabled.
> 
> What is you use-case for this?

Load balancing. No need to re-compute a hash in SW if HW did it...

> 
> Upstream will likely request that this is added as xdp_buff->metadata
> and using BTF format... but it is a longer project see[1], and is
> currently scheduled as a "medium-term" task... let us know if you want
> to work on this...
> 
> [1] https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#metadata-available-to-programs
>
I would be happy to help. But we would be making a sk_buff again if we 
start throwing things in the buff that people may be using in one use 
case. Already, first time I looked at XDP it was "data + len" and now 
there is like 10 fields extracted with the queue info.

On the contrary, I found the BPF resolver (name? the thing that 
translate the BPF offset to the real struct offset) to be super neat. 
Wouldn't driver be able to expose a specific per-driver resolver that 
will know how to fetch all this random information in the descriptors 
and will therefore do it only if needed?

Tom
