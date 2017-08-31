Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:38015 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751397AbdHaFct (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 31 Aug 2017 01:32:49 -0400
Received: by mail-ua0-f173.google.com with SMTP id j46so24626827uag.5
        for <xdp-newbies@vger.kernel.org>; Wed, 30 Aug 2017 22:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAADnVQKuZSc3bzMSmsCZB1FLnmywOEhMECSu_yruCD+exq81Sw@mail.gmail.com>
References: <CAADnVQKuZSc3bzMSmsCZB1FLnmywOEhMECSu_yruCD+exq81Sw@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Wed, 30 Aug 2017 22:32:08 -0700
Message-ID: <CAH3MdRUemaGqwMJ6oK=z+4x=+HSs6CptK91=duyV1fuYFVwuZw@mail.gmail.com>
Subject: Re: BPF assembler?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

Jakub,

Let me know if you need additional help on this. I think this
assembler->obj in llvm is the last
major piece for a complete toolchain for clang/llvm.

Thanks,

Yonghong

On Wed, Aug 30, 2017 at 9:37 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Wed, Aug 30, 2017 at 9:24 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
>>
>>> llvm assembler is almost there too, but it needs some work.
>>
>> Does it use the "verifier instruction format"?  Is it available
>> somewhere to look at?
>
> yes. you can use verifier instruction format.
> That was the goal for llvm to be as close as possible to
> kernel verifier syntax.
> But, I think, it's fine to deviate if it makes asm code easier to read.
> What is missing is AsmParser directory in
> llvm/lib/Target/BPF
> disassembler, elf tools, codegen are all there.
> Most of the core backend components are shared in the llvm,
> so it's only missing text parser.
> Most backends already have assemblers:
> ls -d lib/Target/*/AsmParser
> To make one for BPF requires a lot of copy-paste from others ;)
