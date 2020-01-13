Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgAMKnN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 13 Jan 2020 05:43:13 -0500
Received: by mail-lj1-f198.google.com with SMTP id g5so1826270ljj.22
        for <xdp-newbies@vger.kernel.org>; Mon, 13 Jan 2020 02:43:06 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: zero-copy between interfaces
In-Reply-To: <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu> <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
Date: Mon, 13 Jan 2020 11:43:02 +0100
Message-ID: <87k15vwsax.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Magnus Karlsson <magnus.karlsson@gmail.com>, Ryan Goodfellow <rgoodfel@isi.edu>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> On Mon, Jan 13, 2020 at 1:28 AM Ryan Goodfellow <rgoodfel@isi.edu> wrote:
>>
>> Greetings XDP folks. I've been working on a zero-copy XDP bridge
>> implementation similar to what's described in the following thread.
>>
>>   https://www.spinics.net/lists/xdp-newbies/msg01333.html
>>
>> I now have an implementation that is working reasonably well under certain
>> conditions for various hardware. The implementation is primarily based on the
>> xdpsock_user program in the kernel under samples/bpf. You can find my program
>> and corresponding BPF program here.
>>
>> - https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5-moa/samples/bpf/xdpsock_multidev.c
>> - https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5-moa/samples/bpf/xdpsock_multidev_kern.c
>>
>> I have small testbed to run this code on that looks like the following.
>>
>> Packet forwarding machine:
>>     CPU: Intel(R) Xeon(R) D-2146NT CPU @ 2.30GHz (8 core / 16 thread)
>>     Memory: 32 GB
>>     NICs:
>>     - Mellanox ConnectX 4 Dual 100G MCX416A-CCAT (connected at 40G)
>>     - Intel X722 10G SFP+
>>
>> Sender/receiver machines
>>     CPU: Intel(R) Xeon(R) D-2146NT CPU @ 2.30GHz (8 core / 16 thread)
>>     Memory: 32 GB
>>     NICs:
>>     - Mellanox ConnectX 4 40G MCX4131A-BCAT
>>     - Intel X722 10G SFP+
>>
>> I could not get zero-copy to work with the i40e driver as it would crash. I've
>> attached the corresponding traces from dmesg. The results below are with the
>> i40e running in SKB/copy mode. I do have an X710-DA4 that I could plug into the
>> server and test with instead of the X722 if that is of interest. In all cases I
>> used a single hardware queue via the following.
>>
>>     ethtool -L <dev> combined 1
>>
>> The Mellanox cards in zero-copy mode create a sort of shadow set of queues, I
>> used ntuple rules to push things through queue 1 (shadows 0) as follows
>>
>>     ethtool -N <dev> flow-type ether src <mac> action 1
>>
>> The numbers that I have been able to achive with this code are the following. MTU
>> is 1500 in all cases.
>>
>>     mlx5: pps ~ 2.4 Mpps, 29 Gbps (driver mode, zero-copy)
>>     i40e: pps ~ 700 Kpps, 8 Gbps (skb mode, copy)
>>     virtio: pps ~ 200 Kpps, 2.4 Gbps (skb mode, copy, all qemu/kvm VMs)
>>
>> Are these numbers in the ballpark of what's expected?
>>
>> One thing I have noticed is that I cannot create large memory maps for the
>> packet buffers. For example a frame size of 2048 with 524288 frames (around
>> 1G of packets) is fine. However, increasing size by an order of magnitude, which
>> is well within the memory capacity of the host machine results in an error when
>> creating the UMEM and the kernel shows the attached call trace. I'm going to
>> begin investigating this in more detail soon, but if anyone has advice on large
>> XDP memory maps that would be much appreciated.
>
> Hi Ryan,
>
> Thanks for taking XDP and AF_XDP for a sping. I will start by fixing
> this out-of-memory issue. With your umem size, we are hitting the size
> limit of kmalloc. I will fix this by using kvmalloc that tries to
> allocate with vmalloc if kmalloc fails. Should hopefully make it
> possible for you to allocate larger umems.
>
>> The reason for wanting large memory maps is that our use case for XDP is network
>> emulation - and sometimes that means introducing delay factors that can require
>> a rather large in-memory packet buffers.
>>
>> If there is interest in including this program in the official BPF samples I'm happy to
>> submit a patch. Any comments on the program are also much appreciated.
>
> More examples are always useful, but the question is if it should
> reside in samples or outside the kernel in some other repo? Is there
> some good place in xdp-project github that could be used for this
> purpose?

We could certainly create something; either a new xdp-samples
repository, or an example-programs/ subdir of the xdp-tutorial? Which of
those makes the most sense depends on the size of the program I think...

-Toke
