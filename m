Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:34305 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdFAPqh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Jun 2017 11:46:37 -0400
Received: by mail-vk0-f44.google.com with SMTP id y190so27051024vkc.1
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Jun 2017 08:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAErYV9HG9H=62DL49qY1iewshx3NcMqAq6u3O=RsYEWdZp3Hjw@mail.gmail.com>
References: <CAErYV9HG9H=62DL49qY1iewshx3NcMqAq6u3O=RsYEWdZp3Hjw@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Thu, 1 Jun 2017 08:45:51 -0700
Message-ID: <CAH3MdRXPjywy1J02tgs6daQ-NtW8k6wAmvSNYM=yB0ah6ixM_Q@mail.gmail.com>
Subject: Re: [iovisor-dev] Running Prototype-kernel package
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Adel Fuchs <adelfuchs@gmail.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, xdp-newbies@vger.kernel.org, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>

On Thu, Jun 1, 2017 at 7:45 AM, Adel Fuchs via iovisor-dev
<iovisor-dev@lists.iovisor.org> wrote:
> Hi Jesper,
>
> Thank you so much for your help. I need to run an eBPF programs that
> filters packets according to IP address or port. I'm trying to run the
> prototype-kernel package but encounter problems.
> I went over the "getting started" tutorial, but I couldn'f find a
> tutorial which explains how to actually run the samples. So this is
> what I did:
>
> clang -O2 -Wall -target bpf -c xdp_ddos01_blacklist_cmdline.c -o
> xdp_ddos01_blacklist_cmdline

Just looked at the code. This seems a control plane application.
You should not compile with "-target bpf". You should just use the
default host one if you are intending to run on that host.
You can also use gcc here.

Yonghong

