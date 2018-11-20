Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbeKUEop (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 20 Nov 2018 23:44:45 -0500
Date: Tue, 20 Nov 2018 19:14:12 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: qemu-kvm XDP forwarding with virtio_net
Message-ID: <20181120191412.088c68fb@redhat.com>
In-Reply-To: <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
        <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com>
        <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>
Cc: dsahern@gmail.com, xdp-newbies@vger.kernel.org, brouer@redhat.com, Jason Wang <jasowang@redhat.com>

On Tue, 20 Nov 2018 16:47:19 +0100
Pavel Popa <pashinho1990@gmail.com> wrote:

> Well, here's the output from the `ip link` cmd:
>     3: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
>         link/ether 52:54:fc:47:e2:d3 brd ff:ff:ff:ff:ff:ff
>         prog/xdp id 1 tag 1cd982ef22273bda jited
>     4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq state UP
>         link/ether 52:54:55:d3:50:ee brd ff:ff:ff:ff:ff:ff
>         prog/xdp id 1 tag 1cd982ef22273bda jited
> 
> As you can see, there's the XDP program ID 1 executing on them.
> However, there's definitely something interesting happening when
> bpf_fib_lookup() returns BPF_FIB_LKUP_RET_NO_NEIGH, for which my XDP
> program just returns XDP_PASS while the following line gets printed in
> kern.log:
>     eth3: bad gso: type: 164, size: 256
> 
> No idea what's wrong here.
> Also, when bpf_fib_lookup() returns BPF_FIB_LKUP_RET_SUCCESS, for
> which my XDP program executes bpf_redirect_map(&dev_map,
> fib_params.ifindex, 0), the following gets printed in
>
> /sys/kernel/debug/tracing/trace_pipe:
>     xdp_redirect_map_err: prog_id=1 action=REDIRECT ifindex=3
> to_ifindex=0 err=-14 map_id=0 map_index=4

The err=-14 is -EFAULT.

Notice "ifindex=3" but "to_ifindex=0", which is the problem.  The
"map_index=4" is correct, but "to_ifindex" does a lookup in the map for
the net_device->ifindex stored in this map.  It is fairly unlikely that
you added device with ifindex=0 to map index 4, I presume?

Then I was thinking, maybe the "map_index=4" doesn't contain anything,
but reading the code, that will return err=-22 (#define EINVAL 22),
which it not the case.

Assuming that map_index=4 does contain a valid net_device. Following
the code via __bpf_tx_xdp_map -> dev_map_enqueue, I simply cannot find
an -EFAULT err return value.

--Jesper


> I feel this last one to be somewhat related to the comment here
> https://elixir.bootlin.com/linux/v4.18.10/source/samples/bpf/xdp_fwd_kern.c#L107.
> Is it correct? If so, what does this precisely mean? Is there any way
> to get around with this? Because what I'm doing is simply using the
> BPF_MAP_TYPE_DEVMAP with the bpf_redirect_map() helper to forward
> packets between "XDP ports".
> 
> Il giorno mar 20 nov 2018 alle ore 15:39 David Ahern
> <dsahern@gmail.com> ha scritto:
> >
> > On 11/20/18 7:18 AM, Pavel Popa wrote:  
> > > Hi all,
> > >
> > > I've implemented a XDP forwarding program using the bpf_fib_lookup()
> > > helper, and loaded it in the kernel as XDP driver mode (i.e. executed
> > > at the virtio_net driver level). The only problem is that the
> > > receiving virtio network interface seems to drop the XDP packet after
> > > successfully executing my XDP program.
> > > Kernel: 4.18.10
> > >
> > > my_xdp_fwd_kern.c:
> > > /* made sure this returns 0 (i.e. BPF_FIB_LKUP_RET_SUCCESS) */
> > > rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params),
> > > BPF_FIB_LOOKUP_DIRECT);
> > > /* made sure this returns 4 (i.e. XDP_REDIRECT) */
> > > rc = bpf_redirect_map(&dev_map, fib_params.ifindex, 0);
> > > return rc;
> > >
> > > I checked that rc is indeed XDP_REDIRECT and that fib_params.ifindex
> > > is the correct dev index from FIB lookup.
> > > dev_map is setup by the userspace my_xdp_fwd_user.c component as follows:
> > > for (i = 1; i < 64; i++)
> > >     bpf_map_update_elem(devmap_fd, &i, &i, BPF_ANY);
> > >
> > > I'm passing the following to the qemu cmd line for the 2 devices I
> > > want to run XDP on (as stated here
> > > https://marc.info/?l=xdp-newbies&m=149486931113651&w=2):
> > > -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
> > > ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
> > > \
> > > -device virtio-net-pci,mq=on,vectors=18,rx_queue_size=1024,tx_queue_size=512,
> > > ... ,gso=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off
> > > \
> > >
> > > In the guest enabling also the MultiQueue feature, as stated here
> > > https://www.linux-kvm.org/page/Multiqueue#Enable_MQ_feature.
> > > What I'm left with is debugging the virtio_net kernel module by adding
> > > a bunch of printk() and see what happens, especially here
> > > https://elixir.bootlin.com/linux/v4.18.10/source/drivers/net/virtio_net.c#L667.
> > >
> > > Am I doing something wrong here? What I'm missing?
> > >  
> >
> > I believe at this point you can drop the gso,tso,ufo and ecn args. I use
> > virtio for development and these days start my VMs with only:
> >
> > ...,mq=on,guest_csum=off,...
> >
> > After that are you installing the xdp program on all interfaces that can
> > be used for forwarding? ie., if it transmits a packet in XDP mode it
> > needs the xdp program loaded. For example I use:
> >
> > xdp_fwd eth1 eth2 eth3 eth4
> >
> >
> > From there:
> >
> > echo 1 > /sys/kernel/debug/tracing/events/xdp/enable
> > cat /sys/kernel/debug/tracing/trace_pipe
> >  



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
