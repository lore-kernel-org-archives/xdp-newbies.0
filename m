Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48940 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751010AbdIMNvZ (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Sep 2017 09:51:25 -0400
Date: Wed, 13 Sep 2017 15:51:22 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: MAC addresses and XDP_TX
Message-ID: <20170913155122.0ced1084@redhat.com>
In-Reply-To: <CAHALiH5E4N+1m_E=AVnVi5esew7jC7U4mRcfg4YyoooyJdg4ow@mail.gmail.com>
References: <CAHALiH5E4N+1m_E=AVnVi5esew7jC7U4mRcfg4YyoooyJdg4ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Tomaz Buh <hubber.iskratel@gmail.com>
Cc: xdp-newbies@vger.kernel.org


On Wed, 13 Sep 2017 14:56:38 +0200 Tomaz Buh <hubber.iskratel@gmail.com> wrote:

> I'm trying to modify packets within the BPF program and send them to
> another IP address through the same NIC with the XDP_TX call
> (ultimately I'm trying to do a RTP proxy sample).
>
> What I'm missing is the MAC address for the IP, which can be normally
> obtained from the ARP table.
> I can see two solutions for dynamic sending:
> -search the kernel tables for ARP entries,
> -produce ARP reqests and have own ARP table.
> 
> Is any of the solutions possible with the current implementation?
> Is there any better solution?

I don't think the kernel have a bpf helper call that can do lookups in
the arptable, and I don't think we need to add it, as via current
facilities we can get the same thing.

The XDP program will need to have a bpf map for maintaining the IP to
MAC-addr mapping, like the the arptable.  But the XDP program can
delegate a userspace program to maintain and update this map.

First of all you let ETH_P_ARP return XDP_PASS (like [1]), which cause
the OS/kernel to handle ARP packets.

Second you can register to get rt_netlink notifications when the arp/neigh
table change (group RTNLGRP_NEIGH).  Look at how the iproute2 tool[2] does
it, via the tool rtmon or "ip monitor" command (man ip-monitor) like:

 $ ip mon neigh
 192.168.100.1 dev mlx5p1 lladdr e4:1d:2d:af:60:80 REACHABLE

For the C-code look at ip/ipmonitor.c [3] and e.g. print_neigh() in
ip/ipneigh.c [4].

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samples/bpf/xdp_ddos01_blacklist_kern.c#L245-L249
[2] https://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
[3] https://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git/tree/ip/ipmonitor.c
[4] https://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git/tree/ip/ipneigh.c#n194
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
