Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35697 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdL3XQl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 30 Dec 2017 18:16:41 -0500
Received: by mail-qk0-f195.google.com with SMTP id 143so41617449qki.2
        for <xdp-newbies@vger.kernel.org>; Sat, 30 Dec 2017 15:16:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFg6RxseDm=-ofyYmvuOYwY01d8XAuw92tO4MHqGHcekC1Q2Tw@mail.gmail.com>
References: <CAFg6RxseDm=-ofyYmvuOYwY01d8XAuw92tO4MHqGHcekC1Q2Tw@mail.gmail.com>
From: Rob Sherwood <rob.sherwood@gmail.com>
Date: Sat, 30 Dec 2017 15:16:39 -0800
Message-ID: <CAFg6RxtNGt848a8t+benvNtcPfWRCE_rV8it5n30m=jdULs63w@mail.gmail.com>
Subject: Re: Running samples/bpf/xdp1 as root gives me EPERM !?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

[weird - Eric's response never made it into my inbox or spam account,
but I did see it in the mailing list archives...]

> Could it be a memlock limit issue ? Can you try something like
> ulimit  -l 100000000 to see if it fixes the problem ?
>
> BR,
> --
> Eric Leblond <eric@xxxxxxxxx>
> Blog: https://home.regit.org/

This did turn out to be the issue -- thank you for the fast reply!
Glad this is the 'newbies' list :-)

- Rob
.



On Sat, Dec 30, 2017 at 12:34 AM, Rob Sherwood <rob.sherwood@gmail.com> wrote:
> Hi,
>
> I'm running stock Ubuntu 17.10 on two roughly identical boxes (4.13.0
> kernel) and am trying to verify that my setup works by running the
> xdp1 example code that ships with the default kernel code
> (./samples/bpf/xdp1_{user,kern}.c).
>
> On one box (a bare metal server), the code works as expected.  But on
> the other box (a virtual machine), any of the bpf system calls return
> EPERM even though I'm running as root:
>
> root@ubuntu:~/linux-source-4.13.0/samples/bpf# strace ./xdp1 10 |& grep bpf
> bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_PERCPU_ARRAY, key_size=4,
> value_size=8, max_entries=256}, 48) = -1 EPERM (Operation not
> permitted)
>
> Both machines have identical kernel configs and sysctl settings.
>
> root@ubuntu:~# grep -i bpf /boot/config-4.13.0-21-generic
> CONFIG_CGROUP_BPF=y
> CONFIG_BPF=y
> CONFIG_BPF_SYSCALL=y
> CONFIG_NETFILTER_XT_MATCH_BPF=m
> CONFIG_NET_CLS_BPF=m
> CONFIG_NET_ACT_BPF=m
> CONFIG_BPF_JIT=y
> CONFIG_LWTUNNEL_BPF=y
> CONFIG_HAVE_EBPF_JIT=y
> CONFIG_BPF_EVENTS=y
> CONFIG_TEST_BPF=m
>
> I've even made sure that I can use promiscuous mode on the virtual
> machine (this requires extra permissions from the hypervisor), so
> that's not the problem.  The problem persists even if I try to attach
> the xdp code to a pure virtual interface (e.g., a veth pair).
>
> Any one have any guess what the problem could be?
>
> Thanks in advance,
>
> - Rob
> .
