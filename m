Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:38803 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdH2XRh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 29 Aug 2017 19:17:37 -0400
Message-ID: <59A5F609.4090403@iogearbox.net>
Date: Wed, 30 Aug 2017 01:17:29 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: Issues with bpf_trace_printk
References: <CAC1LvL0WgC0bqEuGHp+LepyajskFdAkPruKY-9F6rL=zf49RKw@mail.gmail.com> <CAH3MdRWk5R1DtUcPBbpNSv3kB-jJjP6RFUccRvqFS_7SZLnwzA@mail.gmail.com> <CAC1LvL0Nc7dKdbmH+FbURycGpyrWar9emmbyReSOrVobdbGJhw@mail.gmail.com> <CAH3MdRW8C=rSPCeoCix1hbM-E1mkhC1DcRoMy_+s8dqNvz=nNQ@mail.gmail.com> <CAC1LvL0fWaQy0Roo_SH_c1L2X+-3Bi9pjTYzTKJQaa8GGoormA@mail.gmail.com> <CAH3MdRV7ciyfAy9nB2jLpSX0Qb-W8hDK2nCNykkVRyX8mS2mBQ@mail.gmail.com>
In-Reply-To: <CAH3MdRV7ciyfAy9nB2jLpSX0Qb-W8hDK2nCNykkVRyX8mS2mBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>, Zvi Effron <zeffron@riotgames.com>
Cc: xdp-newbies@vger.kernel.org

On 08/29/2017 11:56 PM, Y Song wrote:
> I tried the test with the following:
>     . fc25 env but booted with latest net-next kernel (my developer env)
>     . clang/llvm 5.0 (build from source)
>     . latest iproute2 (build from source)
> and it works fine.
>
> I suggest you migrate to the latest (or above) environment and it should work.
> Otherwise, you could bisect and debug to see which component may have issues.
>
> On Mon, Aug 28, 2017 at 10:53 PM, Zvi Effron <zeffron@riotgames.com> wrote:
>> Generic XDP driver was introduced in the 4.12 kernel.
>> https://kernelnewbies.org/Linux_4.12#head-9f96b5e8262772d5e1908bf335fd25f4c3eec15a
>> If you run dnf update, it should pull down the 4.12 kernel on Fedora 26.
>>
>> --Zvi
>>
>> On Mon, Aug 28, 2017 at 10:39 PM, Y Song <ys114321@gmail.com> wrote:
>>> I tried on my FC26 VM. I actually got permission denied.
>>> I tried to attach the main interface enp0s3 (acting as eth0).
>>>
>>> The kernel is 4.11. I think generic xdp support is not there.
>>> Otherwise people can confirm?
>>> The VM interface enp0s3 (or eth0) may not have driver support for XDP.
>>>
>>> On Mon, Aug 28, 2017 at 3:12 PM, Zvi Effron <zeffron@riotgames.com> wrote:
>>>> Full reproduction instructions:
>>>>
>>>> 1) Install Fedora 26 server. I chose all of the default options,
>>>> except I chose to install latest packages from the network. Otherwise,
>>>> just run a dnf update after install. I installed into a VM running on
>>>> HyperV
>>>> 2) Install clang, llvm, and kernel-devel:
>>>>      dnf install -y clang llvm kernel-devel
>>>> 3) Copy the program to xdp_test_kern.c
>>>> 4) Compile the program into an elf object file:
>>>>      clang -S -O2 -Wall -Werror -nostdinc -isystem $(clang
>>>> -print-file-name=include) -I /lib/modules/$(uname
>>>> -r)/build/arch/x86/include  -I /lib/modules/$(uname
>>>> -r)/build/arch/x86/include/generated/uapi  -I /lib/modules/$(uname
>>>> -r)/build/arch/x86/include/generated  -I /lib/modules/$(uname
>>>> -r)/build/include  -I /lib/modules/$(uname
>>>> -r)/build/arch/x86/include/uapi  -I /lib/modules/$(uname
>>>> -r)/build/include/uapi  -I /lib/modules/$(uname
>>>> -r)/build/include/generated/uapi -include  /lib/modules/$(uname
>>>> -r)/build/include/linux/kconfig.h -D __KERNEL__ -c -emit-llvm -o
>>>> xdp_test_kern.ll xdp_test_kern.c
>>>>      llc -march bpf -filetype obj -o xdp_test_kern.o xdp_test_kern.ll
>>>> 5) Attach the program to eth0:
>>>>      ip link set dev eth0 xdp object xdp_test_kern.o section .text verbose
>>>> 6) Notice only 0s being printed for data in /sys/kernel/debug/tracing/trace_pipe
>>>>
>>>> As near as I can tell, the driver being used for eth0 is hv_netvsc, in
>>>> case it's an issue with the driver.

Any chance you could provide the object file itself that was used
for loading?

So it's basically 4.12 kernel with generic XDP on that driver as
you mentioned, right (must be given hv_netvsc doesn't have native
XDP ...)? Which stable version of that kernel do you use (uname -a)
and which iproute2 version (ip -V)?

Can you reproduce it with a latest iproute2 version from the git
tree, so we can rule out the loader?

What's the output of: sysctl -a 2> /dev/null | grep bpf

Thanks
