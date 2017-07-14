Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:55615 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdGNIq0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jul 2017 04:46:26 -0400
Date: Fri, 14 Jul 2017 10:46:22 +0200 (CEST)
From: tom.barbette@ulg.ac.be
Message-ID: <1702257840.29879018.1500021982749.JavaMail.zimbra@ulg.ac.be>
In-Reply-To: <CAPWQB7Gb12L6FuP5LbVUXQLodzdv3j_T2FO57gCz17ZE1ktidQ@mail.gmail.com>
References: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be> <5967DBC3.5060509@iogearbox.net> <CAPWQB7Gb12L6FuP5LbVUXQLodzdv3j_T2FO57gCz17ZE1ktidQ@mail.gmail.com>
Subject: Re: XDP for Kernel by-pass?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Joe Stringer <joe@ovn.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org

Thanks all of you for your very clear answers.

Then I would like to ask why so close to removing the need for DPDK, Netmap and friends it has been avoided on purpose? I know this question has been a little touchy in the past. But I'm really wondering about the motivation behind "BPF-only". 

If the goal is to want programs to be executed in a safe environment, do you believe that full IPS programs like Snort (which is also a use case for kernel by-pass as it implements its own stack) would even be one day implementable in a eeeBPF program?

Netmap hooks exactly where XDP does. We would just need a little shared-memory module that hooks in XDP and give all the raw packets to a userspace program. And then bye bye DPDK, Netmap, PF_RING and the others and we forget about those crazy years where everybody had his own framework to bypass the kernel.

Tom

----- Mail original -----
> De: "Joe Stringer" <joe@ovn.org>
> À: "Daniel Borkmann" <daniel@iogearbox.net>
> Cc: "tom barbette" <tom.barbette@ulg.ac.be>, xdp-newbies@vger.kernel.org
> Envoyé: Jeudi 13 Juillet 2017 23:07:07
> Objet: Re: XDP for Kernel by-pass?

> On 13 July 2017 at 13:44, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 07/13/2017 09:34 PM, tom.barbette@ulg.ac.be wrote:
>>>
>>> Hi all,
>>>
>>> Can XDP be used for "skbuff bypass"? Like a rx_handler but closer to the
>>> driver? I'm not very familiar with eBPF, could it be used to pass the kernel
>>> to any kernel module or userspace application?
>>>
>>> It looks to me that bpf_func in struct bpf_prog could be any function that
>>> we could use to deviate XDP and use it for that purpose. Correct?
>>>
>>> Kernel app like Click or OVS could benefit from that as they don't use
>>> most skbuff facilities.
>>
>>
>> You can do a lot of things with eBPF already e.g. take a look at the kernel
>> BPF sample code or BPF selftests e.g. test_l4lb.c, test_xdp.c, etc, or
>> projects like cilium that get compiled from C to BPF bytecode. BPF and XDP
>> is heavily tied together and part of the core kernel, so modular code/hooks
>> like third party kernel modules are not possible. Also f.e. wrt to user
>> space
>> one of the use cases is that you don't need to cross boundaries in the first
>> place when you preprocess in XDP and e.g. apply policy to drop unrelated
>> packets early while remaining ones are forwarded to containers, etc. There's
>> wip to have an OVS data path in BPF/XDP. I currently don't find the slides,
>> but Quentin did a good coverage on it from the last workshop [1], so worth
>> to read up a bit on the topic.
>>
>>   [1]
>> https://qmonnet.github.io/whirl-offload/2017/03/03/iovisor-summit-summary/
> 
> Right, from OVS perspective this is a pretty good summary of the
> current state: it's still an uphill battle with regards to verifier
> complexity, and there's reasonably large unsolved problems such as
> connection tracking; megaflows isn't there; and we haven't got to a
> point where we can observe performance parity with existing in-kernel
> solutions yet. That's just things we're aware of right now. In some
> perfect would it would be simple as dragging and dropping existing
> kernel code into the eBPF environment, but I'm sure that one of the
> first things you'll learn on this xdp-newbies list is that everything
> you want to put in eBPF/XDP needs to be rewritten from scratch with
> the verifier in mind.
