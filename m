Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50523 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEFWBJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 6 May 2019 18:01:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id p21so17666336wmc.0
        for <xdp-newbies@vger.kernel.org>; Mon, 06 May 2019 15:01:07 -0700 (PDT)
References: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
From: Jiong Wang <jiong.wang@netronome.com>
Subject: Re: [oss-drivers] netronome/nfp/bpf/jit.c cannot be build with -O3
In-reply-to: <673b885183fb64f1cbb3ed2387524077@natalenko.name>
Date: Mon, 06 May 2019 23:01:03 +0100
Message-ID: <87mujzutsw.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, oss-drivers@netronome.com, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, valdis@vt.edu


'Oleksandr Natalenko' via OSS Drivers writes:

> Hi.
>
> Obligatory disclaimer: building the kernel with -O3 is a non-standard 
> thing done via this patch [1], but I've asked people in #kernelnewbies, 
> and it was suggested that the issue should be still investigated.
>
> So, with v5.1 kernel release I cannot build the kernel with -O3 anymore. 
> It fails as shown below:

I guess it's because constant prop. Could you try the following change to
__emit_shift?

drivers/net/ethernet/netronome/nfp/bpf/jit.c
__emit_shift:331
-       if (sc == SHF_SC_L_SHF)
+       if (sc == SHF_SC_L_SHF && shift)
                shift = 32 - shift;

emit_shf_indir is passing "0" as shift to __emit_shift which will
eventually be turned into 32 and it was OK because we truncate to 5-bit,
but before truncation, it will overflow the shift mask.

Regards,
Jiong

>
> ===
>    CC      drivers/net/ethernet/netronome/nfp/bpf/jit.o
> In file included from ./include/asm-generic/bug.h:5,
>                   from ./arch/x86/include/asm/bug.h:83,
>                   from ./include/linux/bug.h:5,
>                   from drivers/net/ethernet/netronome/nfp/bpf/jit.c:6:
> In function ‘__emit_shf’,
>      inlined from ‘emit_shf.constprop’ at 
> drivers/net/ethernet/netronome/nfp/bpf/jit.c:364:2,
>      inlined from ‘shl_reg64_lt32_low’ at 
> drivers/net/ethernet/netronome/nfp/bpf/jit.c:379:2,
>      inlined from ‘shl_reg’ at 
> drivers/net/ethernet/netronome/nfp/bpf/jit.c:2506:2:
> ./include/linux/compiler.h:344:38: error: call to 
> ‘__compiletime_assert_341’ declared with attribute error: BUILD_BUG_ON 
> failed: (((0x001f0000000ULL) + (1ULL << 
> (__builtin_ffsll(0x001f0000000ULL) - 1))) & (((0x001f0000000ULL) + (1ULL 
> << (__builtin_ffsll(0x001f0000000ULL) - 1))) - 1)) != 0
>    _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>                                        ^
> ./include/linux/compiler.h:325:4: note: in definition of macro 
> ‘__compiletime_assert’
>      prefix ## suffix();    \
>      ^~~~~~
> ./include/linux/compiler.h:344:2: note: in expansion of macro 
> ‘_compiletime_assert’
>    _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>    ^~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:39:37: note: in expansion of macro 
> ‘compiletime_assert’
>   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                       ^~~~~~~~~~~~~~~~~~
> ./include/linux/bitfield.h:57:3: note: in expansion of macro 
> ‘BUILD_BUG_ON_MSG’
>     BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?  \
>     ^~~~~~~~~~~~~~~~
> ./include/linux/bitfield.h:89:3: note: in expansion of macro 
> ‘__BF_FIELD_CHECK’
>     __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: "); \
>     ^~~~~~~~~~~~~~~~
> drivers/net/ethernet/netronome/nfp/bpf/jit.c:341:3: note: in expansion 
> of macro ‘FIELD_PREP’
>     FIELD_PREP(OP_SHF_SHIFT, shift) |
>     ^~~~~~~~~~
> make[1]: *** [scripts/Makefile.build:276: 
> drivers/net/ethernet/netronome/nfp/bpf/jit.o] Error 1
> make: *** [Makefile:1726: drivers/net/ethernet/netronome/nfp/bpf/jit.o] 
> Error 2
> ===
>
> Needless to say, with -O2 this file is built just fine. My compiler is:
>
> ===
> $ gcc --version
> gcc (GCC) 8.3.0
> Copyright (C) 2018 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is 
> NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR 
> PURPOSE.
> ===
>
> I had no issues with -O3 before, so, maybe, this deserves a peek.
>
> I'm open to testing patches and providing more info if needed.
>
> Thanks.
>
> [1] 
> https://gitlab.com/post-factum/pf-kernel/commit/7fef93015ff1776d08119ef3d057a9e9433954a9
