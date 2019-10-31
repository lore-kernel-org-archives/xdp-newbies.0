Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24862 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726864AbfJaJ60 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 31 Oct 2019 05:58:26 -0400
Received: by mail-lf1-f71.google.com with SMTP id t27so1191006lfk.21
        for <xdp-newbies@vger.kernel.org>; Thu, 31 Oct 2019 02:58:22 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: bpf_helpers and you... some more...
In-Reply-To: <CACCo2j=TJYZ68ur53vNYxaS2qQgPv6ouij3P=tmrno-SJFTw0Q@mail.gmail.com>
References: <CACCo2j=TJYZ68ur53vNYxaS2qQgPv6ouij3P=tmrno-SJFTw0Q@mail.gmail.com>
Date: Thu, 31 Oct 2019 10:58:18 +0100
Message-ID: <87bltxp77p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Farid Zakaria <farid.m.zakaria@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>

Farid Zakaria <farid.m.zakaria@gmail.com> writes:

> This is my attempt of a continuation of David's prior e-mail
> https://www.spinics.net/lists/xdp-newbies/msg00179.html
>
> I was curious how ebpf filters are wired and work. The heavy use of C
> macros makes the source code difficult for me to comprehend (maybe
> there's an online pre-processed version?).
> I'm hoping others may find this exploratory-dive insightful (hopefully
> it's accurate enough).
>
> Let's write a very trivial ebpf filter (hello_world_kern.c) and have
> it print "hello world"
>
>     #include <linux/bpf.h>
>
>     #define __section(NAME) __attribute__((section(NAME), used))
>
>     static char _license[] __section("license") = "GPL";
>
>     /* helper functions called from eBPF programs written in C */
>     static int (*bpf_trace_printk)(const char *fmt, int fmt_size,
>                                 ...) = (void *)BPF_FUNC_trace_printk;
>
>     __section("hello_world") int hello_world_filter(struct __sk_buff *skb) {
>         char msg[] = "hello world";
>         bpf_debug_printk(msg, sizeof(msg));
>         return 0;
>     }
>
> If we compile the above using the below we can inspect the LLVM IR.
>     clang -c -o hello_world_kern.ll -x c -S -emit-llvm hello_world_kern.c
>
> The few lines that standout are:
>
>     @bpf_trace_printk = internal global i32 (i8*, i32, ...)* inttoptr
> (i64 6 to i32 (i8*, i32, ...)*), align 8
>     ....
>     %6 = load i32 (i8*, i32, ...)*, i32 (i8*, i32, ...)**
> @bpf_trace_printk, align 8
>     %7 = getelementptr inbounds [13 x i8], [13 x i8]* %3, i32 0, i32 0
>     %8 = call i32 (i8*, i32, ...) %6(i8* %7, i32 13)
>
> The above demonstrates that the value of BPF_FUNC_trace_printk is
> simply the integer 6 and it is being casted to a function pointer.
> Sure enough, we can confirm that `bpf_trace_printk` is the 6th value
> in the enumeration of known bpf bpf_helpers.
> (https://elixir.bootlin.com/linux/v5.3.7/source/include/uapi/linux/bpf.h#L2724)
>
> We can go even further and take this LLVM IR and generate human
> readable eBPF assembly using `llc`
>
>     llc hello_world_kern.ll -march=bpf
>
> Depending on the optimization level of the earlier `clang` call you
> may see different results however using `-O3` we can see
>
>     call 6
>
> Great! so we know that the call to `bpf_trace_printk` gets translated
> into a call instruction with immediate value of 6.
>
> How does it end up calling code within the kernel though?
> Once the Verifier verifies the bytecode it calls `fixup_bpf_calls`
> (https://elixir.bootlin.com/linux/v5.3.8/source/kernel/bpf/verifier.c#L8869)
> which goes through all the instructions and makes the necessary
> adjustment to the immediate value
>
>     fixup_bpf_calls(...) {
>         ...
>         patch_call_imm:
>             fn = env->ops->get_func_proto(insn->imm, env->prog);
>             /* all functions that have prototype and verifier allowed
>             * programs to call them, must be real in-kernel functions
>             */
>             if (!fn->func) {
>                 verbose(env,
>                     "kernel subsystem misconfigured func %s#%d\n",
>                     func_id_name(insn->imm), insn->imm);
>                 return -EFAULT;
>             }
>             insn->imm = fn->func - __bpf_call_base;
>
> N.B. I haven't deciphered how __bpf_call_base is used / works
>
> The `get_func_proto` will return the function prototypes registered by
> every subsystem such as in net.
> (https://elixir.bootlin.com/linux/v5.3.8/source/net/core/filter.c#L5991)
> At this point in the method it's a simple switch statement to get the
> matching function prototype given the numeric value.
>
> I'd love to see more on the code path of how the non-JIT vs JIT
> instructions get handled.
> For the net subsystem, I can see where the ebpf prog is invoked
> (https://elixir.bootlin.com/linux/v5.3.8/source/net/core/filter.c#L119),
> but it's difficult to work out how the choice of executing the
> function directly (in the case of JIT) vs running it through the
> interpreter is handled.

When a program is jit'ed, the function pointer in struct
bpf_prog->bpf_func is replaced with a pointer to the machine code
generated by the jit. The jit does this for calls:
https://elixir.bootlin.com/linux/v5.3.8/source/arch/x86/net/bpf_jit_comp.c#L828

-Toke
