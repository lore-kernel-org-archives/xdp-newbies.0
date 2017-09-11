Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:37321 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKXzN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 11 Sep 2017 19:55:13 -0400
Received: by mail-ua0-f182.google.com with SMTP id k23so13108278uaf.4
        for <xdp-newbies@vger.kernel.org>; Mon, 11 Sep 2017 16:55:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a9e3b287-f10e-72b7-0836-f3ec393c2b59@netronome.com>
References: <9c6783db-25ac-2854-142a-b44b72cfdc9a@netronome.com>
 <CAH3MdRVUmUbT4295RBr2EyoNJHTGHgvxo8c-wG3e2bJr0DiA4Q@mail.gmail.com>
 <ed89863b-97b6-ecaf-e710-e2cafab30325@netronome.com> <CAH3MdRXbVb-gTKdaiFCpy6zoEVJRTME_0HXHwp+p__zJ=RiEXA@mail.gmail.com>
 <a9e3b287-f10e-72b7-0836-f3ec393c2b59@netronome.com>
From: Y Song <ys114321@gmail.com>
Date: Mon, 11 Sep 2017 16:54:31 -0700
Message-ID: <CAH3MdRX6AwO8zzJ=JiNVZ37pZ57sWOLvXoOC0Ed2=MV-RaoJZQ@mail.gmail.com>
Subject: Re: [v2][PATCH RFC] Add BPF AsmParser support in LLVM
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, oss-drivers@netronome.com, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>, Jakub Kicinski <jakub.kicinski@netronome.com>

Hi, Jiong,

Thanks for the patch. Comments inlined.


> Changes since the initial version:
>
>   * Addressed all comments on instruction unit tests.
>     - Renamed test file to "insn-unit.s".
>     - Removed unnecessary comments.
>     - Added BPF_B tests for load and store.
>     - Added BPF_K test for jmp and alu.
>       (Noticed a seperate issue with unsigned compare then jump. Looks like
> BPF
>        backend is alway printing the immediate as signed, I guess we need to
>        change the operand types in instruction patterns.)

Right. We may need to separate out signed comparison vs. others. Will do
that later.

>     - Adjusted constant load tests.
>     - Interleaved the expected results with input insns.
>
>   * Changed the disassembly output "ll" to "LL" in BPFInstPrinter.cpp.
>     This is because I noticed MC parser only accept "LL" as long long
> suffix.

Sorry for the confusion caused by "ll". I tested your patch and found that
both r = 5 and r = 5LL generated ld_imm64 insn. This is not what compiler
will do. Further debugging I found that this is due to my change to remove
"ll" from asmstring in the insn definition (.td file). Since the assembler is
patten matching based on asmstring. "r = 5" matched to ld_imm64 as well.

I just fixed the issue and restored " ll" suffix for ld_imm64 asmstring.
You can then restore your previous change to add "ll" as a valid identifier
in the middle of asm statement.

Thanks.
