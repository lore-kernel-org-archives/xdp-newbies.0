Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:40309 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfFPAHZ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 15 Jun 2019 20:07:25 -0400
Received: by mail-vs1-f66.google.com with SMTP id a186so4018220vsd.7
        for <xdp-newbies@vger.kernel.org>; Sat, 15 Jun 2019 17:07:24 -0700 (PDT)
MIME-Version: 1.0
From: Elerion <elerion1000@gmail.com>
Date: Sat, 15 Jun 2019 17:07:14 -0700
Message-ID: <CAMDScmn0Mge9mK14AS+y=JY-hGoXZGYo+Q-yG3VsrCXiYc9eDg@mail.gmail.com>
Subject: Still need to inline functions?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

What version of Linux is required so I can use functions without
__always_inline in the xdp kernel object?

I read here https://lwn.net/Articles/741773/ it was supposed to be
allowed a long time ago.

When I remove __always_inline on a medium sized function,
bpf_load_program() will say:

"jump out of range from insn 5 to 796"

Is this possible to fix, or do you still need to put __always_inline
on every function?

Software versions:

Ubuntu 18.04.02 LTS x64
4.18.0-20-generic
5.0.0-16-generic

clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin

LLVM (http://llvm.org/):
  LLVM version 6.0.0

  Optimized build.
  Default target: x86_64-pc-linux-gnu
  Host CPU: broadwell

Compile flags:

clang -O2 -target bpf -I/usr/include/x86_64-linux-gnu -c kern.c -o kern.o
