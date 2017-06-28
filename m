Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34780 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdF1CBV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 27 Jun 2017 22:01:21 -0400
Received: by mail-pf0-f177.google.com with SMTP id s66so25307253pfs.1
        for <xdp-newbies@vger.kernel.org>; Tue, 27 Jun 2017 19:01:21 -0700 (PDT)
MIME-Version: 1.0
From: "MD I. Islam" <tamim@csebuet.org>
Date: Tue, 27 Jun 2017 22:00:59 -0400
Message-ID: <CAM7NYTh=TMc6uC_4dG=w5yAHMppLSgTgfgTY0Jzr-ipgs9SN-w@mail.gmail.com>
Subject: Cannot load eBPF program as XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi

I'm using http://lingrok.org/xref/linux-net-next/samples/bpf/parse_simple.c.

I can load the program as tc_cls using following commands:

sudo tc qdisc add dev eno1 clsact
sudo tc filter add dev eno1  ingress bpf da obj parse_simple.o sec simple

But I get error when I load the same program in XDP:

sudo ip link set dev eno1 xdp obj parse_simple.o section simple

Prog section 'simple' rejected: Permission denied (13)!
 - Type:         6
 - Instructions: 23 (0 over limit)
 - License:      GPL

Verifier analysis:

0: (b7) r0 = 0
1: (61) r2 = *(u32 *)(r1 +80)
invalid bpf_context access off=80 size=4

Error fetching program/map!

I made sure that the parse_simple.o have necessary permission. Could
you please advise what is wrong here? I'm using Kernel 4.11+. Does XDP
need any specific kernel configuration enabled? clang and LLVM
versions are as following:

clang --version
clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)
Target: x86_64-pc-linux-gnu

llc --version
LLVM (http://llvm.org/):
  LLVM version 3.8.0

  Optimized build.
  Built Jul  9 2016 (11:22:59).
  Default target: x86_64-pc-linux-gnu
  Host CPU: haswell

  Registered Targets:
    aarch64    - AArch64 (little endian)
    aarch64_be - AArch64 (big endian)
    amdgcn     - AMD GCN GPUs
    arm        - ARM
    arm64      - ARM64 (little endian)
    armeb      - ARM (big endian)
    bpf        - BPF (host endian)
    bpfeb      - BPF (big endian)
    bpfel      - BPF (little endian)
    cpp        - C++ backend
    hexagon    - Hexagon
    mips       - Mips
    mips64     - Mips64 [experimental]
    mips64el   - Mips64el [experimental]
    mipsel     - Mipsel
    msp430     - MSP430 [experimental]
    nvptx      - NVIDIA PTX 32-bit
    nvptx64    - NVIDIA PTX 64-bit
    ppc32      - PowerPC 32
    ppc64      - PowerPC 64
    ppc64le    - PowerPC 64 LE
    r600       - AMD GPUs HD2XXX-HD6XXX
    sparc      - Sparc
    sparcel    - Sparc LE
    sparcv9    - Sparc V9
    systemz    - SystemZ
    thumb      - Thumb
    thumbeb    - Thumb (big endian)
    x86        - 32-bit X86: Pentium-Pro and above
    x86-64     - 64-bit X86: EM64T and AMD64
    xcore      - XCore

Many thanks
Tamim