>
> First, I got an error saying:
> ./libbpf.h:12:10: fatal error: 'bpf/bpf.h' file not found
> #include <bpf/bpf.h>
>
> So I added it manually. Then I got this big error:
>
> fatal error: error in backend: Cannot select: 0x562f4957d270: ch,glue
> = BPFISD::CALL 0x562f49581238,
>       TargetExternalSymbol:i64'__divdf3', Register:i64 %R1,
> Register:i64 %R2, 0x562f49581238:1
>   0x562f49580bb8: i64 = TargetExternalSymbol'__divdf3'
>   0x562f4957d618: i64 = Register %R1
>   0x562f49581510: i64 = Register %R2
>   0x562f49581238: ch,glue = CopyToReg 0x562f495816b0, Register:i64
> %R2, 0x562f49580f60, 0x562f495816b0:1
>     0x562f49581510: i64 = Register %R2
>     0x562f49580f60: i64,ch,glue = CopyFromReg 0x562f49581578,
> Register:i64 %R0, 0x562f49581578:1
>       0x562f4957da90: i64 = Register %R0
>       0x562f49581578: ch,glue = callseq_end 0x562f4957db60,
> TargetConstant:i64<0>, TargetConstant:i64<0>, 0x562f4957db60:1
>         0x562f4957d6e8: i64 = TargetConstant<0>
>         0x562f4957d6e8: i64 = TargetConstant<0>
>         0x562f4957db60: ch,glue = BPFISD::CALL 0x562f4957d750,
> TargetExternalSymbol:i64'__divdf3', Register:i64 %R1, Register:i64
> %R2, 0x562f4957d750:1
>           0x562f49580bb8: i64 = TargetExternalSymbol'__divdf3'
>           0x562f4957d618: i64 = Register %R1
>           0x562f49581510: i64 = Register %R2
>           0x562f4957d750: ch,glue = CopyToReg 0x562f49581648,
> Register:i64 %R2, Constant:i64<4741671816366391296>, 0x562f49581648:1
>             0x562f49581510: i64 = Register %R2
>             0x562f49580ef8: i64 = Constant<4741671816366391296>
>             0x562f49581648: ch,glue = CopyToReg 0x562f495808e0,
> Register:i64 %R1, 0x562f4957d478
>               0x562f4957d618: i64 = Register %R1
>               0x562f4957d478: i64,ch,glue = CopyFromReg
> 0x562f49581370, Register:i64 %R0, 0x562f49581370:1
>                 0x562f4957da90: i64 = Register %R0
>                 0x562f49581370: ch,glue = callseq_end 0x562f49580c88,
> TargetConstant:i64<0>, TargetConstant:i64<0>, 0x562f49580c88:1
>                   0x562f4957d6e8: i64 = TargetConstant<0>
>                   0x562f4957d6e8: i64 = TargetConstant<0>
>                   0x562f49580c88: ch,glue = BPFISD::CALL
> 0x562f49581030, TargetExternalSymbol:i64'__floatundidf', Register:i64
> %R1, 0x562f49581030:1
>
>
>
>     0x562f495816b0: ch,glue = CopyToReg 0x562f4957dd00, Register:i64
> %R1, 0x562f4957dd68
>       0x562f4957d618: i64 = Register %R1
>       0x562f4957dd68: i64,ch,glue = CopyFromReg 0x562f4957d7b8,
> Register:i64 %R0, 0x562f4957d7b8:1
>         0x562f4957da90: i64 = Register %R0
>         0x562f4957d7b8: ch,glue = callseq_end 0x562f49580e28,
> TargetConstant:i64<0>, TargetConstant:i64<0>, 0x562f49580e28:1
>           0x562f4957d6e8: i64 = TargetConstant<0>
>           0x562f4957d6e8: i64 = TargetConstant<0>
>           0x562f49580e28: ch,glue = BPFISD::CALL 0x562f4957da28,
> TargetExternalSymbol:i64'__floatundidf', Register:i64 %R1,
> 0x562f4957da28:1
>             0x562f4957d410: i64 = TargetExternalSymbol'__floatundidf'
>             0x562f4957d618: i64 = Register %R1
>             0x562f4957da28: ch,glue = CopyToReg 0x562f49580e90,
> Register:i64 %R1, 0x562f4957d680
>               0x562f4957d618: i64 = Register %R1
>               0x562f4957d680: i64 = sub 0x562f49580a80, 0x562f49580dc0
>                 0x562f49580a80: i64,ch = CopyFromReg 0x562f494f79b0,
> Register:i64 %vreg50
>                   0x562f49581718: i64 = Register %vreg50
>                 0x562f49580dc0: i64,ch = CopyFromReg 0x562f494f79b0,
> Register:i64 %vreg48
>                   0x562f49581440: i64 = Register %vreg48
> In function: main
> clang: error: clang frontend command failed with exit code 70 (use -v
> to see invocation)
> clang version 4.0.0-1ubuntu1 (tags/RELEASE_400/rc1)
> Target: bpf
> Thread model: posix
> InstalledDir: /usr/bin
> clang: note: diagnostic msg: PLEASE submit a bug report to
> http://llvm.org/bugs/ and include the crash backtrace, preprocessed
> source, and associated run script.
> clang: note: diagnostic msg:
> ********************
>
> PLEASE ATTACH THE FOLLOWING FILES TO THE BUG REPORT:
> Preprocessed source(s) and associated run script(s) are located at:
> clang: note: diagnostic msg: /tmp/xdp_ddos01_blacklist_cmdline-80c621.c
> clang: note: diagnostic msg: /tmp/xdp_ddos01_blacklist_cmdline-80c621.sh
> clang: note: diagnostic msg:
>
> ********************
>
> Could you please help me run these samples? Could you please guide me
> to the right sample that I need and tell me how to run it?
> Note that I was able to run a simple XDP program on this computer, so
> I think that it is configured all right...
>
> Thanks a lot
> Adel
>
> _______________________________________________
> iovisor-dev mailing list
> iovisor-dev@lists.iovisor.org
> https://lists.iovisor.org/mailman/listinfo/iovisor-dev
>
