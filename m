Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:37316 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfBRVvR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Feb 2019 16:51:17 -0500
Subject: Re: Interruption in eBPF program after kernel update
From: Daniel Borkmann <daniel@iogearbox.net>
References: <96e834867100a5ae9a941c639ef93456a2600021.camel@regit.org>
 <509b74cb74f13b02122707d2505e5c690866b159.camel@regit.org>
 <CAADnVQ+5KbWJqwOWVGGBwfX7h+1r7287452_Scrud8N8iR3Gow@mail.gmail.com>
 <aecce2b7-a14d-b649-f180-2c43f30096f7@iogearbox.net>
Message-ID: <f0167cf4-6cad-2e1b-01ff-0dfb9d108852@iogearbox.net>
Date: Mon, 18 Feb 2019 22:51:14 +0100
MIME-Version: 1.0
In-Reply-To: <aecce2b7-a14d-b649-f180-2c43f30096f7@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi Eric,

On 02/15/2019 02:07 PM, Daniel Borkmann wrote:
> On 02/14/2019 10:37 PM, Alexei Starovoitov wrote:
>> On Thu, Feb 14, 2019 at 10:33 AM Eric Leblond <eric@regit.org> wrote:
>>>
>>> Hello,
>>>
>>> On Wed, 2019-02-13 at 20:46 +0100, Eric Leblond wrote:
>>>> Hello,
>>>>
>>>> I've got a simple socket filter program that seems to interrupt when
>>>> calling the load_word construct. I'm seeing the first message but
>>>> never
>>>> the second one.
>>>>
>>>> The code is the following
>>>>
>>>> int SEC("filter") hashfilter(struct __sk_buff *skb) {
>>>>     __u32 nhoff = BPF_LL_OFF + ETH_HLEN;
>>>
>>> So it seems the problem was coming from this line. Removing BPF_LL_OFF
>>> fixes the problem for kernel starting 4.18.
>>>
>>> Is this a known issue ?
>>>
>>> Is there something that would allow a BPF file to work independently of
>>> the kernel version ?
>>
>> Daniel,
>> can this be related to removal of ld_abs legacy ?
> 
> Hm, strange, I'll take a look.

Do you have a concrete stand-alone reproducer? Works fine for me on
latest bpf tree at least (internal code gen is same for filter and
tc BPF) ...

# pwd
/root/iproute2/examples/bpf
# cat foo.c
#include <stdio.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include "../../include/bpf_api.h"

__section_cls_entry
int cls_entry(struct __sk_buff *skb)
{
    __u32 nhoff = BPF_LL_OFF + ETH_HLEN;
    __u32 ip = 0;
    __u32 *value = NULL;
#if 1
    char fmtrei[] = "word load\n";
    trace_printk(fmtrei, sizeof(fmtrei));
#endif
    ip = load_word(skb, nhoff + offsetof(struct iphdr, saddr));
#if 1
    char fmti[] = "work done\n";
    trace_printk(fmti, sizeof(fmti));
#endif
    return TC_ACT_OK;
}

BPF_LICENSE("GPL");
# clang -target bpf -O2 -Wall -c foo.c -o foo.o -I ../../include/uapi/
# tc qdisc add dev bond0 clsact
# tc filter add dev bond0 ingress bpf da obj ./foo.o
# tc exec bpf dbg
[...]
          <idle>-0     [005] .Ns. 21102.794996: 0: work done
          <idle>-0     [005] ..s. 21102.796023: 0: word load
          <idle>-0     [005] .Ns. 21102.796045: 0: work done
          <idle>-0     [005] ..s. 21102.807417: 0: word load
          <idle>-0     [005] .Ns. 21102.807438: 0: work done
          <idle>-0     [005] ..s. 21102.808365: 0: word load
          <idle>-0     [005] .Ns. 21102.808387: 0: work done
          <idle>-0     [005] ..s. 21102.819905: 0: word load
          <idle>-0     [005] .Ns. 21102.819923: 0: work done
          <idle>-0     [005] ..s. 21102.820626: 0: word load
          <idle>-0     [005] .Ns. 21102.820646: 0: work done
          <idle>-0     [005] ..s. 21102.832293: 0: word load
          <idle>-0     [005] .Ns. 21102.832314: 0: work done
[...]
# uname -a
Linux test2 5.0.0-rc6+ #1 SMP Mon Feb 18 13:06:11 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
# llc --version
[...]
  LLVM version 3.8.0
# cat /proc/sys/net/core/bpf_jit_enable
1

Thanks,
Daniel
