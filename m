Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:40515 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732237AbeKXDyo (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 23 Nov 2018 22:54:44 -0500
Received: by mail-it1-f195.google.com with SMTP id h193so18801326ita.5
        for <xdp-newbies@vger.kernel.org>; Fri, 23 Nov 2018 09:09:39 -0800 (PST)
MIME-Version: 1.0
References: <CAHOxX0xFn2RARhnQeJ3m-+8UWrtD-bN2dn8x_FygCfDKdD3oQQ@mail.gmail.com>
 <d69fbde9-c28a-d5be-a667-c54e3c4f52f3@gmail.com> <CAHOxX0zjkCczaav6NfPYLu=ivJYoLCJe_L+3krn3-vr+paNdDA@mail.gmail.com>
 <20181120191412.088c68fb@redhat.com> <b9da9c67-e31c-f469-6515-c7913a89dd26@redhat.com>
In-Reply-To: <b9da9c67-e31c-f469-6515-c7913a89dd26@redhat.com>
From: Pavel Popa <pashinho1990@gmail.com>
Date: Fri, 23 Nov 2018 18:09:26 +0100
Message-ID: <CAHOxX0zY5WM4oK7W6owem2LpkuyokCw_oLSXArdp2OMAU9-Wng@mail.gmail.com>
Subject: Re: qemu-kvm XDP forwarding with virtio_net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: brouer@redhat.com, David Ahern <dsahern@gmail.com>, xdp-newbies@vger.kernel.org

Hi Jason,

I confirm that the patch you sent me, together with "[PATCH net 1/2]
virtio-net: disable guest csum during XDP set" and "[PATCH net 2/2]
virtio-net: fail XDP set if guest csum is negotiated", have fixed the
"bad gso" issue.

Cheers
Il giorno gio 22 nov 2018 alle ore 03:15 Jason Wang
<jasowang@redhat.com> ha scritto:
>
>
> On 2018/11/21 =E4=B8=8A=E5=8D=882:14, Jesper Dangaard Brouer wrote:
> > On Tue, 20 Nov 2018 16:47:19 +0100
> > Pavel Popa <pashinho1990@gmail.com> wrote:
> >
> >> Well, here's the output from the `ip link` cmd:
> >>      3: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq =
state UP
> >>          link/ether 52:54:fc:47:e2:d3 brd ff:ff:ff:ff:ff:ff
> >>          prog/xdp id 1 tag 1cd982ef22273bda jited
> >>      4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc mq =
state UP
> >>          link/ether 52:54:55:d3:50:ee brd ff:ff:ff:ff:ff:ff
> >>          prog/xdp id 1 tag 1cd982ef22273bda jited
> >>
> >> As you can see, there's the XDP program ID 1 executing on them.
> >> However, there's definitely something interesting happening when
> >> bpf_fib_lookup() returns BPF_FIB_LKUP_RET_NO_NEIGH, for which my XDP
> >> program just returns XDP_PASS while the following line gets printed in
> >> kern.log:
> >>      eth3: bad gso: type: 164, size: 256
>
>
> Looks like a bug in virtio-net driver since all gso should be disabled
> on host.
>
> Could you please try the attached patch to see if it fixes the issue?
>
>
> >>
> >> No idea what's wrong here.
> >> Also, when bpf_fib_lookup() returns BPF_FIB_LKUP_RET_SUCCESS, for
> >> which my XDP program executes bpf_redirect_map(&dev_map,
> >> fib_params.ifindex, 0), the following gets printed in
> >>
> >> /sys/kernel/debug/tracing/trace_pipe:
> >>      xdp_redirect_map_err: prog_id=3D1 action=3DREDIRECT ifindex=3D3
> >> to_ifindex=3D0 err=3D-14 map_id=3D0 map_index=3D4
> > The err=3D-14 is -EFAULT.
> >
> > Notice "ifindex=3D3" but "to_ifindex=3D0", which is the problem.  The
> > "map_index=3D4" is correct, but "to_ifindex" does a lookup in the map f=
or
> > the net_device->ifindex stored in this map.  It is fairly unlikely that
> > you added device with ifindex=3D0 to map index 4, I presume?
> >
> > Then I was thinking, maybe the "map_index=3D4" doesn't contain anything=
,
> > but reading the code, that will return err=3D-22 (#define EINVAL 22),
> > which it not the case.
> >
> > Assuming that map_index=3D4 does contain a valid net_device. Following
> > the code via __bpf_tx_xdp_map -> dev_map_enqueue, I simply cannot find
> > an -EFAULT err return value.
> >
> > --Jesper
> >
> >
> >> I feel this last one to be somewhat related to the comment here
> >> https://elixir.bootlin.com/linux/v4.18.10/source/samples/bpf/xdp_fwd_k=
ern.c#L107.
> >> Is it correct? If so, what does this precisely mean? Is there any way
> >> to get around with this? Because what I'm doing is simply using the
> >> BPF_MAP_TYPE_DEVMAP with the bpf_redirect_map() helper to forward
> >> packets between "XDP ports".
> >>
> >> Il giorno mar 20 nov 2018 alle ore 15:39 David Ahern
> >> <dsahern@gmail.com> ha scritto:
> >>> On 11/20/18 7:18 AM, Pavel Popa wrote:
> >>>> Hi all,
> >>>>
> >>>> I've implemented a XDP forwarding program using the bpf_fib_lookup()
> >>>> helper, and loaded it in the kernel as XDP driver mode (i.e. execute=
d
> >>>> at the virtio_net driver level). The only problem is that the
> >>>> receiving virtio network interface seems to drop the XDP packet afte=
r
> >>>> successfully executing my XDP program.
> >>>> Kernel: 4.18.10
> >>>>
> >>>> my_xdp_fwd_kern.c:
> >>>> /* made sure this returns 0 (i.e. BPF_FIB_LKUP_RET_SUCCESS) */
> >>>> rc =3D bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params),
> >>>> BPF_FIB_LOOKUP_DIRECT);
> >>>> /* made sure this returns 4 (i.e. XDP_REDIRECT) */
> >>>> rc =3D bpf_redirect_map(&dev_map, fib_params.ifindex, 0);
> >>>> return rc;
> >>>>
> >>>> I checked that rc is indeed XDP_REDIRECT and that fib_params.ifindex
> >>>> is the correct dev index from FIB lookup.
> >>>> dev_map is setup by the userspace my_xdp_fwd_user.c component as fol=
lows:
> >>>> for (i =3D 1; i < 64; i++)
> >>>>      bpf_map_update_elem(devmap_fd, &i, &i, BPF_ANY);
> >>>>
> >>>> I'm passing the following to the qemu cmd line for the 2 devices I
> >>>> want to run XDP on (as stated here
> >>>> https://marc.info/?l=3Dxdp-newbies&m=3D149486931113651&w=3D2):
> >>>> -device virtio-net-pci,mq=3Don,vectors=3D18,rx_queue_size=3D1024,tx_=
queue_size=3D512,
> >>>> ... ,gso=3Doff,guest_tso4=3Doff,guest_tso6=3Doff,guest_ecn=3Doff,gue=
st_ufo=3Doff
> >>>> \
> >>>> -device virtio-net-pci,mq=3Don,vectors=3D18,rx_queue_size=3D1024,tx_=
queue_size=3D512,
> >>>> ... ,gso=3Doff,guest_tso4=3Doff,guest_tso6=3Doff,guest_ecn=3Doff,gue=
st_ufo=3Doff
> >>>> \
> >>>>
> >>>> In the guest enabling also the MultiQueue feature, as stated here
> >>>> https://www.linux-kvm.org/page/Multiqueue#Enable_MQ_feature.
> >>>> What I'm left with is debugging the virtio_net kernel module by addi=
ng
> >>>> a bunch of printk() and see what happens, especially here
> >>>> https://elixir.bootlin.com/linux/v4.18.10/source/drivers/net/virtio_=
net.c#L667.
> >>>>
> >>>> Am I doing something wrong here? What I'm missing?
> >>>>
> >>> I believe at this point you can drop the gso,tso,ufo and ecn args. I =
use
> >>> virtio for development and these days start my VMs with only:
> >>>
> >>> ...,mq=3Don,guest_csum=3Doff,...
>
>
> This looks like another bug that guest_cusm was not disabled
> automatically. Let me post a fix for this.
>
> Thanks.
>
>
> >>>
> >>> After that are you installing the xdp program on all interfaces that =
can
> >>> be used for forwarding? ie., if it transmits a packet in XDP mode it
> >>> needs the xdp program loaded. For example I use:
> >>>
> >>> xdp_fwd eth1 eth2 eth3 eth4
> >>>
> >>>
> >>>  From there:
> >>>
> >>> echo 1 > /sys/kernel/debug/tracing/events/xdp/enable
> >>> cat /sys/kernel/debug/tracing/trace_pipe
> >>>
> >
> >
