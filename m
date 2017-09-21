Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41388 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbdIUTgN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Sep 2017 15:36:13 -0400
Message-ID: <59C414AA.8000600@iogearbox.net>
Date: Thu, 21 Sep 2017 21:36:10 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: [iovisor-dev] [PATCH RFC 0/4] Initial 32-bit eBPF encoding support
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com> <59C03AC5.3080109@iogearbox.net> <f7eb81db-a758-d49d-4c09-08a017b02e98@netronome.com> <20170921185654.v7nynvebxjpzbnlj@ast-mbp>
In-Reply-To: <20170921185654.v7nynvebxjpzbnlj@ast-mbp>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, yhs@fb.com

On 09/21/2017 08:56 PM, Alexei Starovoitov wrote:
> On Wed, Sep 20, 2017 at 12:20:40AM +0100, Jiong Wang via iovisor-dev wrote:
>> On 18/09/2017 22:29, Daniel Borkmann wrote:
>>> On 09/18/2017 10:47 PM, Jiong Wang wrote:
>>>> Hi,
>>>>
>>>>     Currently, LLVM eBPF backend always generate code in 64-bit mode,
>>>> this may
>>>> cause troubles when JITing to 32-bit targets.
>>>>
>>>>     For example, it is quite common for XDP eBPF program to access
>>>> some packet
>>>> fields through base + offset that the default eBPF will generate
>>>> BPF_ALU64 for
>>>> the address formation, later when JITing to 32-bit hardware,
>>>> BPF_ALU64 needs
>>>> to be expanded into 32 bit ALU sequences even though the address
>>>> space is
>>>> 32-bit that the high bits is not significant.
>>>>
>>>>     While a complete 32-bit mode implemention may need an new ABI
>>>> (something like
>>>> -target-abi=ilp32), this patch set first add some initial code so we
>>>> could
>>>> construct 32-bit eBPF tests through hand-written assembly.
>>>>
>>>>     A new 32-bit register set is introduced, its name is with "w"
>>>> prefix and LLVM
>>>> assembler will encode statements like "w1 += w2" into the following
>>>> 8-bit code
>>>> field:
>>>>
>>>>       BPF_ADD | BPF_X | BPF_ALU
>>>>
>>>> BPF_ALU will be used instead of BPF_ALU64.
>>>>
>>>>     NOTE, currently you can only use "w" register with ALU
>>>> statements, not with
>>>> others like branches etc as they don't have different encoding for
>>>> 32-bit
>>>> target.
>>>
>>> Great to see work in this direction! Can we also enable to use / emit
>>> all the 32bit BPF_ALU instructions whenever possible for the currently
>>> available bpf targets while at it (which only use BPF_ALU64 right now)?
>>
>> Hi Daniel,
>>
>>     Thanks for the feedback.
>>
>>     I think we could also enable the use of all the 32bit BPF_ALU under
>> currently
>> available bpf targets.  As we now have 32bit register set support, we could
>> make
>> i32 type as legal type to prevent it be promoted into i64, then hook it up
>> with i32
>> ALU patterns, will look into this.
>
> I don't think we need to gate 32bit alu generation with a flag.
> Though interpreter and JITs support 32-bit since day one, the verifier
> never seen such programs before, so some valid programs may get
> rejected. After some time passes and we're sure that all progs
> still work fine when they're optimized with 32-bit alu, we can flip
> the switch in llvm and make it default.

Sounds good to me! Could this be done for bpf target via -mattr=+alu32
feature flag or similar in llc?
