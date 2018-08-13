Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:46458 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbeHMK3S (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 13 Aug 2018 06:29:18 -0400
Received: by mail-qt0-f195.google.com with SMTP id d4-v6so16386024qtn.13
        for <xdp-newbies@vger.kernel.org>; Mon, 13 Aug 2018 00:48:13 -0700 (PDT)
MIME-Version: 1.0
References: <CA+N+6-y-QAEj3f6C2onuvymNOwPiShMDcikqVnX5KaKUCeyTVA@mail.gmail.com>
 <CA+MxhDfJNDBn9n0q07dNuN6oLVouJZmu1XL8o7M96ZEtotdPzQ@mail.gmail.com>
 <472b24a2-0ed3-3811-e8a5-45c23b9028b0@iogearbox.net> <08fbf2cc-c804-78c5-7806-e1c593b2c1cd@iogearbox.net>
In-Reply-To: <08fbf2cc-c804-78c5-7806-e1c593b2c1cd@iogearbox.net>
From: Chang-an Song <csongxdp@gmail.com>
Date: Mon, 13 Aug 2018 16:48:02 +0900
Message-ID: <CA+MxhDdj7LFea7d9L8Aa5ciFB2vnL3pwPev33Gg+X9fRyEcEdQ@mail.gmail.com>
Subject: Re: veth interface and native XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: daniel@iogearbox.net
Cc: Manohar Kumar <forwardinglnx@gmail.com>, xdp-newbies@vger.kernel.org

Hello Danial

>The 4.15 kernel does not have native XDP support in the kernel, so
>only generic XDP would work for veth. Native XDP for veth is scheduled
>for 4.19 kernel. You can test it out from bpf-next kernel tree here:

>git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
>Related merge commit for reference:

>https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=60afdf066a35317efd5d1d7ae7c7f4ef2b32601f

Thank you very much for sharing information, :-)
I fully agree.

BR/Leo
On Mon, Aug 13, 2018 at 4:13 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 08/13/2018 09:10 AM, Daniel Borkmann wrote:
> > Hi Manohar, hi Leo,
> >
> > On 08/13/2018 07:51 AM, Chang-an Song wrote:
> >> Hello Manohar
> >>
> >> I also tried the same test, and the following error message came out.
> >> If possible,
> >> Could you let me know where did you find native XDP support for the
> >> veth interface in 4.15 kernel?
> >
> > The 4.15 kernel does not have native XDP support in the kernel, so
>
> (Just to be clear, for veth specifically I mean here.)
>
> > only generic XDP would work for veth. Native XDP for veth is scheduled
> > for 4.19 kernel. You can test it out from bpf-next kernel tree here:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
>
> Related merge commit for reference:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=60afdf066a35317efd5d1d7ae7c7f4ef2b32601f
>
> >> # ip -force link set dev veth1 xdpdrv obj test_xdp_redirect.o sec
> >> redirect_to_222
> >> RTNETLINK answers: Operation not supported
> >>
> >> # uname -a
> >> Linux xdptest 4.17.0-rc7+ #4 SMP Mon Aug 13 13:41:24 KST 2018 x86_64
> >> x86_64 x86_64 GNU/Linux
> >>
> >>
> >> This is the native XDP list I know as below,
> >> - Mellanox: mlx4 (v4.10) + mlx5 (v4.9)
> >> - Netronome: nfp (v4.10)
> >> - Virtio-net (v4.10)
> >> - Cavium/Qlogic: qede (v4.10)
> >> - Cavium: thunder/nicvf (v4.12)
> >> - Broadcom: bnxt (v4.12)
> >> - Intel: ixgbe (v4.12) + i40e (net-next)
> >
> > There are a couple missing, for full list please see:
> >
> >   http://cilium.readthedocs.io/en/latest/bpf/#xdp
> >
> > Thanks,
> > Daniel
> >
> >> If I am incorrect information, please tell me, again.
> >>
> >> BR/Leo
> >>
> >> On Sun, Aug 12, 2018 at 4:22 PM Manohar Kumar <forwardinglnx@gmail.com> wrote:
> >>>
> >>> Hello,
> >>>
> >>> I am trying out XDP using the example
> >>> https://github.com/torvalds/linux/blob/master/tools/testing/selftests/bpf/test_xdp_redirect.sh
> >>>
> >>> To set the xdp program instead of using xdpgeneric I did
> >>>
> >>> ip link set dev veth1 xdp obj test_xdp_redirect.o sec redirect_to_222
> >>>
> >>> My kernel version is 4.15.0 which I think has native XDP support for
> >>> veth. But from the ip link ouptut it looks like the generic XDP is
> >>> being used and not the native XDP for veth.
> >>>
> >>> What is the right way to make use of the native XDP for veth ?
> >>>
> >>> root@ubuntu-G551JW:~# ip link show dev veth1
> >>> 111: veth1@if18: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric
> >>> qdisc noqueue state UP mode DEFAULT group default qlen 1000
> >>>     link/ether c2:ff:f4:d9:15:8f brd ff:ff:ff:ff:ff:ff link-netnsid 0
> >>>     prog/xdp id 32 tag d92aa6f7de3bd7d0 jited
> >>> root@ubuntu-G551JW:~#
> >>>
> >>> Thanks for the help.
> >>>
> >>> -Kumar
> >
>
