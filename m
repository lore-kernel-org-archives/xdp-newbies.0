Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:36544 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732127AbfFYRlE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 13:41:04 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so3395226ioh.3
        for <xdp-newbies@vger.kernel.org>; Tue, 25 Jun 2019 10:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDScmn0Mge9mK14AS+y=JY-hGoXZGYo+Q-yG3VsrCXiYc9eDg@mail.gmail.com>
In-Reply-To: <CAMDScmn0Mge9mK14AS+y=JY-hGoXZGYo+Q-yG3VsrCXiYc9eDg@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Tue, 25 Jun 2019 10:40:26 -0700
Message-ID: <CAH3MdRVzmB=WJz4vvvpX34X_Yd1K3EDRXzUFzib3Jkj4wsALiQ@mail.gmail.com>
Subject: Re: Still need to inline functions?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Elerion <elerion1000@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

As of today, the `__always_inline` is still required. Some work will
be needed, e.g., to merge codes between different sections, before
`__always_inline` can be removed.

On Sat, Jun 15, 2019 at 5:07 PM Elerion <elerion1000@gmail.com> wrote:
>
> What version of Linux is required so I can use functions without
> __always_inline in the xdp kernel object?
>
> I read here https://lwn.net/Articles/741773/ it was supposed to be
> allowed a long time ago.
>
> When I remove __always_inline on a medium sized function,
> bpf_load_program() will say:
>
> "jump out of range from insn 5 to 796"
>
> Is this possible to fix, or do you still need to put __always_inline
> on every function?
>
> Software versions:
>
> Ubuntu 18.04.02 LTS x64
> 4.18.0-20-generic
> 5.0.0-16-generic
>
> clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)
> Target: x86_64-pc-linux-gnu
> Thread model: posix
> InstalledDir: /usr/bin
>
> LLVM (http://llvm.org/):
>   LLVM version 6.0.0
>
>   Optimized build.
>   Default target: x86_64-pc-linux-gnu
>   Host CPU: broadwell
>
> Compile flags:
>
> clang -O2 -target bpf -I/usr/include/x86_64-linux-gnu -c kern.c -o kern.o
