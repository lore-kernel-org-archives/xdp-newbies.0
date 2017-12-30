Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:32840 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdL3Ie2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 30 Dec 2017 03:34:28 -0500
Received: by mail-qk0-f174.google.com with SMTP id x7so37615810qkb.0
        for <xdp-newbies@vger.kernel.org>; Sat, 30 Dec 2017 00:34:28 -0800 (PST)
MIME-Version: 1.0
From: Rob Sherwood <rob.sherwood@gmail.com>
Date: Sat, 30 Dec 2017 03:34:26 -0500
Message-ID: <CAFg6RxseDm=-ofyYmvuOYwY01d8XAuw92tO4MHqGHcekC1Q2Tw@mail.gmail.com>
Subject: Running samples/bpf/xdp1 as root gives me EPERM !?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,

I'm running stock Ubuntu 17.10 on two roughly identical boxes (4.13.0
kernel) and am trying to verify that my setup works by running the
xdp1 example code that ships with the default kernel code
(./samples/bpf/xdp1_{user,kern}.c).

On one box (a bare metal server), the code works as expected.  But on
the other box (a virtual machine), any of the bpf system calls return
EPERM even though I'm running as root:

root@ubuntu:~/linux-source-4.13.0/samples/bpf# strace ./xdp1 10 |& grep bpf
bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_PERCPU_ARRAY, key_size=4,
value_size=8, max_entries=256}, 48) = -1 EPERM (Operation not
permitted)

Both machines have identical kernel configs and sysctl settings.

root@ubuntu:~# grep -i bpf /boot/config-4.13.0-21-generic
CONFIG_CGROUP_BPF=y
CONFIG_BPF=y
CONFIG_BPF_SYSCALL=y
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NET_CLS_BPF=m
CONFIG_NET_ACT_BPF=m
CONFIG_BPF_JIT=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_BPF_EVENTS=y
CONFIG_TEST_BPF=m

I've even made sure that I can use promiscuous mode on the virtual
machine (this requires extra permissions from the hypervisor), so
that's not the problem.  The problem persists even if I try to attach
the xdp code to a pure virtual interface (e.g., a veth pair).

Any one have any guess what the problem could be?

Thanks in advance,

- Rob
.
