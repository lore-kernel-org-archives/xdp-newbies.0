Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:56073 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdIRUsE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Sep 2017 16:48:04 -0400
Received: by mail-wr0-f176.google.com with SMTP id l39so1493481wrl.12
        for <xdp-newbies@vger.kernel.org>; Mon, 18 Sep 2017 13:48:03 -0700 (PDT)
From: Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH RFC 2/4] Improve class inheritance in instruction patterns
Date: Mon, 18 Sep 2017 16:47:19 -0400
Message-Id: <1505767641-40512-3-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>

Arithmetic and jump instructions, load and store instructions are sharing
the same 8-bit code field encoding,

A better instruction pattern implemention could be the following inheritance
relationships, and each layer only encoding those fields which start to
diverse from that layer. This avoids some redundant code.

  InstBPF -> TYPE_ALU_JMP -> ALU/JMP
  InstBPF -> TYPE_LD_ST -> Load/Store

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 lib/Target/BPF/BPFInstrInfo.td | 238 ++++++++++++++++++++++-------------------
 1 file changed, 127 insertions(+), 111 deletions(-)

diff --git a/lib/Target/BPF/BPFInstrInfo.td b/lib/Target/BPF/BPFInstrInfo.td
index 5d05105..0319cfe 100644
--- a/lib/Target/BPF/BPFInstrInfo.td
+++ b/lib/Target/BPF/BPFInstrInfo.td
@@ -88,38 +88,67 @@ def BPF_CC_LTU : PatLeaf<(i64 imm),
 def BPF_CC_LEU : PatLeaf<(i64 imm),
                          [{return (N->getZExtValue() == ISD::SETULE);}]>;
 
+// For arithmetic and jump instructions the 8-bit 'code'
+// field is divided into three parts:
+//
+//  +----------------+--------+--------------------+
+//  |   4 bits       |  1 bit |   3 bits           |
+//  | operation code | source | instruction class  |
+//  +----------------+--------+--------------------+
+//  (MSB)                                      (LSB)
+class TYPE_ALU_JMP<bits<4> op, bits<1> srctype,
+                   dag outs, dag ins, string asmstr, list<dag> pattern>
+  : InstBPF<outs, ins, asmstr, pattern> {
+
+  let Inst{63-60} = op;
+  let Inst{59} = srctype;
+}
+
+//For load and store instructions the 8-bit 'code' field is divided as:
+//
+//  +--------+--------+-------------------+
+//  | 3 bits | 2 bits |   3 bits          |
+//  |  mode  |  size  | instruction class |
+//  +--------+--------+-------------------+
+//  (MSB)                             (LSB)
+class TYPE_LD_ST<bits<3> mode, bits<2> size,
+                 dag outs, dag ins, string asmstr, list<dag> pattern>
+  : InstBPF<outs, ins, asmstr, pattern> {
+
+  let Inst{63-61} = mode;
+  let Inst{60-59} = size;
+}
+
 // jump instructions
 class JMP_RR<BPFJumpOp Opc, string OpcodeStr, PatLeaf Cond>
