Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:45250 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdILTrl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 12 Sep 2017 15:47:41 -0400
Received: by mail-wm0-f54.google.com with SMTP id f199so2896149wme.0
        for <xdp-newbies@vger.kernel.org>; Tue, 12 Sep 2017 12:47:41 -0700 (PDT)
Subject: Re: [v2][PATCH RFC] Add BPF AsmParser support in LLVM
References: <9c6783db-25ac-2854-142a-b44b72cfdc9a@netronome.com>
 <CAH3MdRVUmUbT4295RBr2EyoNJHTGHgvxo8c-wG3e2bJr0DiA4Q@mail.gmail.com>
 <ed89863b-97b6-ecaf-e710-e2cafab30325@netronome.com>
 <CAH3MdRXbVb-gTKdaiFCpy6zoEVJRTME_0HXHwp+p__zJ=RiEXA@mail.gmail.com>
 <a9e3b287-f10e-72b7-0836-f3ec393c2b59@netronome.com>
 <CAH3MdRX6AwO8zzJ=JiNVZ37pZ57sWOLvXoOC0Ed2=MV-RaoJZQ@mail.gmail.com>
 <b01a5de5-d684-9862-bc4c-236cdfca1b65@netronome.com>
 <CAH3MdRWOb6GnRcVLzFsKc215=anv+RGEF6FAJbvbkutbi3wjYg@mail.gmail.com>
 <CAH3MdRWCp_5kNu1yZOPMQgBxUpidT3dqcNEDRREnvVTsn+YYUg@mail.gmail.com>
From: Jiong Wang <jiong.wang@netronome.com>
Message-ID: <ac3d356d-d16f-4cbd-d508-f3fb29811248@netronome.com>
Date: Tue, 12 Sep 2017 20:47:37 +0100
MIME-Version: 1.0
In-Reply-To: <CAH3MdRWCp_5kNu1yZOPMQgBxUpidT3dqcNEDRREnvVTsn+YYUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: xdp-newbies@vger.kernel.org, oss-drivers@netronome.com, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>, Jakub Kicinski <jakub.kicinski@netronome.com>

On Tue, Sep 12, 2017 at 11:10 AM, Y Song <ys114321@gmail.com> wrote:
>> Thanks, Jiong,
>>
>> The patch looks good. I have applied to llvm trunk.
>> https://reviews.llvm.org/rL313055

Thanks, Yonghong.

>>
>>> Hmm, I actually feel there is no need to offer an separate syntax for
>>> 64bit imm
>>> encoding, it might be better to offer a unified single syntax "r =
>>> signed_imm"
>>> to the user and the encoder (BPFMCCodeEmitter::encodeInstruction)
>>> guarantee to
>>> choose optimal encoding.
>>>
>>> Encoder could choose BPF_ALU64 | BPF_MOV | BPF_K for both "r1 = -1" and
>>> "r1 = -1ll" while only resorting to BPF_LD | BPF_DW | BPF_IMM when the imm
>>> really
>>> doesn't fit into 32bit (!isInt<32>(imm_opnd)), for example, "r1 =
>>> 0x1ffffffffll".
>>>
>> Right now, this optimization actually
>> has been done in compiler side. So depending on the value, the compiler will
>> use
>> "move r1, <32_bit_value>" or "ld_imm64 r1, <greater_than_32_bit_value>".
>> In this case, it make sense to have different insn formats for two different
>> kinds of
>> insns.
>>
>> What you described is to move the optimization down to MC Emit Code stage,
>> based on
>> the value, it can choose to use "move" or "ld_imm64" insn. So optimization
>> will be available
>> for .c => .o and for .s => .o. (The current scheme, optimization not
>> available from .s => .o).
>>
>> Yes, it is possible. But typically, there is one-to-one mapping between asm
>> insn to insn encoding.
>> If later on, we found the complain about this, we can revisit this issue.

OK.

Regards,
Jiong
