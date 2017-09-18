Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:47903 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdIRUr7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Sep 2017 16:47:59 -0400
Received: by mail-wm0-f52.google.com with SMTP id 13so146827wmq.2
        for <xdp-newbies@vger.kernel.org>; Mon, 18 Sep 2017 13:47:58 -0700 (PDT)
From: Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH RFC 1/4] Improve instruction encoding descriptions
Date: Mon, 18 Sep 2017 16:47:18 -0400
Message-Id: <1505767641-40512-2-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>

Currently, eBPF backend is using some constant directly in instruction patterns,
This patch replace them with mnemonics and removed some unnecessary temparary
variables.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 lib/Target/BPF/BPFInstrFormats.td |  84 ++++++++++-
 lib/Target/BPF/BPFInstrInfo.td    | 290 ++++++++++++++------------------------
 2 files changed, 189 insertions(+), 185 deletions(-)

diff --git a/lib/Target/BPF/BPFInstrFormats.td b/lib/Target/BPF/BPFInstrFormats.td
index 53f3ad6..1e3bc3b 100644
--- a/lib/Target/BPF/BPFInstrFormats.td
+++ b/lib/Target/BPF/BPFInstrFormats.td
@@ -7,6 +7,86 @@
 //
 //===----------------------------------------------------------------------===//
 