-    : InstBPF<(outs), (ins GPR:$dst, GPR:$src, brtarget:$BrDst),
-              "if $dst "#OpcodeStr#" $src goto $BrDst",
-              [(BPFbrcc i64:$dst, i64:$src, Cond, bb:$BrDst)]> {
+    : TYPE_ALU_JMP<Opc.Value, BPF_X.Value,
+                   (outs),
+                   (ins GPR:$dst, GPR:$src, brtarget:$BrDst),
+                   "if $dst "#OpcodeStr#" $src goto $BrDst",
+                   [(BPFbrcc i64:$dst, i64:$src, Cond, bb:$BrDst)]> {
   bits<4> dst;
   bits<4> src;
   bits<16> BrDst;
 
-  let Inst{63-60} = Opc.Value;
-  let Inst{59} = BPF_X.Value;
   let Inst{55-52} = src;
   let Inst{51-48} = dst;
   let Inst{47-32} = BrDst;
-
   let BPFClass = BPF_JMP;
 }
 
 class JMP_RI<BPFJumpOp Opc, string OpcodeStr, PatLeaf Cond>
-    : InstBPF<(outs), (ins GPR:$dst, i64imm:$imm, brtarget:$BrDst),
-              "if $dst "#OpcodeStr#" $imm goto $BrDst",
-              [(BPFbrcc i64:$dst, i64immSExt32:$imm, Cond, bb:$BrDst)]> {
+    : TYPE_ALU_JMP<Opc.Value, BPF_K.Value,
+                   (outs),
+                   (ins GPR:$dst, i64imm:$imm, brtarget:$BrDst),
+                   "if $dst "#OpcodeStr#" $imm goto $BrDst",
+                   [(BPFbrcc i64:$dst, i64immSExt32:$imm, Cond, bb:$BrDst)]> {
   bits<4> dst;
   bits<16> BrDst;
   bits<32> imm;
 
-  let Inst{63-60} = Opc.Value;
-  let Inst{59} = BPF_K.Value;
   let Inst{51-48} = dst;
   let Inst{47-32} = BrDst;
   let Inst{31-0} = imm;
-
   let BPFClass = BPF_JMP;
 }
 
@@ -144,32 +173,30 @@ defm JSLE : J<BPF_JSLE, "s<=", BPF_CC_LE>;
 
 // ALU instructions
 class ALU_RI<BPFArithOp Opc, string OpcodeStr, SDNode OpNode>
-    : InstBPF<(outs GPR:$dst), (ins GPR:$src2, i64imm:$imm),
-              "$dst "#OpcodeStr#" $imm",
-              [(set GPR:$dst, (OpNode GPR:$src2, i64immSExt32:$imm))]> {
+    : TYPE_ALU_JMP<Opc.Value, BPF_K.Value,
+                   (outs GPR:$dst),
+                   (ins GPR:$src2, i64imm:$imm),
+                   "$dst "#OpcodeStr#" $imm",
+                   [(set GPR:$dst, (OpNode GPR:$src2, i64immSExt32:$imm))]> {
   bits<4> dst;
   bits<32> imm;
 
-  let Inst{63-60} = Opc.Value;
-  let Inst{59} = BPF_K.Value;
   let Inst{51-48} = dst;
   let Inst{31-0} = imm;
-
   let BPFClass = BPF_ALU64;
 }
 
 class ALU_RR<BPFArithOp Opc, string OpcodeStr, SDNode OpNode>
-    : InstBPF<(outs GPR:$dst), (ins GPR:$src2, GPR:$src),
-              "$dst "#OpcodeStr#" $src",
-              [(set GPR:$dst, (OpNode i64:$src2, i64:$src))]> {
+    : TYPE_ALU_JMP<Opc.Value, BPF_X.Value,
+                   (outs GPR:$dst),
+                   (ins GPR:$src2, GPR:$src),
+                   "$dst "#OpcodeStr#" $src",
+                   [(set GPR:$dst, (OpNode i64:$src2, i64:$src))]> {
   bits<4> dst;
   bits<4> src;
 
-  let Inst{63-60} = Opc.Value;
-  let Inst{59} = BPF_X.Value;
   let Inst{55-52} = src;
   let Inst{51-48} = dst;
-
   let BPFClass = BPF_ALU64;
 }
 
@@ -194,50 +221,47 @@ let isAsCheapAsAMove = 1 in {
 }
 
 class MOV_RR<string OpcodeStr>
-    : InstBPF<(outs GPR:$dst), (ins GPR:$src),
-              "$dst "#OpcodeStr#" $src",
-              []> {
+    : TYPE_ALU_JMP<BPF_MOV.Value, BPF_X.Value,
+                   (outs GPR:$dst),
+                   (ins GPR:$src),
+                   "$dst "#OpcodeStr#" $src",
+                   []> {
   bits<4> dst;
   bits<4> src;
 
-  let Inst{63-60} = BPF_MOV.Value;
-  let Inst{59} = BPF_X.Value;
   let Inst{55-52} = src;
   let Inst{51-48} = dst;
-
   let BPFClass = BPF_ALU64;
 }
 
 class MOV_RI<string OpcodeStr>
-    : InstBPF<(outs GPR:$dst), (ins i64imm:$imm),
-              "$dst "#OpcodeStr#" $imm",
-              [(set GPR:$dst, (i64 i64immSExt32:$imm))]> {
+    : TYPE_ALU_JMP<BPF_MOV.Value, BPF_K.Value,
+                   (outs GPR:$dst),
+                   (ins i64imm:$imm),
+                   "$dst "#OpcodeStr#" $imm",
+                   [(set GPR:$dst, (i64 i64immSExt32:$imm))]> {
   bits<4> dst;
   bits<32> imm;
 
-  let Inst{63-60} = BPF_MOV.Value;
-  let Inst{59} = BPF_K.Value;
   let Inst{51-48} = dst;
   let Inst{31-0} = imm;
-
   let BPFClass = BPF_ALU64;
 }
 
 class LD_IMM64<bits<4> Pseudo, string OpcodeStr>
-    : InstBPF<(outs GPR:$dst), (ins u64imm:$imm),
-              "$dst "#OpcodeStr#" ${imm} ll",
-              [(set GPR:$dst, (i64 imm:$imm))]> {
+    : TYPE_LD_ST<BPF_IMM.Value, BPF_DW.Value,
+                 (outs GPR:$dst),
+                 (ins u64imm:$imm),
+                 "$dst "#OpcodeStr#" ${imm} ll",
+                 [(set GPR:$dst, (i64 imm:$imm))]> {
 
   bits<4> dst;
   bits<64> imm;
 
-  let Inst{63-61} = BPF_IMM.Value;
-  let Inst{60-59} = BPF_DW.Value;
   let Inst{51-48} = dst;
   let Inst{55-52} = Pseudo;
   let Inst{47-32} = 0;
   let Inst{31-0} = imm{31-0};
-
   let BPFClass = BPF_LD;
 }
 
@@ -248,13 +272,13 @@ def MOV_ri : MOV_RI<"=">;
 }
 
 def FI_ri
-    : InstBPF<(outs GPR:$dst), (ins MEMri:$addr),
-               "lea\t$dst, $addr",
-               [(set i64:$dst, FIri:$addr)]> {
+    : TYPE_LD_ST<BPF_IMM.Value, BPF_DW.Value,
+                 (outs GPR:$dst),
+                 (ins MEMri:$addr),
+                 "lea\t$dst, $addr",
+                 [(set i64:$dst, FIri:$addr)]> {
   // This is a tentative instruction, and will be replaced
   // with MOV_rr and ADD_ri in PEI phase
-  let Inst{63-61} = 0;
-  let Inst{60-59} = 3;
   let Inst{51-48} = 0;
   let Inst{55-52} = 2;
   let Inst{47-32} = 0;
@@ -262,39 +286,37 @@ def FI_ri
   let BPFClass = BPF_LD;
 }
 
-
 def LD_pseudo
-    : InstBPF<(outs GPR:$dst), (ins i64imm:$pseudo, u64imm:$imm),
-              "ld_pseudo\t$dst, $pseudo, $imm",
-              [(set GPR:$dst, (int_bpf_pseudo imm:$pseudo, imm:$imm))]> {
+    : TYPE_LD_ST<BPF_IMM.Value, BPF_DW.Value,
+                 (outs GPR:$dst),
+                 (ins i64imm:$pseudo, u64imm:$imm),
+                 "ld_pseudo\t$dst, $pseudo, $imm",
+                 [(set GPR:$dst, (int_bpf_pseudo imm:$pseudo, imm:$imm))]> {
 
   bits<4> dst;
   bits<64> imm;
   bits<4> pseudo;
 
-  let Inst{63-61} = BPF_IMM.Value;
-  let Inst{60-59} = BPF_DW.Value;
   let Inst{51-48} = dst;
   let Inst{55-52} = pseudo;
   let Inst{47-32} = 0;
   let Inst{31-0} = imm{31-0};
-
   let BPFClass = BPF_LD;
 }
 
 // STORE instructions
 class STORE<BPFWidthModifer SizeOp, string OpcodeStr, list<dag> Pattern>
-    : InstBPF<(outs), (ins GPR:$src, MEMri:$addr),
-              "*("#OpcodeStr#" *)($addr) = $src", Pattern> {
+    : TYPE_LD_ST<BPF_MEM.Value, SizeOp.Value,
+                 (outs),
+                 (ins GPR:$src, MEMri:$addr),
+                 "*("#OpcodeStr#" *)($addr) = $src",
+                 Pattern> {
   bits<4> src;
   bits<20> addr;
 
-  let Inst{63-61} = BPF_MEM.Value;
-  let Inst{60-59} = SizeOp.Value;
   let Inst{51-48} = addr{19-16}; // base reg
   let Inst{55-52} = src;
   let Inst{47-32} = addr{15-0}; // offset
-
   let BPFClass = BPF_STX;
 }
 
@@ -308,17 +330,17 @@ def STD : STOREi64<BPF_DW, "u64", store>;
 
 // LOAD instructions
 class LOAD<BPFWidthModifer SizeOp, string OpcodeStr, list<dag> Pattern>
-    : InstBPF<(outs GPR:$dst), (ins MEMri:$addr),
-              "$dst = *("#OpcodeStr#" *)($addr)", Pattern> {
+    : TYPE_LD_ST<BPF_MEM.Value, SizeOp.Value,
+                 (outs GPR:$dst),
+                 (ins MEMri:$addr),
+                 "$dst = *("#OpcodeStr#" *)($addr)",
+                 Pattern> {
   bits<4> dst;
   bits<20> addr;
 
-  let Inst{63-61} = BPF_MEM.Value;
-  let Inst{60-59} = SizeOp.Value;
   let Inst{51-48} = dst;
   let Inst{55-52} = addr{19-16};
   let Inst{47-32} = addr{15-0};
-
   let BPFClass = BPF_LDX;
 }
 
@@ -331,26 +353,26 @@ def LDB : LOADi64<BPF_B, "u8", zextloadi8>;
 def LDD : LOADi64<BPF_DW, "u64", load>;
 
 class BRANCH<BPFJumpOp Opc, string OpcodeStr, list<dag> Pattern>
-    : InstBPF<(outs), (ins brtarget:$BrDst),
-              !strconcat(OpcodeStr, " $BrDst"), Pattern> {
+    : TYPE_ALU_JMP<Opc.Value, BPF_K.Value,
+                   (outs),
+                   (ins brtarget:$BrDst),
+                   !strconcat(OpcodeStr, " $BrDst"),
+                   Pattern> {
   bits<16> BrDst;
 
-  let Inst{63-60} = Opc.Value;
-  let Inst{59} = BPF_K.Value;
   let Inst{47-32} = BrDst;
-
   let BPFClass = BPF_JMP;
 }
 
 class CALL<string OpcodeStr>
-    : InstBPF<(outs), (ins calltarget:$BrDst),
-              !strconcat(OpcodeStr, " $BrDst"), []> {
+    : TYPE_ALU_JMP<BPF_CALL.Value, BPF_K.Value,
+                   (outs),
+                   (ins calltarget:$BrDst),
+                   !strconcat(OpcodeStr, " $BrDst"),
+                   []> {
   bits<32> BrDst;
 
-  let Inst{63-60} = BPF_CALL.Value;
-  let Inst{59} = BPF_K.Value;
   let Inst{31-0} = BrDst;
-
   let BPFClass = BPF_JMP;
 }
 
@@ -367,14 +389,14 @@ let isCall=1, hasDelaySlot=0, Uses = [R11],
 }
 
 class NOP_I<string OpcodeStr>
-    : InstBPF<(outs), (ins i32imm:$imm),
-              !strconcat(OpcodeStr, "\t$imm"), []> {
+    : TYPE_ALU_JMP<BPF_MOV.Value, BPF_X.Value,
+                   (outs),
+                   (ins i32imm:$imm),
+                   !strconcat(OpcodeStr, "\t$imm"),
+                   []> {
   // mov r0, r0 == nop
-  let Inst{63-60} = BPF_MOV.Value;
-  let Inst{59} = BPF_X.Value;
   let Inst{55-52} = 0;
   let Inst{51-48} = 0;
-
   let BPFClass = BPF_ALU64;
 }
 
@@ -382,12 +404,12 @@ let hasSideEffects = 0 in
   def NOP : NOP_I<"nop">;
 
 class RET<string OpcodeStr>
-    : InstBPF<(outs), (ins),
-              !strconcat(OpcodeStr, ""), [(BPFretflag)]> {
-  let Inst{63-60} = BPF_EXIT.Value;
-  let Inst{59} = 0;
+    : TYPE_ALU_JMP<BPF_EXIT.Value, BPF_K.Value,
+                   (outs),
+                   (ins),
+                   !strconcat(OpcodeStr, ""),
+                   [(BPFretflag)]> {
   let Inst{31-0} = 0;
-
   let BPFClass = BPF_JMP;
 }
 
@@ -438,18 +460,17 @@ def : Pat<(extloadi32 ADDRri:$src), (i64 (LDW ADDRri:$src))>;
 
 // Atomics
 class XADD<BPFWidthModifer SizeOp, string OpcodeStr, PatFrag OpNode>
-    : InstBPF<(outs GPR:$dst), (ins MEMri:$addr, GPR:$val),
-              "lock *("#OpcodeStr#" *)($addr) += $val",
-              [(set GPR:$dst, (OpNode ADDRri:$addr, GPR:$val))]> {
+    : TYPE_LD_ST<BPF_XADD.Value, SizeOp.Value,
+                 (outs GPR:$dst),
+                 (ins MEMri:$addr, GPR:$val),
+                 "lock *("#OpcodeStr#" *)($addr) += $val",
+                 [(set GPR:$dst, (OpNode ADDRri:$addr, GPR:$val))]> {
   bits<4> dst;
   bits<20> addr;
 
-  let Inst{63-61} = BPF_XADD.Value;
-  let Inst{60-59} = SizeOp.Value;
   let Inst{51-48} = addr{19-16}; // base reg
   let Inst{55-52} = dst;
   let Inst{47-32} = addr{15-0}; // offset
-
   let BPFClass = BPF_STX;
 }
 
@@ -462,19 +483,16 @@ def XADD64 : XADD<BPF_DW, "u64", atomic_load_add_64>;
 
 // bswap16, bswap32, bswap64
 class BSWAP<bits<32> SizeOp, string OpcodeStr, list<dag> Pattern>
-    : InstBPF<(outs GPR:$dst), (ins GPR:$src),
-              !strconcat(OpcodeStr, "\t$dst"),
-              Pattern> {
+    : TYPE_ALU_JMP<BPF_END.Value, BPF_TO_BE.Value,
+                   (outs GPR:$dst),
+                   (ins GPR:$src),
+                   !strconcat(OpcodeStr, "\t$dst"),
+                   Pattern> {
   bits<4> dst;
-  bits<32> imm;
 
-  let Inst{63-60} = BPF_END.Value;
-  let Inst{59} = BPF_TO_BE.Value; // (TODO: use BPF_TO_LE for big-endian target)
   let Inst{51-48} = dst;
-  let Inst{31-0} = imm;
-
+  let Inst{31-0} = SizeOp;
   let BPFClass = BPF_ALU;
-  let imm = SizeOp;
 }
 
 let Constraints = "$dst = $src" in {
@@ -486,28 +504,26 @@ def BSWAP64 : BSWAP<64, "bswap64", [(set GPR:$dst, (bswap GPR:$src))]>;
 let Defs = [R0, R1, R2, R3, R4, R5], Uses = [R6], hasSideEffects = 1,
     hasExtraDefRegAllocReq = 1, hasExtraSrcRegAllocReq = 1, mayLoad = 1 in {
 class LOAD_ABS<BPFWidthModifer SizeOp, string OpcodeStr, Intrinsic OpNode>
-    : InstBPF<(outs), (ins GPR:$skb, i64imm:$imm),
-              "r0 = *("#OpcodeStr#" *)skb[$imm]",
-              [(set R0, (OpNode GPR:$skb, i64immSExt32:$imm))]> {
+    : TYPE_LD_ST<BPF_ABS.Value, SizeOp.Value,
+                 (outs),
+                 (ins GPR:$skb, i64imm:$imm),
+                 "r0 = *("#OpcodeStr#" *)skb[$imm]",
+                 [(set R0, (OpNode GPR:$skb, i64immSExt32:$imm))]> {
   bits<32> imm;
 
-  let Inst{63-61} = BPF_ABS.Value;
-  let Inst{60-59} = SizeOp.Value;
   let Inst{31-0} = imm;
-
   let BPFClass = BPF_LD;
 }
 
 class LOAD_IND<BPFWidthModifer SizeOp, string OpcodeStr, Intrinsic OpNode>
-    : InstBPF<(outs), (ins GPR:$skb, GPR:$val),
-              "r0 = *("#OpcodeStr#" *)skb[$val]",
-              [(set R0, (OpNode GPR:$skb, GPR:$val))]> {
+    : TYPE_LD_ST<BPF_IND.Value, SizeOp.Value,
+                 (outs),
+                 (ins GPR:$skb, GPR:$val),
+                 "r0 = *("#OpcodeStr#" *)skb[$val]",
+                 [(set R0, (OpNode GPR:$skb, GPR:$val))]> {
   bits<4> val;
 
-  let Inst{63-61} = BPF_IND.Value;
-  let Inst{60-59} = SizeOp.Value;
   let Inst{55-52} = val;
-
   let BPFClass = BPF_LD;
 }
 }
-- 
2.7.4
