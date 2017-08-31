Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:35517 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdHaEiS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 31 Aug 2017 00:38:18 -0400
Received: by mail-wr0-f179.google.com with SMTP id j29so22232346wre.2
        for <xdp-newbies@vger.kernel.org>; Wed, 30 Aug 2017 21:38:18 -0700 (PDT)
MIME-Version: 1.0
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 30 Aug 2017 21:37:56 -0700
Message-ID: <CAADnVQKuZSc3bzMSmsCZB1FLnmywOEhMECSu_yruCD+exq81Sw@mail.gmail.com>
Subject: Re: BPF assembler?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: xdp-newbies@vger.kernel.org, yhs@fb.com

On Wed, Aug 30, 2017 at 9:24 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
>
>> llvm assembler is almost there too, but it needs some work.
>
> Does it use the "verifier instruction format"?  Is it available
> somewhere to look at?

yes. you can use verifier instruction format.
That was the goal for llvm to be as close as possible to
kernel verifier syntax.
But, I think, it's fine to deviate if it makes asm code easier to read.
What is missing is AsmParser directory in
llvm/lib/Target/BPF
disassembler, elf tools, codegen are all there.
Most of the core backend components are shared in the llvm,
so it's only missing text parser.
Most backends already have assemblers:
ls -d lib/Target/*/AsmParser
To make one for BPF requires a lot of copy-paste from others ;)
