Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:39107 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbeKUAr6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 20 Nov 2018 19:47:58 -0500
Received: by mail-it1-f195.google.com with SMTP id m15so3683340itl.4
        for <xdp-newbies@vger.kernel.org>; Tue, 20 Nov 2018 06:18:36 -0800 (PST)
MIME-Version: 1.0
From: Pavel Popa <pashinho1990@gmail.com>
Date: Tue, 20 Nov 2018 15:18:24 +0100
Message-ID: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
Subject: qemu-kvm XDP forwarding with virtio_net
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I've implemented a XDP forwarding program using the bpf_fib_lookup()
helper, and loaded it in the kernel as XDP driver mode (i.e. executed
at the virtio_net driver level). The only problem is that the
receiving virtio network interface seems to drop the XDP packet after
successfully executing my XDP program.
Kernel: 4.18.10

my_xdp_fwd_kern.c:
/* made sure this returns 0 (i.e. BPF_FIB_LKUP_RET_SUCCESS) */
rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params),
BPF_FIB_LOOKUP_DIRECT);
/* made sure this returns 4 (i.e. XDP_REDIRECT) */
rc = bpf_redirect_map(&dev_map, fib_params.ifindex, 0);
return rc;

I checked that rc is indeed XDP_REDIRECT and that fib_params.ifindex
is the correct dev index from FIB lookup.
dev_map is setup by the userspace my_xdp_fwd_user.c component as follows:
for (i = 1; i < 64; i++)
    bpf_map_update_elem(devmap_fd, &i, &i, BPF_ANY);

I'm passing the following to the qemu cmd line for the 2 devices I
want to run XDP on (as stated here
https://marc.info/?l=xdp-newbies&m=149486931113651&w=2):
-device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
\
-device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
\

In the guest enabling also the MultiQueue feature, as stated here
https://www.linux-kvm.org/page/Multiqueue#Enable_MQ_feature.
What I'm left with is debugging the virtio_net kernel module by adding
a bunch of printk() and see what happens, especially here
https://elixir.bootlin.com/linux/v4.18.10/source/drivers/net/virtio_net.c#L667.

Am I doing something wrong here? What I'm missing?
