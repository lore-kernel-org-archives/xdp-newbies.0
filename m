Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:45554 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdIRUsL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Sep 2017 16:48:11 -0400
Received: by mail-wm0-f47.google.com with SMTP id g206so171761wme.0
        for <xdp-newbies@vger.kernel.org>; Mon, 18 Sep 2017 13:48:10 -0700 (PDT)
From: Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH RFC 4/4] Initial 32-bit ALU encoding support in assembler
Date: Mon, 18 Sep 2017 16:47:21 -0400
Message-Id: <1505767641-40512-5-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>

This patch adds instruction patterns for operations in BPF_ALU. After this,
assembler could recognize some 32-bit ALU statement. For example, those listed
int the unit test file.

Separate MOV patterns are unnecessary as MOV is ALU operation that could reuse
ALU encoding infrastructure, this patch removed those redundant patterns.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 lib/Target/BPF/BPFInstrInfo.td                  | 94 +++++++++++++------------
 lib/Target/BPF/Disassembler/BPFDisassembler.cpp | 15 ++++
 test/MC/BPF/insn-unit-32.s                      | 53 ++++++++++++++
 3 files changed, 116 insertions(+), 46 deletions(-)
 create mode 100644 test/MC/BPF/insn-unit-32.s

diff --git a/lib/Target/BPF/BPFInstrInfo.td b/lib/Target/BPF/BPFInstrInfo.td
index 0319cfe..e1f233e 100644
--- a/lib/Target/BPF/BPFInstrInfo.td
+++ b/lib/Target/BPF/BPFInstrInfo.td
@@ -172,37 +172,49 @@ defm JSLE : J<BPF_JSLE, "s<=", BPF_CC_LE>;
 }
 
 // ALU instructions
