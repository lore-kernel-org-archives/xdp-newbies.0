Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:52362 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbdJLKVm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Oct 2017 06:21:42 -0400
Received: by mail-wm0-f51.google.com with SMTP id k4so11948646wmc.1
        for <xdp-newbies@vger.kernel.org>; Thu, 12 Oct 2017 03:21:42 -0700 (PDT)
From: Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH, bpf-llvm] Fix bug on silently truncating 64-bit immediate
Date: Thu, 12 Oct 2017 06:21:30 -0400
Message-Id: <1507803690-17709-1-git-send-email-jiong.wang@netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: yhs@fb.com, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>

We came across an llvm bug when compiling some testcases that 64-bit
immediates are silently truncated into 32-bit and then packed into
BPF_JMP | BPF_K encoding.  This caused comparison with wrong value.

This bug looks to be introduced by r308080.  The Select_Ri pattern is
supposed to be lowered into J*_Ri while the latter only support 32-bit
immediate encoding, therefore Select_Ri should have similar immediate
predicate check as what J*_Ri are doing.

Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 lib/Target/BPF/BPFISelLowering.cpp |  8 ++++++--
 lib/Target/BPF/BPFInstrInfo.td     |  2 +-
 test/CodeGen/BPF/select_ri.ll      | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/lib/Target/BPF/BPFISelLowering.cpp b/lib/Target/BPF/BPFISelLowering.cpp
index d4e06dd..995f206 100644
--- a/lib/Target/BPF/BPFISelLowering.cpp
+++ b/lib/Target/BPF/BPFISelLowering.cpp
@@ -611,11 +611,15 @@ BPFTargetLowering::EmitInstrWithCustomInserter(MachineInstr &MI,
         .addReg(LHS)
         .addReg(MI.getOperand(2).getReg())
         .addMBB(Copy1MBB);
-  else
+  else {
+    int64_t imm32 = MI.getOperand(2).getImm();
+    // sanity check before we build J*_ri instruction.
+    assert (isInt<32>(imm32));
     BuildMI(BB, DL, TII.get(NewCC))
         .addReg(LHS)
-        .addImm(MI.getOperand(2).getImm())
+        .addImm(imm32)
         .addMBB(Copy1MBB);
+  }
 
   // Copy0MBB:
   //  %FalseValue = ...
diff --git a/lib/Target/BPF/BPFInstrInfo.td b/lib/Target/BPF/BPFInstrInfo.td
index fcd6a60..a3ad2ee 100644
--- a/lib/Target/BPF/BPFInstrInfo.td
+++ b/lib/Target/BPF/BPFInstrInfo.td
@@ -460,7 +460,7 @@ let usesCustomInserter = 1 in {
                       (ins GPR:$lhs, i64imm:$rhs, i64imm:$imm, GPR:$src, GPR:$src2),
                       "# Select PSEUDO $dst = $lhs $imm $rhs ? $src : $src2",
                       [(set i64:$dst,
-                       (BPFselectcc i64:$lhs, (i64 imm:$rhs), (i64 imm:$imm), i64:$src, i64:$src2))]>;
+                       (BPFselectcc i64:$lhs, (i64immSExt32:$rhs), (i64 imm:$imm), i64:$src, i64:$src2))]>;
 }
 
 // load 64-bit global addr into register
diff --git a/test/CodeGen/BPF/select_ri.ll b/test/CodeGen/BPF/select_ri.ll
index b802b64..7b1f852 100644
--- a/test/CodeGen/BPF/select_ri.ll
+++ b/test/CodeGen/BPF/select_ri.ll
@@ -25,3 +25,38 @@ entry:
 }
 
 attributes #0 = { norecurse nounwind readonly }
+
+; test immediate out of 32-bit range
+; Source file:
+
+; unsigned long long
+; load_word(void *buf, unsigned long long off)
+; asm("llvm.bpf.load.word");
+;
+; int
+; foo(void *buf)
+; {
+;  unsigned long long sum = 0;
+;
+;  sum += load_word(buf, 100);
+;  sum += load_word(buf, 104);
+;
+;  if (sum != 0x1ffffffffULL)
+;    return ~0U;
+;
+;  return 0;
+;}
+
+; Function Attrs: nounwind readonly
+define i32 @foo(i8*) local_unnamed_addr #0 {
+  %2 = tail call i64 @llvm.bpf.load.word(i8* %0, i64 100)
+  %3 = tail call i64 @llvm.bpf.load.word(i8* %0, i64 104)
+  %4 = add i64 %3, %2
+  %5 = icmp ne i64 %4, 8589934591
+; CHECK:  r{{[0-9]+}} = 8589934591 ll
+  %6 = sext i1 %5 to i32
+  ret i32 %6
+}
+
+; Function Attrs: nounwind readonly
+declare i64 @llvm.bpf.load.word(i8*, i64) #1
-- 
2.7.4
