Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:38058 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdH3VvB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 30 Aug 2017 17:51:01 -0400
Received: by mail-pg0-f45.google.com with SMTP id b8so23411256pgn.5
        for <xdp-newbies@vger.kernel.org>; Wed, 30 Aug 2017 14:51:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59A72D3E.1030909@iogearbox.net>
References: <CAC1LvL0WgC0bqEuGHp+LepyajskFdAkPruKY-9F6rL=zf49RKw@mail.gmail.com>
 <CAH3MdRWk5R1DtUcPBbpNSv3kB-jJjP6RFUccRvqFS_7SZLnwzA@mail.gmail.com>
 <CAC1LvL0Nc7dKdbmH+FbURycGpyrWar9emmbyReSOrVobdbGJhw@mail.gmail.com>
 <CAH3MdRW8C=rSPCeoCix1hbM-E1mkhC1DcRoMy_+s8dqNvz=nNQ@mail.gmail.com>
 <CAC1LvL0fWaQy0Roo_SH_c1L2X+-3Bi9pjTYzTKJQaa8GGoormA@mail.gmail.com>
 <CAH3MdRV7ciyfAy9nB2jLpSX0Qb-W8hDK2nCNykkVRyX8mS2mBQ@mail.gmail.com>
 <59A5F609.4090403@iogearbox.net> <CAC1LvL3svMDXSxe3ThoiDFe8f1mQwU8VhPp+2wtQ9gp2Wdg+Xg@mail.gmail.com>
 <59A72D3E.1030909@iogearbox.net>
From: Zvi Effron <zeffron@riotgames.com>
Date: Wed, 30 Aug 2017 14:50:59 -0700
Message-ID: <CAC1LvL1Kj6Q+XHm-RJdgoivTVCJQf-p1dyQ1DpG6ULjAd38rEQ@mail.gmail.com>
Subject: Re: Issues with bpf_trace_printk
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Y Song <ys114321@gmail.com>, xdp-newbies@vger.kernel.org

I managed to set up my configuration with a VM on VMware Workstation,
and it did not reproduce the bug. I think it was using one of the
Intel drivers, though, instead of the generic. Is there a way to force
the use of the generic driver?

--Zvi

On Wed, Aug 30, 2017 at 2:25 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 08/30/2017 07:53 PM, Zvi Effron wrote:
>>
>> I've uploaded the object file to
>>
>> https://drive.google.com/file/d/0B-lMs4mJOgQBU090ZzNtSkVnMTQ/view?usp=sharing
>>
>> uname -a output: Linux localhost.localdomain 4.12.8-300.fc26.x86_64 #1
>> SMP Thu Aug 17 15:30:20 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>> ip -V output: ip utility, iproute2-ss170501
>>
>> I tried with latest iproute2 built from source (ip -V output: ip
>> utility, iproute2-ss170705) and am still having the same issue. (I
>> also first noticed this with a custom loader I wrote, so I think the
>> loader can probably be ruled out.)
>>
>> sysctl -a 2> /dev/null | grep bpf output:
>> kernel.unprivileged_bpf_disabled = 0
>> net.core.bpf_jit_enable = 0
>> net.core.bpf_jit_harden = 0
>> net.core.bpf_jit_kallsyms = 0
>>
>> Thanks for helping look into this! Let me know if you need any more info.
>
>
> Here are my results with your object file; seems to work fine
> for me there, good but still strange. ;) I took the actual 4.12.8
> stable kernel.
>
> # uname -a
> Linux linux-2.home 4.12.8 #1 SMP Wed Aug 30 21:27:51 CEST 2017 x86_64 x86_64
> x86_64 GNU/Linux
> # ip -V
> ip utility, iproute2-ss170705
> # sysctl -a | grep bpf
> kernel.unprivileged_bpf_disabled = 0
> net.core.bpf_jit_enable = 0
> net.core.bpf_jit_harden = 0
> net.core.bpf_jit_kallsyms = 0
> # ip link set dev wlp4s0 xdpgeneric obj ./xdp_test_kern.o sec .text
> # tc exec bpf dbg                     # cmd is just finding mount and
> dumping trace pipe
> Running! Hang up with ^C!
>
>  irq/131-iwlwifi-710   [003] ....   892.116200: : Data start: 90941a    Data
> end: 909456
>  irq/131-iwlwifi-710   [003] ....   892.116216: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   893.346855: : Data start: 90801a    Data
> end: 908044
>  irq/131-iwlwifi-710   [003] ....   893.346871: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   893.346917: : Data start: 90801a    Data
> end: 908070
>  irq/131-iwlwifi-710   [003] ....   893.346921: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   893.654076: : Data start: 90801a    Data
> end: 908044
>  irq/131-iwlwifi-710   [003] ....   893.654092: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   901.333823: : Data start: 88dfc1a   Data
> end: 88dfcb8
>  irq/131-iwlwifi-710   [003] ....   901.333839: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   907.578693: : Data start: 90801a    Data
> end: 90804c
>  irq/131-iwlwifi-710   [003] ....   907.578722: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   908.192621: : Data start: 90801a    Data
> end: 908044
>  irq/131-iwlwifi-710   [003] ....   908.192634: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   908.192696: : Data start: 90801a    Data
> end: 908070
>  irq/131-iwlwifi-710   [003] ....   908.192701: : Constant: 1
>  irq/131-iwlwifi-710   [003] ....   908.920655: : Data start: 90801a    Data
> end: 908044
>  irq/131-iwlwifi-710   [003] ....   908.920661: : Constant: 1
> [...]
>
> I attached the config I used just in case you want to try
> building 4.12.8 kernel whether that changes anything. Would
> be interesting to see.
