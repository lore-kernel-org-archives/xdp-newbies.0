Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:38563 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbdIGXnD (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Sep 2017 19:43:03 -0400
Received: by mail-ua0-f180.google.com with SMTP id l24so1916021uaa.5
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 16:43:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9c6783db-25ac-2854-142a-b44b72cfdc9a@netronome.com>
References: <9c6783db-25ac-2854-142a-b44b72cfdc9a@netronome.com>
From: Y Song <ys114321@gmail.com>
Date: Thu, 7 Sep 2017 16:42:22 -0700
Message-ID: <CAH3MdRVUmUbT4295RBr2EyoNJHTGHgvxo8c-wG3e2bJr0DiA4Q@mail.gmail.com>
Subject: Re: [iovisor-dev] [PATCH RFC] Add BPF AsmParser support in LLVM
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, oss-drivers@netronome.com, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>, Jakub Kicinski <jakub.kicinski@netronome.com>

Hi, Jiong,

The patch looks great! I tested with a few bpf programs from
kernel:samples/bpf/ directory.
Your test case with verifier like input looks good. I will have a few
suggestions later.

I tested with compiler generated asm as well with both big endian and
little endian.
   . clang generate .ll
   . llc generate .asm
   . llvm-mc generate .o
   . llvm-objdump disassembles.
It works fine except in one case:

For ld_imm64, we have:
class LD_IMM64<bits<4> Pseudo, string OpcodeStr>
    : InstBPF<(outs GPR:$dst), (ins u64imm:$imm),
              "$dst "#OpcodeStr#" ${imm}ll",
              [(set GPR:$dst, (i64 imm:$imm))]>

In reality, the map it tries to access will not be constant, so
the current assembler prints like:
  r1 = <MCOperand Expr:(tx_port)>ll

The assembler does not like this and this insn is ignored.
If I change the above to
  r1 = tx_port ll
as expressed in the test case, the code will be generated properly with
relocation record.

I guess, we may need to add something like LD_VAR_ADDR so that
the proper assembly code can be issued. Also we could drop "ll" with
"r1 = tx_port"?

Back to your test case bpf-insn-unit.s, you do not need add bpf in the file name
since it is already under BPF directory.

>  r0 = *(u16 *)skb[2] // BPF_LD | BPF_ABS | BPF_H
> r0 = * (u32*)skb[4] // BPF_LD | BPF_ABS | BPF_W
could you add BPF_B test as well?

>  r0 = *  (u16 *)skb[r1] // BPF_LD | BPF_IND | BPF_H
>  r0 = *(u32 *)skb[r2]   // BPF_LD | BPF_IND | BPF_W
BPF_B test?

>  r1 = 8589934591 ll     // BPF_LD | BPF_DW | BPF_IMM
>  r1 = dummy_map ll      // Symbolic version

// ======== BPF_LDX Class ========
  r5 = *(u8 *)(r0 + 0)   // BPF_LDX | BPF_B
  r6 = *(u16 *)(r1 + 8)  // BPF_LDX | BPF_H
  r7 = *(u32 *)(r2 + 16) // BPF_LDX | BPF_W
  r8 = *(u64 *)(r3 - 30) // BPF_LDX | BPF_DW

// ======== TODO: BPF_ST Class =======
> There is no insn here, you can remove this line for now.

// ======== BPF_STX Class ========
  *(u8 *)(r0 + 0) = r7    // BPF_STX | BPF_B
  *(u16 *)(r1 + 8) = r8   // BPF_STX | BPF_H
  *(u32 *)(r2 + 16) = r9  // BPF_STX | BPF_W
  *(u64 *)(r3 - 30) = r10 // BPF_STX | BPF_DW

  lock *(u32 *)(r2 + 16) += r9  // BPF_STX | BPF_W | BPF_XADD
  lock *(u64 *)(r3 - 30) += r10 // BPF_STX | BPF_DW | BPF_XADD

// ======== BPF_JMP Class ========
  goto Llabel0  // BPF_JA
  if r0 == r1 goto Llabel0   // BPF_JEQ
  if r1 > r2 goto Llabel0    // BPF_JGT
  if r2 >= r3 goto Llabel0   // BPF_JGE
  // TODO: BPF_JSET
> there is no BPF_JSET, you can remove this.
  if r3 != r4 goto Llabel0   // BPF_JNE
  if r4 s> r5 goto Llabel0   // BPF_JSGT
  if r5 s>= r6 goto Llabel0  // BPF_JSGE
  call 1                     // BPF_CALL
  exit                       // BPF_EXIT
  if r6 < r7 goto Llabel0    // BPF_JLT
  if r7 <= r8 goto Llabel0   // BPF_JLE
  if r8 s< r9 goto Llabel0   // BPF_JSLT
  if r9 s<= r10 goto Llabel0 // BPF_JSLE

> Could you add test compare register vs. imm?

// ======== BPF_ALU64 Class ========
  r0 += r1    // BPF_ADD
  r1 -= r2    // BPF_SUB
  r2 *= r3    // BPF_MUL
  r3 /= r4    // BPF_DIV
Llabel0:
  r4 |= r5    // BPF_OR
  r5 &= r6    // BPF_AND
  r6 <<= r7   // BPF_LSH
  r7 >>= r8   // BPF_RSH
              // TODO: BPF_NEG
              // TODO: BPF_MOD
> There is no BPF_NEG/MOD yet, you can remove these two lines.

  r8 ^= r9    // BPF_XOR
  r9 = r10    // BPF_MOV
  r10 s>>= r0 // BPF_ARSH
> Could you add arith operations with register and imm. operands?

  bswap16 r1  // BPF_END | BPF_TO_BE
  bswap32 r2  // BPF_END | BPF_TO_BE
  bswap64 r3  // BPF_END | BPF_TO_BE
              // TODO: BPF_END | BPF_TO_LE
> There is no BPF_TO_LE yet, you can remove this line.

> Could you interleave the CHECK results with insn? This will be
clearer to do manual comparison.

On Thu, Sep 7, 2017 at 1:43 AM, Jiong Wang via iovisor-dev
<iovisor-dev@lists.iovisor.org> wrote:
> Hi,
>
>   As discussed at threads:
>
>     https://www.spinics.net/lists/xdp-newbies/msg00320.html
>     https://www.spinics.net/lists/xdp-newbies/msg00323.html
>
>   This patch adds the initial BPF AsmParser support in LLVM.
>
>   This support is following the "verifier instruction format" which is
> C-like.
>
>   Things need to mention are:
>
>     1. LLVM AsmParser doesn't expect the character "*" to be used as the
> start
>        of a statement while BPF "verifier instruction format" is.  So an new
>        generic method "starIsStartOfStatement" is introduced.
>
>     2. As the MC assembler is sharing code infrastructure with disassembler,
> the
>        current supported instruction format is *strictly* those registered
> in
>        instruction information .td files.  For example, the parser doesn't
>        acccept "*(u8 *)(r0) = r7", instead, you need to write
>        "*(u8 *)(r0 + 0) = r7". The offset is mandatory, even when it is
> zero.
>        The instruction information .td files may need to register customized
>        ParserMethods to allow more flexible syntaxes.
>
>   The testcase bpf-insn-unit.s contains unit tests for supported syntaxes.
>
>   Comments? Does the current accepted syntaxes look OK?
>
>
> _______________________________________________
> iovisor-dev mailing list
> iovisor-dev@lists.iovisor.org
> https://lists.iovisor.org/mailman/listinfo/iovisor-dev
>
