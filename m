Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:40183 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbeHLJzf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 12 Aug 2018 05:55:35 -0400
Received: by mail-qt0-f181.google.com with SMTP id h4-v6so14454526qtj.7
        for <xdp-newbies@vger.kernel.org>; Sun, 12 Aug 2018 00:18:32 -0700 (PDT)
MIME-Version: 1.0
From: Manohar Kumar <forwardinglnx@gmail.com>
Date: Sun, 12 Aug 2018 00:18:29 -0700
Message-ID: <CA+N+6-y-QAEj3f6C2onuvymNOwPiShMDcikqVnX5KaKUCeyTVA@mail.gmail.com>
Subject: veth interface and native XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

I am trying out XDP using the example
https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bpf/test_xdp_redirect.sh

To set the xdp program instead of using xdpgeneric I did

ip link set dev veth1 xdp obj test_xdp_redirect.o sec redirect_to_222

My kernel version is 4.15.0 which I think has native XDP support for
veth. But from the ip link ouptut it looks like the generic XDP is
being used and not the native XDP for veth.

What is the right way to make use of the native XDP for veth ?

root@ubuntu-G551JW:~# ip link show dev veth1
111: veth1@if18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric
qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether c2:ff:f4:d9:15:8f brd ff:ff:ff:ff:ff:ff link-netnsid 0
    prog/xdp id 32 tag d92aa6f7de3bd7d0 jited
root@ubuntu-G551JW:~#

Thanks for the help.

-Kumar