-class ALU_RI<BPFArithOp Opc, string OpcodeStr, SDNode OpNode>
-    : TYPE_ALU_JMP<Opc.Value, BPF_K.Value,
-                   (outs GPR:$dst),
-                   (ins GPR:$src2, i64imm:$imm),
-                   "$dst "#OpcodeStr#" $imm",
-                   [(set GPR:$dst, (OpNode GPR:$src2, i64immSExt32:$imm))]> {
+class ALU_RI<BPFOpClass Class, BPFArithOp Opc,
+             dag outs, dag ins, string asmstr, list<dag> pattern>
+    : TYPE_ALU_JMP<Opc.Value, BPF_K.Value, outs, ins, asmstr, pattern> {
   bits<4> dst;
   bits<32> imm;
 
   let Inst{51-48} = dst;
   let Inst{31-0} = imm;
-  let BPFClass = BPF_ALU64;
+  let BPFClass = Class;
 }
 
-class ALU_RR<BPFArithOp Opc, string OpcodeStr, SDNode OpNode>
-    : TYPE_ALU_JMP<Opc.Value, BPF_X.Value,
-                   (outs GPR:$dst),
-                   (ins GPR:$src2, GPR:$src),
-                   "$dst "#OpcodeStr#" $src",
-                   [(set GPR:$dst, (OpNode i64:$src2, i64:$src))]> {
+class ALU_RR<BPFOpClass Class, BPFArithOp Opc,
+             dag outs, dag ins, string asmstr, list<dag> pattern>
+    : TYPE_ALU_JMP<Opc.Value, BPF_X.Value, outs, ins, asmstr, pattern> {
   bits<4> dst;
   bits<4> src;
 
   let Inst{55-52} = src;
   let Inst{51-48} = dst;
-  let BPFClass = BPF_ALU64;
+  let BPFClass = Class;
 }
 
 multiclass ALU<BPFArithOp Opc, string OpcodeStr, SDNode OpNode> {
-  def _rr : ALU_RR<Opc, OpcodeStr, OpNode>;
-  def _ri : ALU_RI<Opc, OpcodeStr, OpNode>;
+  def _rr : ALU_RR<BPF_ALU64, Opc,
+                   (outs GPR:$dst),
+                   (ins GPR:$src2, GPR:$src),
+                   "$dst "#OpcodeStr#" $src",
+                   [(set GPR:$dst, (OpNode i64:$src2, i64:$src))]>;
+  def _ri : ALU_RI<BPF_ALU64, Opc,
+                   (outs GPR:$dst),
+                   (ins GPR:$src2, i64imm:$imm),
+                   "$dst "#OpcodeStr#" $imm",
+                   [(set GPR:$dst, (OpNode GPR:$src2, i64immSExt32:$imm))]>;
+  def _rr_32 : ALU_RR<BPF_ALU, Opc,
+                   (outs GPR32:$dst),
+                   (ins GPR32:$src2, GPR32:$src),
+                   "$dst "#OpcodeStr#" $src",
+                   [(set GPR32:$dst, (OpNode i32:$src2, i32:$src))]>;
+  def _ri_32 : ALU_RI<BPF_ALU, Opc,
+                   (outs GPR32:$dst),
+                   (ins GPR32:$src2, i32imm:$imm),
+                   "$dst "#OpcodeStr#" $imm",
+                   [(set GPR32:$dst, (OpNode GPR32:$src2, i32:$imm))]>;
 }
 
 let Constraints = "$dst = $src2" in {
@@ -220,34 +232,6 @@ let isAsCheapAsAMove = 1 in {
   defm DIV : ALU<BPF_DIV, "/=", udiv>;
 }
 
-class MOV_RR<string OpcodeStr>
-    : TYPE_ALU_JMP<BPF_MOV.Value, BPF_X.Value,
-                   (outs GPR:$dst),
-                   (ins GPR:$src),
-                   "$dst "#OpcodeStr#" $src",
-                   []> {
-  bits<4> dst;
-  bits<4> src;
-
-  let Inst{55-52} = src;
-  let Inst{51-48} = dst;
-  let BPFClass = BPF_ALU64;
-}
-
-class MOV_RI<string OpcodeStr>
-    : TYPE_ALU_JMP<BPF_MOV.Value, BPF_K.Value,
-                   (outs GPR:$dst),
-                   (ins i64imm:$imm),
-                   "$dst "#OpcodeStr#" $imm",
-                   [(set GPR:$dst, (i64 i64immSExt32:$imm))]> {
-  bits<4> dst;
-  bits<32> imm;
-
-  let Inst{51-48} = dst;
-  let Inst{31-0} = imm;
-  let BPFClass = BPF_ALU64;
-}
-
 class LD_IMM64<bits<4> Pseudo, string OpcodeStr>
     : TYPE_LD_ST<BPF_IMM.Value, BPF_DW.Value,
                  (outs GPR:$dst),
@@ -267,8 +251,26 @@ class LD_IMM64<bits<4> Pseudo, string OpcodeStr>
 
 let isReMaterializable = 1, isAsCheapAsAMove = 1 in {
 def LD_imm64 : LD_IMM64<0, "=">;
-def MOV_rr : MOV_RR<"=">;
-def MOV_ri : MOV_RI<"=">;
+def MOV_rr : ALU_RR<BPF_ALU64, BPF_MOV,
+                    (outs GPR:$dst),
+                    (ins GPR:$src),
+                    "$dst = $src",
+                    []>;
+def MOV_ri : ALU_RI<BPF_ALU64, BPF_MOV,
+                    (outs GPR:$dst),
+                    (ins i64imm:$imm),
+                    "$dst = $imm",
+                    [(set GPR:$dst, (i64 i64immSExt32:$imm))]>;
+def MOV_rr_32 : ALU_RR<BPF_ALU, BPF_MOV,
+                    (outs GPR32:$dst),
+                    (ins GPR32:$src),
+                    "$dst = $src",
+                    []>;
+def MOV_ri_32 : ALU_RI<BPF_ALU, BPF_MOV,
+                    (outs GPR32:$dst),
+                    (ins i32imm:$imm),
+                    "$dst = $imm",
+                    [(set GPR32:$dst, (i32 i32:$imm))]>;
 }
 
 def FI_ri
diff --git a/lib/Target/BPF/Disassembler/BPFDisassembler.cpp b/lib/Target/BPF/Disassembler/BPFDisassembler.cpp
index a1d732c..f5b621f 100644
--- a/lib/Target/BPF/Disassembler/BPFDisassembler.cpp
+++ b/lib/Target/BPF/Disassembler/BPFDisassembler.cpp
@@ -79,6 +79,21 @@ static DecodeStatus DecodeGPRRegisterClass(MCInst &Inst, unsigned RegNo,
   return MCDisassembler::Success;
 }
 
+static const unsigned GPR32DecoderTable[] = {
+    BPF::W0,  BPF::W1,  BPF::W2,  BPF::W3,  BPF::W4,  BPF::W5,
+    BPF::W6,  BPF::W7,  BPF::W8,  BPF::W9,  BPF::W10, BPF::W11};
+
+static DecodeStatus DecodeGPR32RegisterClass(MCInst &Inst, unsigned RegNo,
+                                             uint64_t /*Address*/,
+                                             const void * /*Decoder*/) {
+  if (RegNo > 11)
+    return MCDisassembler::Fail;
+
+  unsigned Reg = GPR32DecoderTable[RegNo];
+  Inst.addOperand(MCOperand::createReg(Reg));
+  return MCDisassembler::Success;
+}
+
 static DecodeStatus decodeMemoryOpValue(MCInst &Inst, unsigned Insn,
                                         uint64_t Address, const void *Decoder) {
   unsigned Register = (Insn >> 16) & 0xf;
diff --git a/test/MC/BPF/insn-unit-32.s b/test/MC/BPF/insn-unit-32.s
new file mode 100644
index 0000000..77787a9
--- /dev/null
+++ b/test/MC/BPF/insn-unit-32.s
@@ -0,0 +1,53 @@
+# RUN: llvm-mc -triple bpfel -filetype=obj -o %t %s
+# RUN: llvm-objdump -d -r %t | FileCheck %s
+
+// ======== BPF_ALU Class ========
+  w0 += w1    // BPF_ADD  | BPF_X
+  w1 -= w2    // BPF_SUB  | BPF_X
+  w2 *= w3    // BPF_MUL  | BPF_X
+  w3 /= w4    // BPF_DIV  | BPF_X
+// CHECK: 0c 10 00 00 00 00 00 00 	w0 += w1
+// CHECK: 1c 21 00 00 00 00 00 00 	w1 -= w2
+// CHECK: 2c 32 00 00 00 00 00 00 	w2 *= w3
+// CHECK: 3c 43 00 00 00 00 00 00 	w3 /= w4
+
+  w4 |= w5    // BPF_OR   | BPF_X
+  w5 &= w6    // BPF_AND  | BPF_X
+  w6 <<= w7   // BPF_LSH  | BPF_X
+  w7 >>= w8   // BPF_RSH  | BPF_X
+  w8 ^= w9    // BPF_XOR  | BPF_X
+  w9 = w10    // BPF_MOV  | BPF_X
+  w10 s>>= w0 // BPF_ARSH | BPF_X
+// CHECK: 4c 54 00 00 00 00 00 00 	w4 |= w5
+// CHECK: 5c 65 00 00 00 00 00 00 	w5 &= w6
+// CHECK: 6c 76 00 00 00 00 00 00 	w6 <<= w7
+// CHECK: 7c 87 00 00 00 00 00 00 	w7 >>= w8
+// CHECK: ac 98 00 00 00 00 00 00 	w8 ^= w9
+// CHECK: bc a9 00 00 00 00 00 00 	w9 = w10
+// CHECK: cc 0a 00 00 00 00 00 00 	w10 s>>= w0
+
+  w0 += 1           // BPF_ADD  | BPF_K
+  w1 -= 0x1         // BPF_SUB  | BPF_K
+  w2 *= -4          // BPF_MUL  | BPF_K
+  w3 /= 5           // BPF_DIV  | BPF_K
+// CHECK: 04 00 00 00 01 00 00 00 	w0 += 1
+// CHECK: 14 01 00 00 01 00 00 00 	w1 -= 1
+// CHECK: 24 02 00 00 fc ff ff ff 	w2 *= -4
+// CHECK: 34 03 00 00 05 00 00 00 	w3 /= 5
+
+  w4 |= 0xff        // BPF_OR   | BPF_K
+  w5 &= 0xFF        // BPF_AND  | BPF_K
+  w6 <<= 63         // BPF_LSH  | BPF_K
+  w7 >>= 32         // BPF_RSH  | BPF_K
+  w8 ^= 0           // BPF_XOR  | BPF_K
+  w9 = 1            // BPF_MOV  | BPF_K
+  w9 = 0xffffffff   // BPF_MOV  | BPF_K
+  w10 s>>= 64       // BPF_ARSH | BPF_K
+// CHECK: 44 04 00 00 ff 00 00 00 	w4 |= 255
+// CHECK: 54 05 00 00 ff 00 00 00 	w5 &= 255
+// CHECK: 64 06 00 00 3f 00 00 00 	w6 <<= 63
+// CHECK: 74 07 00 00 20 00 00 00 	w7 >>= 32
+// CHECK: a4 08 00 00 00 00 00 00 	w8 ^= 0
+// CHECK: b4 09 00 00 01 00 00 00 	w9 = 1
+// CHECK: b4 09 00 00 ff ff ff ff 	w9 = -1
+// CHECK: c4 0a 00 00 40 00 00 00 	w10 s>>= 64
-- 
2.7.4
