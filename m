Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34762 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfA3FF3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 30 Jan 2019 00:05:29 -0500
Received: by mail-pg1-f195.google.com with SMTP id j10so9841757pga.1
        for <xdp-newbies@vger.kernel.org>; Tue, 29 Jan 2019 21:05:29 -0800 (PST)
Subject: Re: Encapsulation operation on TX
References: <CAPyJoHkGzwc7LhH5kz=GHP3V8CK8EAZgy0X2TavhRXBGUOZFdA@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <130c1ca5-5e3a-7f04-2146-bf50495bf286@gmail.com>
Date: Tue, 29 Jan 2019 22:05:26 -0700
MIME-Version: 1.0
In-Reply-To: <CAPyJoHkGzwc7LhH5kz=GHP3V8CK8EAZgy0X2TavhRXBGUOZFdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Matheus Salgueiro Castanho <matheus.castanho@dcc.ufmg.br>, xdp-newbies@vger.kernel.org
Cc: Peter Oskolkov <posk@google.com>

On 1/21/19 10:10 AM, Matheus Salgueiro Castanho wrote:
> Hi all,
> 
> I've recently begun playing around with BPF and XDP. Right now I'm
> trying to write BPF programs to perform encap/decap of a custom
> protocol I'm using to transport packets over the network, creating
> something like a tunnel. The packet looks like this:
> 
> | Outer encapsulation | Original packet |
> 
> Upon reception, a program loaded on XDP removes this external
> encapsulation, leaving only the original packet, which is processed by
> the server and then sent back to the network. However, I need to
> re-add this outer encapsulation before sending the packet.
> 
> I found out I can do this using L3 using routing rules, like this:
>           ip route add <IP-address> encap bpf headroom <size>  xmit
> obj <bpf-obj> section <sec-name> dev <iface>
> 
> The problem with this approach is that at this level I cannot add my
> tunnel properly, which should come before Ethernet header. And from my
> tests, this does not work with raw sockets (could be mistaken,
> though).
> 
> Ideally, this should be done right before the packet reaches the NIC,
> at the lowest layer possible, since the Linux kernel does not
> recognize this external encapsulation. I then would need something
> like "XDP on TX", which as far as I know doesn't exist.
> 
> I was able to implement this functionality at the Traffic Control (TC)
> layer, but could not find an equivalent helper funcion to
> bpf_xdp_adjust_head() on TC. I ended up using a "hack", calling
> bpf_skb_vlan_push() several times and reorganizing and re-writing the
> initial headers. No surprise the performance ended up not being really
> good, plus some side-effects.
> 
> My question is: is there a better way to do this encapsulation on TX?
> If not, what would be the steps to implement a basic "XDP on TX" on
> the Linux kernel to support this? Although new to kernel programming
> I've spent a good amount of time reading through BPF-related pieces of
> code in the kernel, so I have a basic idea of how things are
> implemented, but would like to hear from more experienced developers
> than me.
> 
> Thank you very much,
> Matheus Castanho
> 

Peter is looking at something similar but with the assumption that it is
still ipv4/ipv6 based:

http://patchwork.ozlabs.org/project/netdev/list/?series=88701

I do not believe it is easy to relax the v4/v6 assumption.

Another option is to look at MPLS ingressing to a label switch path:
net/mpls/mpls_iptunnel.c

It does something very similar to what you want -- prepending an MPLS
label stack to a packet and then transmitting. Not bpf/XDP but an option
to consider.
