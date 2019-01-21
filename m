Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from turquesa.dcc.ufmg.br ([150.164.0.150]:45204 "EHLO
        smtp.dcc.ufmg.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfAURKv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Jan 2019 12:10:51 -0500
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by smtp.dcc.ufmg.br (Postfix) with ESMTPSA id 2EB6C7F75A
        for <xdp-newbies@vger.kernel.org>; Mon, 21 Jan 2019 15:10:49 -0200 (-02)
Received: by mail-io1-f54.google.com with SMTP id s22so16917155ioc.8
        for <xdp-newbies@vger.kernel.org>; Mon, 21 Jan 2019 09:10:49 -0800 (PST)
MIME-Version: 1.0
From: Matheus Salgueiro Castanho <matheus.castanho@dcc.ufmg.br>
Date: Mon, 21 Jan 2019 15:10:36 -0200
Message-ID: <CAPyJoHkGzwc7LhH5kz=GHP3V8CK8EAZgy0X2TavhRXBGUOZFdA@mail.gmail.com>
Subject: Encapsulation operation on TX
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I've recently begun playing around with BPF and XDP. Right now I'm
trying to write BPF programs to perform encap/decap of a custom
protocol I'm using to transport packets over the network, creating
something like a tunnel. The packet looks like this:

| Outer encapsulation | Original packet |

Upon reception, a program loaded on XDP removes this external
encapsulation, leaving only the original packet, which is processed by
the server and then sent back to the network. However, I need to
re-add this outer encapsulation before sending the packet.

I found out I can do this using L3 using routing rules, like this:
          ip route add <IP-address> encap bpf headroom <size>  xmit
obj <bpf-obj> section <sec-name> dev <iface>

The problem with this approach is that at this level I cannot add my
tunnel properly, which should come before Ethernet header. And from my
tests, this does not work with raw sockets (could be mistaken,
though).

Ideally, this should be done right before the packet reaches the NIC,
at the lowest layer possible, since the Linux kernel does not
recognize this external encapsulation. I then would need something
like "XDP on TX", which as far as I know doesn't exist.

I was able to implement this functionality at the Traffic Control (TC)
layer, but could not find an equivalent helper funcion to
bpf_xdp_adjust_head() on TC. I ended up using a "hack", calling
bpf_skb_vlan_push() several times and reorganizing and re-writing the
initial headers. No surprise the performance ended up not being really
good, plus some side-effects.

My question is: is there a better way to do this encapsulation on TX?
If not, what would be the steps to implement a basic "XDP on TX" on
the Linux kernel to support this? Although new to kernel programming
I've spent a good amount of time reading through BPF-related pieces of
code in the kernel, so I have a basic idea of how things are
implemented, but would like to hear from more experienced developers
than me.

Thank you very much,
Matheus Castanho
