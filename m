Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:45470 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeHMIc0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 13 Aug 2018 04:32:26 -0400
Received: by mail-qk0-f196.google.com with SMTP id c192-v6so10180788qkg.12
        for <xdp-newbies@vger.kernel.org>; Sun, 12 Aug 2018 22:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <CA+N+6-y-QAEj3f6C2onuvymNOwPiShMDcikqVnX5KaKUCeyTVA@mail.gmail.com>
In-Reply-To: <CA+N+6-y-QAEj3f6C2onuvymNOwPiShMDcikqVnX5KaKUCeyTVA@mail.gmail.com>
From: Chang-an Song <csongxdp@gmail.com>
Date: Mon, 13 Aug 2018 14:51:32 +0900
Message-ID: <CA+MxhDfJNDBn9n0q07dNuN6oLVouJZmu1XL8o7M96ZEtotdPzQ@mail.gmail.com>
Subject: Re: veth interface and native XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: forwardinglnx@gmail.com
Cc: xdp-newbies@vger.kernel.org

Hello Manohar

I also tried the same test, and the following error message came out.
If possible,
Could you let me know where did you find native XDP support for the
veth interface in 4.15 kernel?

# ip -force link set dev veth1 xdpdrv obj test_xdp_redirect.o sec
redirect_to_222
RTNETLINK answers: Operation not supported

# uname -a
Linux xdptest 4.17.0-rc7+ #4 SMP Mon Aug 13 13:41:24 KST 2018 x86_64
x86_64 x86_64 GNU/Linux


This is the native XDP list I know as below,
- Mellanox: mlx4 (v4.10) + mlx5 (v4.9)
- Netronome: nfp (v4.10)
- Virtio-net (v4.10)
- Cavium/Qlogic: qede (v4.10)
- Cavium: thunder/nicvf (v4.12)
- Broadcom: bnxt (v4.12)
- Intel: ixgbe (v4.12) + i40e (net-next)

If I am incorrect information, please tell me, again.

BR/Leo

On Sun, Aug 12, 2018 at 4:22 PM Manohar Kumar <forwardinglnx@gmail.com> wrote:
>
> Hello,
>
> I am trying out XDP using the example
> https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bpf/test_xdp_redirect.sh
>
> To set the xdp program instead of using xdpgeneric I did
>
> ip link set dev veth1 xdp obj test_xdp_redirect.o sec redirect_to_222
>
> My kernel version is 4.15.0 which I think has native XDP support for
> veth. But from the ip link ouptut it looks like the generic XDP is
> being used and not the native XDP for veth.
>
> What is the right way to make use of the native XDP for veth ?
>
> root@ubuntu-G551JW:~# ip link show dev veth1
> 111: veth1@if18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric
> qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether c2:ff:f4:d9:15:8f brd ff:ff:ff:ff:ff:ff link-netnsid 0
>     prog/xdp id 32 tag d92aa6f7de3bd7d0 jited
> root@ubuntu-G551JW:~#
>
> Thanks for the help.
>
> -Kumar
