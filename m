Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41785 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeKUBIt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 20 Nov 2018 20:08:49 -0500
Received: by mail-pf1-f193.google.com with SMTP id b7so1088785pfi.8
        for <xdp-newbies@vger.kernel.org>; Tue, 20 Nov 2018 06:39:21 -0800 (PST)
Subject: Re: qemu-kvm XDP forwarding with virtio_net
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com>
Date: Tue, 20 Nov 2018 07:39:17 -0700
MIME-Version: 1.0
In-Reply-To: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>, xdp-newbies@vger.kernel.org

On 11/20/18 7:18 AM, Pavel Popa wrote:
> Hi all,
> 
> I've implemented a XDP forwarding program using the bpf_fib_lookup()
> helper, and loaded it in the kernel as XDP driver mode (i.e. executed
> at the virtio_net driver level). The only problem is that the
> receiving virtio network interface seems to drop the XDP packet after
> successfully executing my XDP program.
> Kernel: 4.18.10
> 
> my_xdp_fwd_kern.c:
> /* made sure this returns 0 (i.e. BPF_FIB_LKUP_RET_SUCCESS) */
> rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params),
> BPF_FIB_LOOKUP_DIRECT);
> /* made sure this returns 4 (i.e. XDP_REDIRECT) */
> rc = bpf_redirect_map(&dev_map, fib_params.ifindex, 0);
> return rc;
> 
> I checked that rc is indeed XDP_REDIRECT and that fib_params.ifindex
> is the correct dev index from FIB lookup.
> dev_map is setup by the userspace my_xdp_fwd_user.c component as follows:
> for (i = 1; i < 64; i++)
>     bpf_map_update_elem(devmap_fd, &i, &i, BPF_ANY);
> 
> I'm passing the following to the qemu cmd line for the 2 devices I
> want to run XDP on (as stated here
> https://marc.info/?l=xdp-newbies&m=149486931113651&w=2):
> -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
> ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
> \
> -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
> ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
> \
> 
> In the guest enabling also the MultiQueue feature, as stated here
> https://www.linux-kvm.org/page/Multiqueue#Enable_MQ_feature.
> What I'm left with is debugging the virtio_net kernel module by adding
> a bunch of printk() and see what happens, especially here
> https://elixir.bootlin.com/linux/v4.18.10/source/drivers/net/virtio_net.c#L667.
> 
> Am I doing something wrong here? What I'm missing?
> 

I believe at this point you can drop the gso,tso,ufo and ecn args. I use
virtio for development and these days start my VMs with only:

...,mq=on,guest_csum=off,...

After that are you installing the xdp program on all interfaces that can
be used for forwarding? ie., if it transmits a packet in XDP mode it
needs the xdp program loaded. For example I use:

xdp_fwd eth1 eth2 eth3 eth4


From there:

echo 1 > /sys/kernel/debug/tracing/events/xdp/enable
cat /sys/kernel/debug/tracing/trace_pipe
