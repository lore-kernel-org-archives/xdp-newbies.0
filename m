Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:37398 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdHaSTN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 31 Aug 2017 14:19:13 -0400
Received: by mail-pg0-f52.google.com with SMTP id 83so1129971pgb.4
        for <xdp-newbies@vger.kernel.org>; Thu, 31 Aug 2017 11:19:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH3MdRUemaGqwMJ6oK=z+4x=+HSs6CptK91=duyV1fuYFVwuZw@mail.gmail.com>
References: <CAADnVQKuZSc3bzMSmsCZB1FLnmywOEhMECSu_yruCD+exq81Sw@mail.gmail.com>
 <CAH3MdRUemaGqwMJ6oK=z+4x=+HSs6CptK91=duyV1fuYFVwuZw@mail.gmail.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Thu, 31 Aug 2017 11:19:12 -0700
Message-ID: <CAC1LvL1ZLOFxSx2NDUwYVMERjEWemRPwnZJumNFjiZNyO9=b0g@mail.gmail.com>
Subject: Re: BPF assembler?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Jakub Kicinski <kubakici@wp.pl>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

Would this include support for inline eBPF asm in C eBPF programs?
That would be very nice for when new instructions are added to the
kernel that have yet to be given a builtin in clang (such as the new
BPF_END instructions).

--Zvi

On Wed, Aug 30, 2017 at 10:32 PM, Y Song <ys114321@gmail.com> wrote:
> Jakub,
>
> Let me know if you need additional help on this. I think this
> assembler->obj in llvm is the last
> major piece for a complete toolchain for clang/llvm.
>
> Thanks,
>
> Yonghong
>
> On Wed, Aug 30, 2017 at 9:37 PM, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Wed, Aug 30, 2017 at 9:24 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
>>>
>>>> llvm assembler is almost there too, but it needs some work.
>>>
>>> Does it use the "verifier instruction format"?  Is it available
>>> somewhere to look at?
>>
>> yes. you can use verifier instruction format.
>> That was the goal for llvm to be as close as possible to
>> kernel verifier syntax.
>> But, I think, it's fine to deviate if it makes asm code easier to read.
>> What is missing is AsmParser directory in
>> llvm/lib/Target/BPF
>> disassembler, elf tools, codegen are all there.
>> Most of the core backend components are shared in the llvm,
>> so it's only missing text parser.
>> Most backends already have assemblers:
>> ls -d lib/Target/*/AsmParser
>> To make one for BPF requires a lot of copy-paste from others ;)
