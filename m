Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:45720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756936AbdERSAM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 18 May 2017 14:00:12 -0400
Received: from localhost (67.110.78.66.ptr.us.xo.net [67.110.78.66])
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 990351246B631
        for <xdp-newbies@vger.kernel.org>; Thu, 18 May 2017 10:18:39 -0700 (PDT)
Date: Thu, 18 May 2017 14:00:09 -0400 (EDT)
Message-Id: <20170518.140009.2301493573177276287.davem@davemloft.net>
Subject: BPF Verifier Overview
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org


The only thing sitting between our eBPF programs and a deep dark chasm
of destruction is the eBPF verifier.

Every eBPF program loaded into the kernel is checked by the verifier.
It is quite powerful, and provides a facility for introspection of
it's internal state so that analysis of the verifier's view of the
program can be performed.

The verifier performs many tests, but primarily it:

1) Transforms special MAP fd load instructions into MAP pointer one's.
   Userspace performs MAP loads using a specially code 64-bit load
   immediate instruction, with the file descriptor in the immediate
   field.  Normally the source register field is zero for a "ldimm64",
   but for these special MAP fd instructions the src_reg is set to '1'
   (BPF_PSEUDO_MAP_FD).

	ldimm64		rN, $FD		! and src_reg set to '1'

   The verifier uses the FD to look up the map pointer, and rewrites
   the above instruction into:

	ldimm64		rN, map_ptr

   Later, after the program has been validated, the src_reg field will
   be cleared to zero and then it will be well formed.

2) Build a control flow graph and and verify it.  A graph representing the
   control flow of the eBPF program is built, with edges connecting jumps
   to the destination basic blocks.

   The CFG is used to enforce two eBPF rules.

   a) No back-edges, which means no branching back to earlier instructions
      in the program and no loops.
   b) No unreachable instructions.

3) Finally the main full program check which analyzes every instruction,
   maintaining per-register state, and making sure no invalid operations
   are performed.

   One of the major purposes of this pass is to make sure that the
   dereferencing of pointers is always done in a safe and controlled
   manner.  When values from a known source are loaded into a register,
   the register acquires a type and this type and the register's other
   attributes are used to make sure an access is valid.

   The verifier has to consider all flows of control through the
   program, to check that all of the necessary constraints are
   followed no matter what set of paths are used on the way to the
   final BPF_EXIT of the program.

   In order to do this, the verifier has a stack of branches it has
   visited one arm of.  So at a jump, the verifier pushes the jump
   onto a stack, and continues down one of the two possible paths
   from that jump.

   Later, after hitting BPF_EXIT, the verifier starts popping entries
   off the of stack and visiting the opposite jump path.  This can
   get extremely expensive for programs with lots of jumps, so the
   verifier implements somethign called state pruning to minimize
   the amount of paths it has to follow.

   It is quite complicated, but the basic idea is that if we know the
   we've made more strict determinations about values in registers
   from the path we've already checked, compared to the path we are
   considering to take, then we don't have to visit that path at all.

   Once this step passes, the program has been accepted by the
   verifier.

4) Context accesses are converted.

   If you remember from our context discussion the other day, eBPF
   programs access SKB metadata via the passed in context, like this:

	SEC("my_program")
	int my_main(struct __sk_buff *skb)
	{
		void *data_end = (void *)(long)skb->data_end;
		void *data = (void *)(long)skb->data;

   The "struct __sk_buff" if an abstracted version of the real sk_buff
   in the kernel.  It uses fixed offsets so that we can burn in a
   eBPF program facing ABI that will never change, whilst we can
   still make whatever changes we want to the internal kernel sk_buff
   structure.

   So at this point the verifier converts the load instructions emitted
   for those "skb->data" dereferences so that they use the real offset
   the kernel's sk_buff structure has for those members.

5) Function calls are converted.

   Helper functions have a fixed code, which gets inserts into the
   immediate field of the BPF_CALL instructions.  The verifier
   translates this into the actual address of the helper function.

Now, I mentioned earlier that the verifier provides an introspection
mechanism.  This is via the verifier log buffer.

When you use the sys_bpf() system call to load a program, several
attributes are passed in.  One set of those are a LOG buffer pointer,
the length of that log, and a loggging level.

The verifier will emit every instruction is looks at, and by default,
at every basic block boundary, emit the internal register state.  If
the log level is increased to '1', then the internal register state
will be dumped after every instruction.

Let's look at an example, for the BPF code sequence:

	mov	r3, 2
	mov	r3, 4
	mov	r3, 8
	mov	r3, 16
	mov	r3, 32
	mov	r0, 0
	exit

The verifier dump at level 1 looks like:

0: R1=ctx R10=fp
0: (b7) r3 = 2
1: R1=ctx R3=imm2,min_value=2,max_value=2,min_align=2 R10=fp
1: (b7) r3 = 4
2: R1=ctx R3=imm4,min_value=4,max_value=4,min_align=4 R10=fp
2: (b7) r3 = 8
3: R1=ctx R3=imm8,min_value=8,max_value=8,min_align=8 R10=fp
3: (b7) r3 = 16
4: R1=ctx R3=imm16,min_value=16,max_value=16,min_align=16 R10=fp
4: (b7) r3 = 32
5: R1=ctx R3=imm32,min_value=32,max_value=32,min_align=32 R10=fp
5: (b7) r0 = 0
6: R0=imm0,min_value=0,max_value=0,min_align=2147483648 R1=ctx R3=imm32,min_value=32,max_value=32,min_align=32 R10=fp
6: (95) exit

The first number on each line is the instruction number the verifier
is inspecting.  The verifier starts with register state:

	R1=ctx R10=fp

which means that R1 contains a non-NULL context pointer, and R10 is
a frame pointer.

After "mov r3, 2" is analyzed, we have register state:

1: R1=ctx R3=imm2,min_value=2,max_value=2,min_align=2 R10=fp

So what's new is that the verifier now sees that reigster R3 contains
a constant "2", the value range is 2 - 2, and the value is aligned
to "2".

You can capture dumps like this quite simply by using the
bpf_verify_program() library helper.  You can see how this is
used in tools/testing/samples/bpf/test_align.c

That's all for today...
