Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34678 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdIHXsC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Sep 2017 19:48:02 -0400
Received: by mail-vk0-f42.google.com with SMTP id o22so4963655vke.1
        for <xdp-newbies@vger.kernel.org>; Fri, 08 Sep 2017 16:48:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ed89863b-97b6-ecaf-e710-e2cafab30325@netronome.com>
References: <9c6783db-25ac-2854-142a-b44b72cfdc9a@netronome.com>
 <CAH3MdRVUmUbT4295RBr2EyoNJHTGHgvxo8c-wG3e2bJr0DiA4Q@mail.gmail.com> <ed89863b-97b6-ecaf-e710-e2cafab30325@netronome.com>
From: Y Song <ys114321@gmail.com>
Date: Fri, 8 Sep 2017 16:47:21 -0700
Message-ID: <CAH3MdRXbVb-gTKdaiFCpy6zoEVJRTME_0HXHwp+p__zJ=RiEXA@mail.gmail.com>
Subject: Re: [iovisor-dev] [PATCH RFC] Add BPF AsmParser support in LLVM
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, oss-drivers@netronome.com, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>, Jakub Kicinski <jakub.kicinski@netronome.com>

On Fri, Sep 8, 2017 at 1:00 PM, Jiong Wang <jiong.wang@netronome.com> wrote:
>
> Hi Y Song,
>
>   Thanks for the review and test.
>
> [snip]
>>
>> I guess, we may need to add something like LD_VAR_ADDR so that
>> the proper assembly code can be issued. Also we could drop "ll" with
>> "r1 = tx_port"?
>
>
> Personally, I prefer drop "ll". The "ll" suffix was there to tell people it is 64bit
> constant while the register "r1" is with 64-bit width so I feel it is enough. For
> 32-bit situation, we need new register set, some thing like "w1 = tx_port".

I just push a patch (similar to your suggestion below but without
assertion) which still has
"ll" suffix for the constant, but no "ll" suffix for symbols. The
reason is that  we use "ll"
in the asm printout to differentiate "r = 5"=>"mov r, 5" (32bit imm) and
"r = 5ll" => "ld_imm64 r, 5ll" (64bit imm).

Also, for long long constant, C standard does not allow space between
value and "ll" and
hence "567 ll" is not allowed to represent a number "567ll". Could you
try to disallow
64bit immediate like "567 ll" as well in your patch?

Thanks,

Yonghong

>
> And to generate proper assembly, it looks to me the customized print method for
> "uimm64" needs the following code (copied from printOperand):
>
> @@ -90,5 +90,8 @@ void BPFInstPrinter::printImm64Operand(const MCInst *MI, unsigned OpNo,
>    if (Op.isImm())
>      O << (uint64_t)Op.getImm();
>    else
> -    O << Op;
> +    {
> +      assert(Op.isExpr() && "Expected an expression");
> +      printExpr(Op.getExpr(), O);
> +    }
>  }
>
>>
>> Back to your test case bpf-insn-unit.s, you do not need add bpf in the file name
>> since it is already under BPF directory.
>
>
> Will change the name. and will fix all reviews below in the next update.
>
>>>  r0 = *(u16 *)skb[2] // BPF_LD | BPF_ABS | BPF_H
>>> r0 = * (u32*)skb[4] // BPF_LD | BPF_ABS | BPF_W
>>
>> could you add BPF_B test as well?
>>
>>>  r0 = *  (u16 *)skb[r1] // BPF_LD | BPF_IND | BPF_H
>>>  r0 = *(u32 *)skb[r2]   // BPF_LD | BPF_IND | BPF_W
>>
>> BPF_B test?
>>
>>>  r1 = 8589934591 ll     // BPF_LD | BPF_DW | BPF_IMM
>>>  r1 = dummy_map ll      // Symbolic version
>>
>>
>> // ======== BPF_LDX Class ========
>>   r5 = *(u8 *)(r0 + 0)   // BPF_LDX | BPF_B
>>   r6 = *(u16 *)(r1 + 8)  // BPF_LDX | BPF_H
>>   r7 = *(u32 *)(r2 + 16) // BPF_LDX | BPF_W
>>   r8 = *(u64 *)(r3 - 30) // BPF_LDX | BPF_DW
>>
>> // ======== TODO: BPF_ST Class =======
>>>
>>> There is no insn here, you can remove this line for now.
>>
>>
>> // ======== BPF_STX Class ========
>>   *(u8 *)(r0 + 0) = r7    // BPF_STX | BPF_B
>>   *(u16 *)(r1 + 8) = r8   // BPF_STX | BPF_H
>>   *(u32 *)(r2 + 16) = r9  // BPF_STX | BPF_W
>>   *(u64 *)(r3 - 30) = r10 // BPF_STX | BPF_DW
>>
>>   lock *(u32 *)(r2 + 16) += r9  // BPF_STX | BPF_W | BPF_XADD
>>   lock *(u64 *)(r3 - 30) += r10 // BPF_STX | BPF_DW | BPF_XADD
>>
>> // ======== BPF_JMP Class ========
>>   goto Llabel0  // BPF_JA
>>   if r0 == r1 goto Llabel0   // BPF_JEQ
>>   if r1 > r2 goto Llabel0    // BPF_JGT
>>   if r2 >= r3 goto Llabel0   // BPF_JGE
>>   // TODO: BPF_JSET
>>>
>>> there is no BPF_JSET, you can remove this.
>>
>>   if r3 != r4 goto Llabel0   // BPF_JNE
>>   if r4 s> r5 goto Llabel0   // BPF_JSGT
>>   if r5 s>= r6 goto Llabel0  // BPF_JSGE
>>   call 1                     // BPF_CALL
>>   exit                       // BPF_EXIT
>>   if r6 < r7 goto Llabel0    // BPF_JLT
>>   if r7 <= r8 goto Llabel0   // BPF_JLE
>>   if r8 s< r9 goto Llabel0   // BPF_JSLT
>>   if r9 s<= r10 goto Llabel0 // BPF_JSLE
>>
>>> Could you add test compare register vs. imm?
>>
>>
>> // ======== BPF_ALU64 Class ========
>>   r0 += r1    // BPF_ADD
>>   r1 -= r2    // BPF_SUB
>>   r2 *= r3    // BPF_MUL
>>   r3 /= r4    // BPF_DIV
>> Llabel0:
>>   r4 |= r5    // BPF_OR
>>   r5 &= r6    // BPF_AND
>>   r6 <<= r7   // BPF_LSH
>>   r7 >>= r8   // BPF_RSH
>>               // TODO: BPF_NEG
>>               // TODO: BPF_MOD
>>>
>>> There is no BPF_NEG/MOD yet, you can remove these two lines.
>>
>>
>>   r8 ^= r9    // BPF_XOR
>>   r9 = r10    // BPF_MOV
>>   r10 s>>= r0 // BPF_ARSH
>>>
>>> Could you add arith operations with register and imm. operands?
>>
>>
>>   bswap16 r1  // BPF_END | BPF_TO_BE
>>   bswap32 r2  // BPF_END | BPF_TO_BE
>>   bswap64 r3  // BPF_END | BPF_TO_BE
>>               // TODO: BPF_END | BPF_TO_LE
>>>
>>> There is no BPF_TO_LE yet, you can remove this line.
>>
>>
>>> Could you interleave the CHECK results with insn? This will be
>>
>> clearer to do manual comparison.
>
>
