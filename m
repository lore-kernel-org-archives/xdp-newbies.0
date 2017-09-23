Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:51171 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdIWOnG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 23 Sep 2017 10:43:06 -0400
Received: by mail-vk0-f41.google.com with SMTP id p204so1823684vkp.7
        for <xdp-newbies@vger.kernel.org>; Sat, 23 Sep 2017 07:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170923104125.3905f545@cakuba>
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
 <59C03AC5.3080109@iogearbox.net> <f7eb81db-a758-d49d-4c09-08a017b02e98@netronome.com>
 <20170921185654.v7nynvebxjpzbnlj@ast-mbp> <20170922182410.71701aee@cakuba>
 <1b6518ff-9d66-f911-4a3c-d762d88919ec@fb.com> <20170923104125.3905f545@cakuba>
From: Y Song <ys114321@gmail.com>
Date: Sat, 23 Sep 2017 07:42:22 -0700
Message-ID: <CAH3MdRUZLQBUGMSguNm9T9SS3J56S2pNAo7fdh9hAoBL4Dif0g@mail.gmail.com>
Subject: Re: [iovisor-dev] [PATCH RFC 0/4] Initial 32-bit eBPF encoding support
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Yonghong Song <yhs@fb.com>, xdp-newbies@vger.kernel.org, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>, LLVM Developers Mailing List <llvm-dev@lists.llvm.org>, oss-drivers@netronome.com

On Sat, Sep 23, 2017 at 1:41 AM, Jakub Kicinski via iovisor-dev
<iovisor-dev@lists.iovisor.org> wrote:
> On Fri, 22 Sep 2017 22:03:47 -0700, Yonghong Song wrote:
>> On 9/22/17 9:24 AM, Jakub Kicinski wrote:
>> > On Thu, 21 Sep 2017 11:56:55 -0700, Alexei Starovoitov wrote:
>> >> On Wed, Sep 20, 2017 at 12:20:40AM +0100, Jiong Wang via iovisor-dev wrote:
>> >>> On 18/09/2017 22:29, Daniel Borkmann wrote:
>> >>>> On 09/18/2017 10:47 PM, Jiong Wang wrote:
>> >>>>> Hi,
>> >>>>>
>> >>>>>     Currently, LLVM eBPF backend always generate code in 64-bit mode,
>> >>>>> this may
>> >>>>> cause troubles when JITing to 32-bit targets.
>> >>>>>
>> >>>>>     For example, it is quite common for XDP eBPF program to access
>> >>>>> some packet
>> >>>>> fields through base + offset that the default eBPF will generate
>> >>>>> BPF_ALU64 for
>> >>>>> the address formation, later when JITing to 32-bit hardware,
>> >>>>> BPF_ALU64 needs
>> >>>>> to be expanded into 32 bit ALU sequences even though the address
>> >>>>> space is
>> >>>>> 32-bit that the high bits is not significant.
>> >>>>>
>> >>>>>     While a complete 32-bit mode implemention may need an new ABI
>> >>>>> (something like
>> >>>>> -target-abi=ilp32), this patch set first add some initial code so we
>> >>>>> could
>> >>>>> construct 32-bit eBPF tests through hand-written assembly.
>> >>>>>
>> >>>>>     A new 32-bit register set is introduced, its name is with "w"
>> >>>>> prefix and LLVM
>> >>>>> assembler will encode statements like "w1 += w2" into the following
>> >>>>> 8-bit code
>> >>>>> field:
>> >>>>>
>> >>>>>       BPF_ADD | BPF_X | BPF_ALU
>> >>>>>
>> >>>>> BPF_ALU will be used instead of BPF_ALU64.
>> >>>>>
>> >>>>>     NOTE, currently you can only use "w" register with ALU
>> >>>>> statements, not with
>> >>>>> others like branches etc as they don't have different encoding for
>> >>>>> 32-bit
>> >>>>> target.
>> >>>>
>> >>>> Great to see work in this direction! Can we also enable to use / emit
>> >>>> all the 32bit BPF_ALU instructions whenever possible for the currently
>> >>>> available bpf targets while at it (which only use BPF_ALU64 right now)?
>> >>>
>> >>> Hi Daniel,
>> >>>
>> >>>     Thanks for the feedback.
>> >>>
>> >>>     I think we could also enable the use of all the 32bit BPF_ALU under
>> >>> currently
>> >>> available bpf targets.  As we now have 32bit register set support, we could
>> >>> make
>> >>> i32 type as legal type to prevent it be promoted into i64, then hook it up
>> >>> with i32
>> >>> ALU patterns, will look into this.
>> >>
>> >> I don't think we need to gate 32bit alu generation with a flag.
>> >> Though interpreter and JITs support 32-bit since day one, the verifier
>> >> never seen such programs before, so some valid programs may get
>> >> rejected. After some time passes and we're sure that all progs
>> >> still work fine when they're optimized with 32-bit alu, we can flip
>> >> the switch in llvm and make it default.
>> >
>> > Thinking about next steps - do we expect the 32b operations to clear the
>> > upper halves of the registers?  The interpreter does it, and so does
>> > x86.  I don't think we can load 32bit-only programs on 64bit hosts, so
>> > we would need some form of data flow analysis in the kernel to prune
>> > the zeroing for 32bit offload targets.  Is that correct?
>>
>> Could you contrive an example to show the problem? If I understand
>> correctly, you most worried that some natural sign extension is gone
>> with "clearing the upper 32-bit register" and such clearing may make
>> some operation, esp. memory operation not correct in 64-bit machine?
>
> Hm.  Perhaps it's a blunder on my side, but let's take:
>
>   r1 = ~0ULL
>   w1 = 0
>   # use r1
>
> on x86 and the interpreter, the w1 = 0 will clear upper 32bits, so r1
> ends up as 0.  32b arches may translate this to something like:
>
>   # r1 = ~0ULL
>   r1.lo = ~0
>   r1.hi = ~0
>   # w1 = 0
>   r1.lo = 0
>   # r1.hi not touched
>
> which will obviously result in r1 == 0xffffffff00000000.  LLVM should
> not assume r1.hi is cleared, but I'm not sure this is a strong enough
> argument.

Not sure what LLVM will do in this case  for later "r1" access
unless going through the real implementation. My hunch is LLVM
should do a conversion from 32bit to 64bit, "r1 <<= 32" and
"r1 >>= 32" after "w1 = 0" before using r1. Let us wait and check
once implementation in place.

> _______________________________________________
> iovisor-dev mailing list
> iovisor-dev@lists.iovisor.org
> https://lists.iovisor.org/mailman/listinfo/iovisor-dev
