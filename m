Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f177.google.com ([209.85.166.177]:54735 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbeKUUfs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Nov 2018 15:35:48 -0500
Received: by mail-it1-f177.google.com with SMTP id a205-v6so7923868itd.4
        for <xdp-newbies@vger.kernel.org>; Wed, 21 Nov 2018 02:01:59 -0800 (PST)
MIME-Version: 1.0
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
 <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com> <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
 <20181120191412.088c68fb@redhat.com> <CAHOxX0wxq6+ML1pZymG=EyBi15FQZSdASaJSaSfY4Kc+OvunDQ@mail.gmail.com>
In-Reply-To: <CAHOxX0wxq6+ML1pZymG=EyBi15FQZSdASaJSaSfY4Kc+OvunDQ@mail.gmail.com>
From: Pavel Popa <pashinho1990@gmail.com>
Date: Wed, 21 Nov 2018 11:01:45 +0100
Message-ID: <CAHOxX0yUuk5rR2iQwYwgWS7+HH-bzZ60VFHw1jo4eAGVkED4pg@mail.gmail.com>
Subject: Re: qemu-kvm XDP forwarding with virtio_net
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: brouer@redhat.com
Cc: David Ahern <dsahern@gmail.com>, xdp-newbies@vger.kernel.org, jasowang@redhat.com

For what I see, the only way to return -EFAULT is in this case
https://elixir.bootlin.com/linux/v4.18.10/source/net/core/filter.c#L3259.
This may explain the "to_ifindex=0" thing, as 'fwd' is initialized
NULL. But I don't understand the meaning of the
"xdp_map_invalid(xdp_prog, map_owner)" condition. So, if that's really
the case, what can be inferred from this?
Il giorno mer 21 nov 2018 alle ore 10:08 Pavel Popa
<pashinho1990@gmail.com> ha scritto:
>
> After setting up the devmap I print its contents.
>     dumping DEVMAP:
>         k = 1, v = 1
>         k = 2, v = 2
>         k = 3, v = 3
>         k = 4, v = 4
>         k = 5, v = 4
>         k = 6, v = 4
>         ...
>         k = 63, v = 4
>
> > ip link
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
> mode DEFAULT group default qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 1000
>     link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
> 3: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state
> UP mode DEFAULT group default qlen 1000
>     link/ether 52:54:fc:47:e2:d3 brd ff:ff:ff:ff:ff:ff
>     prog/xdp id 1 tag 1cd982ef22273bda jited
> 4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state
> UP mode DEFAULT group default qlen 1000
>     link/ether 52:54:55:d3:50:ee brd ff:ff:ff:ff:ff:ff
>     prog/xdp id 1 tag 1cd982ef22273bda jited
>
> eth1: 172.17.102.143/23 (this is the management interface)
> eth2: 192.168.1.101/24 (XDP "host-only" interface)
> eth3: 192.168.0.101/24 (XDP "host-only" interface)
>
> The XDP program is triggered by the reception of a packet on eth3
> (ifindex 3), it does its thing and performs the routing lookup by
> bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params),
> BPF_FIB_LOOKUP_DIRECT) wich returns BPF_FIB_LKUP_RET_SUCCESS as the
> packet's dst IP is 192.168.1.1. Thus, fib.params = 4 (I'm logging all
> of this in /sys/kernel/debug/tracing/trace_pipe), i.e. forward over
> ifindex 4 (eth2) which mapped value in devmap is 4. So I have no idea
> what "to_ifindex=0" means here. I'm totally blocked on this.
> Il giorno mar 20 nov 2018 alle ore 19:14 Jesper Dangaard Brouer
> <brouer@redhat.com> ha scritto:
> >
> > On Tue, 20 Nov 2018 16:47:19 +0100
> > Pavel Popa <pashinho1990@gmail.com> wrote:
> >
> > > Well, here's the output from the `ip link` cmd:
> > >     3: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
> > >         link/ether 52:54:fc:47:e2:d3 brd ff:ff:ff:ff:ff:ff
> > >         prog/xdp id 1 tag 1cd982ef22273bda jited
> > >     4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
> > >         link/ether 52:54:55:d3:50:ee brd ff:ff:ff:ff:ff:ff
> > >         prog/xdp id 1 tag 1cd982ef22273bda jited
> > >
> > > As you can see, there's the XDP program ID 1 executing on them.
> > > However, there's definitely something interesting happening when
> > > bpf_fib_lookup() returns BPF_FIB_LKUP_RET_NO_NEIGH, for which my XDP
> > > program just returns XDP_PASS while the following line gets printed in
> > > kern.log:
> > >     eth3: bad gso: type: 164, size: 256
> > >
> > > No idea what's wrong here.
> > > Also, when bpf_fib_lookup() returns BPF_FIB_LKUP_RET_SUCCESS, for
> > > which my XDP program executes bpf_redirect_map(&dev_map,
> > > fib_params.ifindex, 0), the following gets printed in
> > >
> > > /sys/kernel/debug/tracing/trace_pipe:
> > >     xdp_redirect_map_err: prog_id=1 action=REDIRECT ifindex=3
> > > to_ifindex=0 err=-14 map_id=0 map_index=4
> >
> > The err=-14 is -EFAULT.
> >
> > Notice "ifindex=3" but "to_ifindex=0", which is the problem.  The
> > "map_index=4" is correct, but "to_ifindex" does a lookup in the map for
> > the net_device->ifindex stored in this map.  It is fairly unlikely that
> > you added device with ifindex=0 to map index 4, I presume?
> >
> > Then I was thinking, maybe the "map_index=4" doesn't contain anything,
> > but reading the code, that will return err=-22 (#define EINVAL 22),
> > which it not the case.
> >
> > Assuming that map_index=4 does contain a valid net_device. Following
> > the code via __bpf_tx_xdp_map -> dev_map_enqueue, I simply cannot find
> > an -EFAULT err return value.
> >
> > --Jesper
> >
> >
> > > I feel this last one to be somewhat related to the comment here
> > > https://elixir.bootlin.com/linux/v4.18.10/source/samples/bpf/xdp_fwd_kern.c#L107.
> > > Is it correct? If so, what does this precisely mean? Is there any way
> > > to get around with this? Because what I'm doing is simply using the
> > > BPF_MAP_TYPE_DEVMAP with the bpf_redirect_map() helper to forward
> > > packets between "XDP ports".
> > >
> > > Il giorno mar 20 nov 2018 alle ore 15:39 David Ahern
> > > <dsahern@gmail.com> ha scritto:
> > > >
> > > > On 11/20/18 7:18 AM, Pavel Popa wrote:
> > > > > Hi all,
> > > > >
> > > > > I've implemented a XDP forwarding program using the bpf_fib_lookup()
> > > > > helper, and loaded it in the kernel as XDP driver mode (i.e. executed
> > > > > at the virtio_net driver level). The only problem is that the
> > > > > receiving virtio network interface seems to drop the XDP packet after
> > > > > successfully executing my XDP program.
> > > > > Kernel: 4.18.10
> > > > >
> > > > > my_xdp_fwd_kern.c:
> > > > > /* made sure this returns 0 (i.e. BPF_FIB_LKUP_RET_SUCCESS) */
> > > > > rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params),
> > > > > BPF_FIB_LOOKUP_DIRECT);
> > > > > /* made sure this returns 4 (i.e. XDP_REDIRECT) */
> > > > > rc = bpf_redirect_map(&dev_map, fib_params.ifindex, 0);
> > > > > return rc;
> > > > >
> > > > > I checked that rc is indeed XDP_REDIRECT and that fib_params.ifindex
> > > > > is the correct dev index from FIB lookup.
> > > > > dev_map is setup by the userspace my_xdp_fwd_user.c component as follows:
> > > > > for (i = 1; i < 64; i++)
> > > > >     bpf_map_update_elem(devmap_fd, &i, &i, BPF_ANY);
> > > > >
> > > > > I'm passing the following to the qemu cmd line for the 2 devices I
> > > > > want to run XDP on (as stated here
> > > > > https://marc.info/?l=xdp-newbies&m=149486931113651&w=2):
> > > > > -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
> > > > > ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
> > > > > \
> > > > > -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
> > > > > ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
> > > > > \
> > > > >
> > > > > In the guest enabling also the MultiQueue feature, as stated here
> > > > > https://www.linux-kvm.org/page/Multiqueue#Enable_MQ_feature.
> > > > > What I'm left with is debugging the virtio_net kernel module by adding
> > > > > a bunch of printk() and see what happens, especially here
> > > > > https://elixir.bootlin.com/linux/v4.18.10/source/drivers/net/virtio_net.c#L667.
> > > > >
> > > > > Am I doing something wrong here? What I'm missing?
> > > > >
> > > >
> > > > I believe at this point you can drop the gso,tso,ufo and ecn args. I use
> > > > virtio for development and these days start my VMs with only:
> > > >
> > > > ...,mq=on,guest_csum=off,...
> > > >
> > > > After that are you installing the xdp program on all interfaces that can
> > > > be used for forwarding? ie., if it transmits a packet in XDP mode it
> > > > needs the xdp program loaded. For example I use:
> > > >
> > > > xdp_fwd eth1 eth2 eth3 eth4
> > > >
> > > >
> > > > From there:
> > > >
> > > > echo 1 > /sys/kernel/debug/tracing/events/xdp/enable
> > > > cat /sys/kernel/debug/tracing/trace_pipe
> > > >
> >
> >
> >
> > --
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