+class BPFOpClass<bits<3> val> {
+  bits<3> Value = val;
+}
+
+def BPF_LD    : BPFOpClass<0x0>;
+def BPF_LDX   : BPFOpClass<0x1>;
+def BPF_ST    : BPFOpClass<0x2>;
+def BPF_STX   : BPFOpClass<0x3>;
+def BPF_ALU   : BPFOpClass<0x4>;
+def BPF_JMP   : BPFOpClass<0x5>;
+def BPF_ALU64 : BPFOpClass<0x7>;
+
+class BPFSrcType<bits<1> val> {
+  bits<1> Value = val;
+}
+
+def BPF_K : BPFSrcType<0x0>;
+def BPF_X : BPFSrcType<0x1>;
+
+class BPFArithOp<bits<4> val> {
+  bits<4> Value = val;
+}
+
+def BPF_ADD  : BPFArithOp<0x0>;
+def BPF_SUB  : BPFArithOp<0x1>;
+def BPF_MUL  : BPFArithOp<0x2>;
+def BPF_DIV  : BPFArithOp<0x3>;
+def BPF_OR   : BPFArithOp<0x4>;
+def BPF_AND  : BPFArithOp<0x5>;
+def BPF_LSH  : BPFArithOp<0x6>;
+def BPF_RSH  : BPFArithOp<0x7>;
+def BPF_XOR  : BPFArithOp<0xa>;
+def BPF_MOV  : BPFArithOp<0xb>;
+def BPF_ARSH : BPFArithOp<0xc>;
+def BPF_END  : BPFArithOp<0xd>;
+
+class BPFEndDir<bits<1> val> {
+  bits<1> Value = val;
+}
+
+def BPF_TO_LE : BPFSrcType<0x0>;
+def BPF_TO_BE : BPFSrcType<0x1>;
+
+class BPFJumpOp<bits<4> val> {
+  bits<4> Value = val;
+}
+
+def BPF_JA   : BPFJumpOp<0x0>;
+def BPF_JEQ  : BPFJumpOp<0x1>;
+def BPF_JGT  : BPFJumpOp<0x2>;
+def BPF_JGE  : BPFJumpOp<0x3>;
+def BPF_JNE  : BPFJumpOp<0x5>;
+def BPF_JSGT : BPFJumpOp<0x6>;
+def BPF_JSGE : BPFJumpOp<0x7>;
+def BPF_CALL : BPFJumpOp<0x8>;
+def BPF_EXIT : BPFJumpOp<0x9>;
+def BPF_JLT  : BPFJumpOp<0xa>;
+def BPF_JLE  : BPFJumpOp<0xb>;
+def BPF_JSLT : BPFJumpOp<0xc>;
+def BPF_JSLE : BPFJumpOp<0xd>;
+
+class BPFWidthModifer<bits<2> val> {
+  bits<2> Value = val;
+}
+
+def BPF_W  : BPFWidthModifer<0x0>;
+def BPF_H  : BPFWidthModifer<0x1>;
+def BPF_B  : BPFWidthModifer<0x2>;
+def BPF_DW : BPFWidthModifer<0x3>;
+
+class BPFModeModifer<bits<3> val> {
+  bits<3> Value = val;
+}
+
+def BPF_IMM  : BPFModeModifer<0x0>;
+def BPF_ABS  : BPFModeModifer<0x1>;
+def BPF_IND  : BPFModeModifer<0x2>;
+def BPF_MEM  : BPFModeModifer<0x3>;
+def BPF_XADD : BPFModeModifer<0x6>;
+
 class InstBPF<dag outs, dag ins, string asmstr, list<dag> pattern>
   : Instruction {
   field bits<64> Inst;
@@ -16,8 +96,8 @@ class InstBPF<dag outs, dag ins, string asmstr, list<dag> pattern>
   let Namespace = "BPF";
   let DecoderNamespace = "BPF";
 
-  bits<3> BPFClass;
-  let Inst{58-56} = BPFClass;
+  BPFOpClass BPFClass;
+  let Inst{58-56} = BPFClass.Value;
 
   dag OutOperandList = outs;
   dag InOperandList = ins;
diff --git a/lib/Target/BPF/BPFInstrInfo.td b/lib/Target/BPF/BPFInstrInfo.td
index bef6ce0..5d05105 100644
--- a/lib/Target/BPF/BPFInstrInfo.td
+++ b/lib/Target/BPF/BPFInstrInfo.td
@@ -89,162 +89,138 @@ def BPF_CC_LEU : PatLeaf<(i64 imm),
                          [{return (N->getZExtValue() == ISD::SETULE);}]>;
 
 // jump instructions
-class JMP_RR<bits<4> Opc, string OpcodeStr, PatLeaf Cond>
+class JMP_RR<BPFJumpOp Opc, string OpcodeStr, PatLeaf Cond>
     : InstBPF<(outs), (ins GPR:$dst, GPR:$src, brtarget:$BrDst),
               "if $dst "#OpcodeStr#" $src goto $BrDst",
               [(BPFbrcc i64:$dst, i64:$src, Cond, bb:$BrDst)]> {
-  bits<4> op;
-  bits<1> BPFSrc;
   bits<4> dst;
   bits<4> src;
   bits<16> BrDst;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = Opc.Value;
+  let Inst{59} = BPF_X.Value;
   let Inst{55-52} = src;
   let Inst{51-48} = dst;
   let Inst{47-32} = BrDst;
 
-  let op = Opc;
-  let BPFSrc = 1;
-  let BPFClass = 5; // BPF_JMP
+  let BPFClass = BPF_JMP;
 }
 
-class JMP_RI<bits<4> Opc, string OpcodeStr, PatLeaf Cond>
+class JMP_RI<BPFJumpOp Opc, string OpcodeStr, PatLeaf Cond>
     : InstBPF<(outs), (ins GPR:$dst, i64imm:$imm, brtarget:$BrDst),
               "if $dst "#OpcodeStr#" $imm goto $BrDst",
               [(BPFbrcc i64:$dst, i64immSExt32:$imm, Cond, bb:$BrDst)]> {
-  bits<4> op;
-  bits<1> BPFSrc;
   bits<4> dst;
   bits<16> BrDst;
   bits<32> imm;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = Opc.Value;
+  let Inst{59} = BPF_K.Value;
   let Inst{51-48} = dst;
   let Inst{47-32} = BrDst;
   let Inst{31-0} = imm;
 
-  let op = Opc;
-  let BPFSrc = 0;
-  let BPFClass = 5; // BPF_JMP
+  let BPFClass = BPF_JMP;
 }
 
-multiclass J<bits<4> Opc, string OpcodeStr, PatLeaf Cond> {
+multiclass J<BPFJumpOp Opc, string OpcodeStr, PatLeaf Cond> {
   def _rr : JMP_RR<Opc, OpcodeStr, Cond>;
   def _ri : JMP_RI<Opc, OpcodeStr, Cond>;
 }
 
 let isBranch = 1, isTerminator = 1, hasDelaySlot=0 in {
 // cmp+goto instructions
-defm JEQ  : J<0x1, "==",  BPF_CC_EQ>;
-defm JUGT : J<0x2, ">", BPF_CC_GTU>;
-defm JUGE : J<0x3, ">=", BPF_CC_GEU>;
-defm JNE  : J<0x5, "!=",  BPF_CC_NE>;
-defm JSGT : J<0x6, "s>", BPF_CC_GT>;
-defm JSGE : J<0x7, "s>=", BPF_CC_GE>;
-defm JULT : J<0xa, "<", BPF_CC_LTU>;
-defm JULE : J<0xb, "<=", BPF_CC_LEU>;
-defm JSLT : J<0xc, "s<", BPF_CC_LT>;
-defm JSLE : J<0xd, "s<=", BPF_CC_LE>;
+defm JEQ  : J<BPF_JEQ, "==",  BPF_CC_EQ>;
+defm JUGT : J<BPF_JGT, ">", BPF_CC_GTU>;
+defm JUGE : J<BPF_JGE, ">=", BPF_CC_GEU>;
+defm JNE  : J<BPF_JNE, "!=",  BPF_CC_NE>;
+defm JSGT : J<BPF_JSGT, "s>", BPF_CC_GT>;
+defm JSGE : J<BPF_JSGE, "s>=", BPF_CC_GE>;
+defm JULT : J<BPF_JLT, "<", BPF_CC_LTU>;
+defm JULE : J<BPF_JLE, "<=", BPF_CC_LEU>;
+defm JSLT : J<BPF_JSLT, "s<", BPF_CC_LT>;
+defm JSLE : J<BPF_JSLE, "s<=", BPF_CC_LE>;
 }
 
 // ALU instructions
-class ALU_RI<bits<4> Opc, string OpcodeStr, SDNode OpNode>
+class ALU_RI<BPFArithOp Opc, string OpcodeStr, SDNode OpNode>
     : InstBPF<(outs GPR:$dst), (ins GPR:$src2, i64imm:$imm),
               "$dst "#OpcodeStr#" $imm",
               [(set GPR:$dst, (OpNode GPR:$src2, i64immSExt32:$imm))]> {
-  bits<4> op;
-  bits<1> BPFSrc;
   bits<4> dst;
   bits<32> imm;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = Opc.Value;
+  let Inst{59} = BPF_K.Value;
   let Inst{51-48} = dst;
   let Inst{31-0} = imm;
 
-  let op = Opc;
-  let BPFSrc = 0;
-  let BPFClass = 7; // BPF_ALU64
+  let BPFClass = BPF_ALU64;
 }
 
-class ALU_RR<bits<4> Opc, string OpcodeStr, SDNode OpNode>
+class ALU_RR<BPFArithOp Opc, string OpcodeStr, SDNode OpNode>
     : InstBPF<(outs GPR:$dst), (ins GPR:$src2, GPR:$src),
               "$dst "#OpcodeStr#" $src",
               [(set GPR:$dst, (OpNode i64:$src2, i64:$src))]> {
-  bits<4> op;
-  bits<1> BPFSrc;
   bits<4> dst;
   bits<4> src;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = Opc.Value;
+  let Inst{59} = BPF_X.Value;
   let Inst{55-52} = src;
   let Inst{51-48} = dst;
 
-  let op = Opc;
-  let BPFSrc = 1;
-  let BPFClass = 7; // BPF_ALU64
+  let BPFClass = BPF_ALU64;
 }
 
-multiclass ALU<bits<4> Opc, string OpcodeStr, SDNode OpNode> {
+multiclass ALU<BPFArithOp Opc, string OpcodeStr, SDNode OpNode> {
   def _rr : ALU_RR<Opc, OpcodeStr, OpNode>;
   def _ri : ALU_RI<Opc, OpcodeStr, OpNode>;
 }
 
 let Constraints = "$dst = $src2" in {
 let isAsCheapAsAMove = 1 in {
-  defm ADD : ALU<0x0, "+=", add>;
-  defm SUB : ALU<0x1, "-=", sub>;
-  defm OR  : ALU<0x4, "|=", or>;
-  defm AND : ALU<0x5, "&=", and>;
-  defm SLL : ALU<0x6, "<<=", shl>;
-  defm SRL : ALU<0x7, ">>=", srl>;
-  defm XOR : ALU<0xa, "^=", xor>;
-  defm SRA : ALU<0xc, "s>>=", sra>;
+  defm ADD : ALU<BPF_ADD, "+=", add>;
+  defm SUB : ALU<BPF_SUB, "-=", sub>;
+  defm OR  : ALU<BPF_OR, "|=", or>;
+  defm AND : ALU<BPF_AND, "&=", and>;
+  defm SLL : ALU<BPF_LSH, "<<=", shl>;
+  defm SRL : ALU<BPF_RSH, ">>=", srl>;
+  defm XOR : ALU<BPF_XOR, "^=", xor>;
+  defm SRA : ALU<BPF_ARSH, "s>>=", sra>;
 }
-  defm MUL : ALU<0x2, "*=", mul>;
-  defm DIV : ALU<0x3, "/=", udiv>;
+  defm MUL : ALU<BPF_MUL, "*=", mul>;
+  defm DIV : ALU<BPF_DIV, "/=", udiv>;
 }
 
 class MOV_RR<string OpcodeStr>
     : InstBPF<(outs GPR:$dst), (ins GPR:$src),
               "$dst "#OpcodeStr#" $src",
               []> {
-  bits<4> op;
-  bits<1> BPFSrc;
   bits<4> dst;
   bits<4> src;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = BPF_MOV.Value;
+  let Inst{59} = BPF_X.Value;
   let Inst{55-52} = src;
   let Inst{51-48} = dst;
 
-  let op = 0xb;     // BPF_MOV
-  let BPFSrc = 1;   // BPF_X
-  let BPFClass = 7; // BPF_ALU64
+  let BPFClass = BPF_ALU64;
 }
 
 class MOV_RI<string OpcodeStr>
     : InstBPF<(outs GPR:$dst), (ins i64imm:$imm),
               "$dst "#OpcodeStr#" $imm",
               [(set GPR:$dst, (i64 i64immSExt32:$imm))]> {
-  bits<4> op;
-  bits<1> BPFSrc;
   bits<4> dst;
   bits<32> imm;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = BPF_MOV.Value;
+  let Inst{59} = BPF_K.Value;
   let Inst{51-48} = dst;
   let Inst{31-0} = imm;
 
-  let op = 0xb;     // BPF_MOV
-  let BPFSrc = 0;   // BPF_K
-  let BPFClass = 7; // BPF_ALU64
+  let BPFClass = BPF_ALU64;
 }
 
 class LD_IMM64<bits<4> Pseudo, string OpcodeStr>
@@ -252,21 +228,17 @@ class LD_IMM64<bits<4> Pseudo, string OpcodeStr>
               "$dst "#OpcodeStr#" ${imm} ll",
               [(set GPR:$dst, (i64 imm:$imm))]> {
 
-  bits<3> mode;
-  bits<2> size;
   bits<4> dst;
   bits<64> imm;
 
-  let Inst{63-61} = mode;
-  let Inst{60-59} = size;
+  let Inst{63-61} = BPF_IMM.Value;
+  let Inst{60-59} = BPF_DW.Value;
   let Inst{51-48} = dst;
   let Inst{55-52} = Pseudo;
   let Inst{47-32} = 0;
   let Inst{31-0} = imm{31-0};
 
-  let mode = 0;     // BPF_IMM
-  let size = 3;     // BPF_DW
-  let BPFClass = 0; // BPF_LD
+  let BPFClass = BPF_LD;
 }
 
 let isReMaterializable = 1, isAsCheapAsAMove = 1 in {
@@ -287,7 +259,7 @@ def FI_ri
   let Inst{55-52} = 2;
   let Inst{47-32} = 0;
   let Inst{31-0} = 0;
-  let BPFClass = 0;
+  let BPFClass = BPF_LD;
 }
 
 
@@ -296,115 +268,95 @@ def LD_pseudo
               "ld_pseudo\t$dst, $pseudo, $imm",
               [(set GPR:$dst, (int_bpf_pseudo imm:$pseudo, imm:$imm))]> {
 
-  bits<3> mode;
-  bits<2> size;
   bits<4> dst;
   bits<64> imm;
   bits<4> pseudo;
 
-  let Inst{63-61} = mode;
-  let Inst{60-59} = size;
+  let Inst{63-61} = BPF_IMM.Value;
+  let Inst{60-59} = BPF_DW.Value;
   let Inst{51-48} = dst;
   let Inst{55-52} = pseudo;
   let Inst{47-32} = 0;
   let Inst{31-0} = imm{31-0};
 
-  let mode = 0;     // BPF_IMM
-  let size = 3;     // BPF_DW
-  let BPFClass = 0; // BPF_LD
+  let BPFClass = BPF_LD;
 }
 
 // STORE instructions
-class STORE<bits<2> SizeOp, string OpcodeStr, list<dag> Pattern>
+class STORE<BPFWidthModifer SizeOp, string OpcodeStr, list<dag> Pattern>
     : InstBPF<(outs), (ins GPR:$src, MEMri:$addr),
               "*("#OpcodeStr#" *)($addr) = $src", Pattern> {
-  bits<3> mode;
-  bits<2> size;
   bits<4> src;
   bits<20> addr;
 
-  let Inst{63-61} = mode;
-  let Inst{60-59} = size;
+  let Inst{63-61} = BPF_MEM.Value;
+  let Inst{60-59} = SizeOp.Value;
   let Inst{51-48} = addr{19-16}; // base reg
   let Inst{55-52} = src;
   let Inst{47-32} = addr{15-0}; // offset
 
-  let mode = 3;     // BPF_MEM
-  let size = SizeOp;
-  let BPFClass = 3; // BPF_STX
+  let BPFClass = BPF_STX;
 }
 
-class STOREi64<bits<2> Opc, string OpcodeStr, PatFrag OpNode>
+class STOREi64<BPFWidthModifer Opc, string OpcodeStr, PatFrag OpNode>
     : STORE<Opc, OpcodeStr, [(OpNode i64:$src, ADDRri:$addr)]>;
 
-def STW : STOREi64<0x0, "u32", truncstorei32>;
-def STH : STOREi64<0x1, "u16", truncstorei16>;
-def STB : STOREi64<0x2, "u8", truncstorei8>;
-def STD : STOREi64<0x3, "u64", store>;
+def STW : STOREi64<BPF_W, "u32", truncstorei32>;
+def STH : STOREi64<BPF_H, "u16", truncstorei16>;
+def STB : STOREi64<BPF_B, "u8", truncstorei8>;
+def STD : STOREi64<BPF_DW, "u64", store>;
 
 // LOAD instructions
-class LOAD<bits<2> SizeOp, string OpcodeStr, list<dag> Pattern>
+class LOAD<BPFWidthModifer SizeOp, string OpcodeStr, list<dag> Pattern>
     : InstBPF<(outs GPR:$dst), (ins MEMri:$addr),
               "$dst = *("#OpcodeStr#" *)($addr)", Pattern> {
-  bits<3> mode;
-  bits<2> size;
   bits<4> dst;
   bits<20> addr;
 
-  let Inst{63-61} = mode;
-  let Inst{60-59} = size;
+  let Inst{63-61} = BPF_MEM.Value;
+  let Inst{60-59} = SizeOp.Value;
   let Inst{51-48} = dst;
   let Inst{55-52} = addr{19-16};
   let Inst{47-32} = addr{15-0};
 
-  let mode = 3;     // BPF_MEM
-  let size = SizeOp;
-  let BPFClass = 1; // BPF_LDX
+  let BPFClass = BPF_LDX;
 }
 
-class LOADi64<bits<2> SizeOp, string OpcodeStr, PatFrag OpNode>
+class LOADi64<BPFWidthModifer SizeOp, string OpcodeStr, PatFrag OpNode>
     : LOAD<SizeOp, OpcodeStr, [(set i64:$dst, (OpNode ADDRri:$addr))]>;
 
-def LDW : LOADi64<0x0, "u32", zextloadi32>;
-def LDH : LOADi64<0x1, "u16", zextloadi16>;
-def LDB : LOADi64<0x2, "u8", zextloadi8>;
-def LDD : LOADi64<0x3, "u64", load>;
+def LDW : LOADi64<BPF_W, "u32", zextloadi32>;
+def LDH : LOADi64<BPF_H, "u16", zextloadi16>;
+def LDB : LOADi64<BPF_B, "u8", zextloadi8>;
+def LDD : LOADi64<BPF_DW, "u64", load>;
 
-class BRANCH<bits<4> Opc, string OpcodeStr, list<dag> Pattern>
+class BRANCH<BPFJumpOp Opc, string OpcodeStr, list<dag> Pattern>
     : InstBPF<(outs), (ins brtarget:$BrDst),
               !strconcat(OpcodeStr, " $BrDst"), Pattern> {
-  bits<4> op;
   bits<16> BrDst;
-  bits<1> BPFSrc;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = Opc.Value;
+  let Inst{59} = BPF_K.Value;
   let Inst{47-32} = BrDst;
 
-  let op = Opc;
-  let BPFSrc = 0;
-  let BPFClass = 5; // BPF_JMP
+  let BPFClass = BPF_JMP;
 }
 
 class CALL<string OpcodeStr>
     : InstBPF<(outs), (ins calltarget:$BrDst),
               !strconcat(OpcodeStr, " $BrDst"), []> {
-  bits<4> op;
   bits<32> BrDst;
-  bits<1> BPFSrc;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = BPF_CALL.Value;
+  let Inst{59} = BPF_K.Value;
   let Inst{31-0} = BrDst;
 
-  let op = 8;       // BPF_CALL
-  let BPFSrc = 0;
-  let BPFClass = 5; // BPF_JMP
+  let BPFClass = BPF_JMP;
 }
 
 // Jump always
 let isBranch = 1, isTerminator = 1, hasDelaySlot=0, isBarrier = 1 in {
-  def JMP : BRANCH<0x0, "goto", [(br bb:$BrDst)]>;
+  def JMP : BRANCH<BPF_JA, "goto", [(br bb:$BrDst)]>;
 }
 
 // Jump and link
@@ -418,21 +370,12 @@ class NOP_I<string OpcodeStr>
     : InstBPF<(outs), (ins i32imm:$imm),
               !strconcat(OpcodeStr, "\t$imm"), []> {
   // mov r0, r0 == nop
-  bits<4> op;
-  bits<1> BPFSrc;
-  bits<4> dst;
-  bits<4> src;
-
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
-  let Inst{55-52} = src;
-  let Inst{51-48} = dst;
+  let Inst{63-60} = BPF_MOV.Value;
+  let Inst{59} = BPF_X.Value;
+  let Inst{55-52} = 0;
+  let Inst{51-48} = 0;
 
-  let op = 0xb;     // BPF_MOV
-  let BPFSrc = 1;   // BPF_X
-  let BPFClass = 7; // BPF_ALU64
-  let src = 0;      // R0
-  let dst = 0;      // R0
+  let BPFClass = BPF_ALU64;
 }
 
 let hasSideEffects = 0 in
@@ -441,14 +384,11 @@ let hasSideEffects = 0 in
 class RET<string OpcodeStr>
     : InstBPF<(outs), (ins),
               !strconcat(OpcodeStr, ""), [(BPFretflag)]> {
-  bits<4> op;
-
-  let Inst{63-60} = op;
+  let Inst{63-60} = BPF_EXIT.Value;
   let Inst{59} = 0;
   let Inst{31-0} = 0;
 
-  let op = 9;       // BPF_EXIT
-  let BPFClass = 5; // BPF_JMP
+  let BPFClass = BPF_JMP;
 }
 
 let isReturn = 1, isTerminator = 1, hasDelaySlot=0, isBarrier = 1,
@@ -497,29 +437,25 @@ def : Pat<(extloadi16 ADDRri:$src), (i64 (LDH ADDRri:$src))>;
 def : Pat<(extloadi32 ADDRri:$src), (i64 (LDW ADDRri:$src))>;
 
 // Atomics
-class XADD<bits<2> SizeOp, string OpcodeStr, PatFrag OpNode>
+class XADD<BPFWidthModifer SizeOp, string OpcodeStr, PatFrag OpNode>
     : InstBPF<(outs GPR:$dst), (ins MEMri:$addr, GPR:$val),
               "lock *("#OpcodeStr#" *)($addr) += $val",
               [(set GPR:$dst, (OpNode ADDRri:$addr, GPR:$val))]> {
-  bits<3> mode;
-  bits<2> size;
   bits<4> dst;
   bits<20> addr;
 
-  let Inst{63-61} = mode;
-  let Inst{60-59} = size;
+  let Inst{63-61} = BPF_XADD.Value;
+  let Inst{60-59} = SizeOp.Value;
   let Inst{51-48} = addr{19-16}; // base reg
   let Inst{55-52} = dst;
   let Inst{47-32} = addr{15-0}; // offset
 
-  let mode = 6;     // BPF_XADD
-  let size = SizeOp;
-  let BPFClass = 3; // BPF_STX
+  let BPFClass = BPF_STX;
 }
 
 let Constraints = "$dst = $val" in {
-def XADD32 : XADD<0, "u32", atomic_load_add_32>;
-def XADD64 : XADD<3, "u64", atomic_load_add_64>;
+def XADD32 : XADD<BPF_W, "u32", atomic_load_add_32>;
+def XADD64 : XADD<BPF_DW, "u64", atomic_load_add_64>;
 // undefined def XADD16 : XADD<1, "xadd16", atomic_load_add_16>;
 // undefined def XADD8  : XADD<2, "xadd8", atomic_load_add_8>;
 }
@@ -529,19 +465,15 @@ class BSWAP<bits<32> SizeOp, string OpcodeStr, list<dag> Pattern>
     : InstBPF<(outs GPR:$dst), (ins GPR:$src),
               !strconcat(OpcodeStr, "\t$dst"),
               Pattern> {
-  bits<4> op;
-  bits<1> BPFSrc;
   bits<4> dst;
   bits<32> imm;
 
-  let Inst{63-60} = op;
-  let Inst{59} = BPFSrc;
+  let Inst{63-60} = BPF_END.Value;
+  let Inst{59} = BPF_TO_BE.Value; // (TODO: use BPF_TO_LE for big-endian target)
   let Inst{51-48} = dst;
   let Inst{31-0} = imm;
 
-  let op = 0xd;     // BPF_END
-  let BPFSrc = 1;   // BPF_TO_BE (TODO: use BPF_TO_LE for big-endian target)
-  let BPFClass = 4; // BPF_ALU
+  let BPFClass = BPF_ALU;
   let imm = SizeOp;
 }
 
@@ -553,45 +485,37 @@ def BSWAP64 : BSWAP<64, "bswap64", [(set GPR:$dst, (bswap GPR:$src))]>;
 
 let Defs = [R0, R1, R2, R3, R4, R5], Uses = [R6], hasSideEffects = 1,
     hasExtraDefRegAllocReq = 1, hasExtraSrcRegAllocReq = 1, mayLoad = 1 in {
-class LOAD_ABS<bits<2> SizeOp, string OpcodeStr, Intrinsic OpNode>
+class LOAD_ABS<BPFWidthModifer SizeOp, string OpcodeStr, Intrinsic OpNode>
     : InstBPF<(outs), (ins GPR:$skb, i64imm:$imm),
               "r0 = *("#OpcodeStr#" *)skb[$imm]",
               [(set R0, (OpNode GPR:$skb, i64immSExt32:$imm))]> {
-  bits<3> mode;
-  bits<2> size;
   bits<32> imm;
 
-  let Inst{63-61} = mode;
-  let Inst{60-59} = size;
+  let Inst{63-61} = BPF_ABS.Value;
+  let Inst{60-59} = SizeOp.Value;
   let Inst{31-0} = imm;
 
-  let mode = 1;     // BPF_ABS
-  let size = SizeOp;
-  let BPFClass = 0; // BPF_LD
+  let BPFClass = BPF_LD;
 }
 
-class LOAD_IND<bits<2> SizeOp, string OpcodeStr, Intrinsic OpNode>
+class LOAD_IND<BPFWidthModifer SizeOp, string OpcodeStr, Intrinsic OpNode>
     : InstBPF<(outs), (ins GPR:$skb, GPR:$val),
               "r0 = *("#OpcodeStr#" *)skb[$val]",
               [(set R0, (OpNode GPR:$skb, GPR:$val))]> {
-  bits<3> mode;
-  bits<2> size;
   bits<4> val;
 
-  let Inst{63-61} = mode;
-  let Inst{60-59} = size;
+  let Inst{63-61} = BPF_IND.Value;
+  let Inst{60-59} = SizeOp.Value;
   let Inst{55-52} = val;
 
-  let mode = 2;     // BPF_IND
-  let size = SizeOp;
-  let BPFClass = 0; // BPF_LD
+  let BPFClass = BPF_LD;
 }
 }
 
-def LD_ABS_B : LOAD_ABS<2, "u8", int_bpf_load_byte>;
-def LD_ABS_H : LOAD_ABS<1, "u16", int_bpf_load_half>;
-def LD_ABS_W : LOAD_ABS<0, "u32", int_bpf_load_word>;
+def LD_ABS_B : LOAD_ABS<BPF_B, "u8", int_bpf_load_byte>;
+def LD_ABS_H : LOAD_ABS<BPF_H, "u16", int_bpf_load_half>;
+def LD_ABS_W : LOAD_ABS<BPF_W, "u32", int_bpf_load_word>;
 
-def LD_IND_B : LOAD_IND<2, "u8", int_bpf_load_byte>;
-def LD_IND_H : LOAD_IND<1, "u16", int_bpf_load_half>;
-def LD_IND_W : LOAD_IND<0, "u32", int_bpf_load_word>;
+def LD_IND_B : LOAD_IND<BPF_B, "u8", int_bpf_load_byte>;
+def LD_IND_H : LOAD_IND<BPF_H, "u16", int_bpf_load_half>;
+def LD_IND_W : LOAD_IND<BPF_W, "u32", int_bpf_load_word>;
-- 
2.7.4
