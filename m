Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34247 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbeKUEto (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 20 Nov 2018 23:49:44 -0500
Received: by mail-pl1-f194.google.com with SMTP id f12-v6so1519912plo.1
        for <xdp-newbies@vger.kernel.org>; Tue, 20 Nov 2018 10:19:16 -0800 (PST)
Subject: Re: qemu-kvm XDP forwarding with virtio_net
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
 <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com>
 <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
 <20181120191412.088c68fb@redhat.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <4b54bff2-ace3-29e2-443b-9a59006dca3b@gmail.com>
Date: Tue, 20 Nov 2018 11:19:14 -0700
MIME-Version: 1.0
In-Reply-To: <20181120191412.088c68fb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>, Pavel Popa <pashinho1990@gmail.com>
Cc: xdp-newbies@vger.kernel.org, Jason Wang <jasowang@redhat.com>

On 11/20/18 11:14 AM, Jesper Dangaard Brouer wrote:
> On Tue, 20 Nov 2018 16:47:19 +0100
> Pavel Popa <pashinho1990@gmail.com> wrote:
> 
>> Well, here's the output from the `ip link` cmd:
>>     3: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
>>         link/ether 52:54:fc:47:e2:d3 brd ff:ff:ff:ff:ff:ff
>>         prog/xdp id 1 tag 1cd982ef22273bda jited
>>     4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
>>         link/ether 52:54:55:d3:50:ee brd ff:ff:ff:ff:ff:ff
>>         prog/xdp id 1 tag 1cd982ef22273bda jited
>>
>> As you can see, there's the XDP program ID 1 executing on them.
>> However, there's definitely something interesting happening when
>> bpf_fib_lookup() returns BPF_FIB_LKUP_RET_NO_NEIGH, for which my XDP
>> program just returns XDP_PASS while the following line gets printed in
>> kern.log:
>>     eth3: bad gso: type: 164, size: 256
>>
>> No idea what's wrong here.
>> Also, when bpf_fib_lookup() returns BPF_FIB_LKUP_RET_SUCCESS, for
>> which my XDP program executes bpf_redirect_map(&dev_map,
>> fib_params.ifindex, 0), the following gets printed in
>>
>> /sys/kernel/debug/tracing/trace_pipe:
>>     xdp_redirect_map_err: prog_id=1 action=REDIRECT ifindex=3
>> to_ifindex=0 err=-14 map_id=0 map_index=4
> 
> The err=-14 is -EFAULT.
> 
> Notice "ifindex=3" but "to_ifindex=0", which is the problem.  The
> "map_index=4" is correct, but "to_ifindex" does a lookup in the map for
> the net_device->ifindex stored in this map.  It is fairly unlikely that
> you added device with ifindex=0 to map index 4, I presume?
> 
> Then I was thinking, maybe the "map_index=4" doesn't contain anything,
> but reading the code, that will return err=-22 (#define EINVAL 22),
> which it not the case.
> 
> Assuming that map_index=4 does contain a valid net_device. Following
> the code via __bpf_tx_xdp_map -> dev_map_enqueue, I simply cannot find
> an -EFAULT err return value.
> 

Pavel:

Does the xdp_fwd sample work as is? you should be able to use it in your
setup with out changes to verify basic functionality.

From there you can check the fib lookup:
    perf record -e fib:* -a -- sleep 5
    <run traffic during 5-second window>
    perf script

Look at the FIB lookup result and egress device. Is it correct? The
fib_params.ifindex is set based on the egress device from the fib lookup.
