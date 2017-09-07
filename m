Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36972 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753130AbdIGInh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Sep 2017 04:43:37 -0400
Received: by mail-qt0-f173.google.com with SMTP id h15so25782020qta.4
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 01:43:37 -0700 (PDT)
From: Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH RFC] Add BPF AsmParser support in LLVM
Message-ID: <9c6783db-25ac-2854-142a-b44b72cfdc9a@netronome.com>
Date: Thu, 7 Sep 2017 09:43:33 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------EF79ECE80FBA7A35ED32E4AF"
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: iovisor-dev@lists.iovisor.org, Jakub Kicinski <jakub.kicinski@netronome.com>, oss-drivers@netronome.com

This is a multi-part message in MIME format.
--------------EF79ECE80FBA7A35ED32E4AF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

   As discussed at threads:

     https://www.spinics.net/lists/xdp-newbies/msg00320.html
     https://www.spinics.net/lists/xdp-newbies/msg00323.html

   This patch adds the initial BPF AsmParser support in LLVM.

   This support is following the "verifier instruction format" which is C-like.

   Things need to mention are:

     1. LLVM AsmParser doesn't expect the character "*" to be used as the start
        of a statement while BPF "verifier instruction format" is.  So an new
        generic method "starIsStartOfStatement" is introduced.

     2. As the MC assembler is sharing code infrastructure with disassembler, the
        current supported instruction format is *strictly* those registered in
        instruction information .td files.  For example, the parser doesn't
        acccept "*(u8 *)(r0) = r7", instead, you need to write
        "*(u8 *)(r0 + 0) = r7". The offset is mandatory, even when it is zero.
        The instruction information .td files may need to register customized
        ParserMethods to allow more flexible syntaxes.

   The testcase bpf-insn-unit.s contains unit tests for supported syntaxes.

   Comments? Does the current accepted syntaxes look OK?


--------------EF79ECE80FBA7A35ED32E4AF
Content-Type: text/x-patch;
 name="0001-BPF-Enable-BPF-AsmParser.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-BPF-Enable-BPF-AsmParser.patch"

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/llvm/MC/MCParser/MCTargetAsmParser.h |   2 +
 lib/MC/MCParser/AsmParser.cpp                |   5 +
 lib/Target/BPF/AsmParser/BPFAsmParser.cpp    | 472 +++++++++++++++++++++++++++
 lib/Target/BPF/AsmParser/CMakeLists.txt      |   3 +
 lib/Target/BPF/AsmParser/LLVMBuild.txt       |  23 ++
 lib/Target/BPF/CMakeLists.txt                |   1 +
 lib/Target/BPF/LLVMBuild.txt                 |   2 +-
 test/MC/BPF/bpf-insn-unit.s                  | 112 +++++++
 test/MC/BPF/lit.local.cfg                    |   3 +
 9 files changed, 622 insertions(+), 1 deletion(-)
 create mode 100644 lib/Target/BPF/AsmParser/BPFAsmParser.cpp
 create mode 100644 lib/Target/BPF/AsmParser/CMakeLists.txt
 create mode 100644 lib/Target/BPF/AsmParser/LLVMBuild.txt
 create mode 100644 test/MC/BPF/bpf-insn-unit.s
 create mode 100644 test/MC/BPF/lit.local.cfg

diff --git a/include/llvm/MC/MCParser/MCTargetAsmParser.h b/include/llvm/MC/MCParser/MCTargetAsmParser.h
index 6d76d51..e5d5a2a 100644
--- a/include/llvm/MC/MCParser/MCTargetAsmParser.h
+++ b/include/llvm/MC/MCParser/MCTargetAsmParser.h
@@ -266,6 +266,8 @@ public:
   virtual bool equalIsAsmAssignment() { return true; };
   // Return whether this start of statement identifier is a label
   virtual bool isLabel(AsmToken &Token) { return true; };
+  // Return whether this parser accept star as start of statement
+  virtual bool starIsStartOfStatement() { return false; };
 
   virtual const MCExpr *applyModifierToExpr(const MCExpr *E,
                                             MCSymbolRefExpr::VariantKind,
diff --git a/lib/MC/MCParser/AsmParser.cpp b/lib/MC/MCParser/AsmParser.cpp
index 03858d3..ee3cc8d 100644
--- a/lib/MC/MCParser/AsmParser.cpp
+++ b/lib/MC/MCParser/AsmParser.cpp
@@ -1687,6 +1687,11 @@ bool AsmParser::parseStatement(ParseStatementInfo &Info,
     // Treat '}' as a valid identifier in this context.
     Lex();
     IDVal = "}";
+  } else if (Lexer.is(AsmToken::Star) &&
+             getTargetParser().starIsStartOfStatement()) {
+    // Accept '*' as a valid start of statement.
+    Lex();
+    IDVal = "*";
   } else if (parseIdentifier(IDVal)) {
     if (!TheCondState.Ignore) {
       Lex(); // always eat a token
diff --git a/lib/Target/BPF/AsmParser/BPFAsmParser.cpp b/lib/Target/BPF/AsmParser/BPFAsmParser.cpp
new file mode 100644
index 0000000..0db8c26
--- /dev/null
+++ b/lib/Target/BPF/AsmParser/BPFAsmParser.cpp
@@ -0,0 +1,472 @@
+//===-- BPFAsmParser.cpp - Parse BPF assembly to MCInst instructions --===//
+//
+//                     The LLVM Compiler Infrastructure
+//
+// This file is distributed under the University of Illinois Open Source
+// License. See LICENSE.TXT for details.
+//
+//===----------------------------------------------------------------------===//
+
+#include "MCTargetDesc/BPFMCTargetDesc.h"
+#include "llvm/ADT/STLExtras.h"
+#include "llvm/ADT/StringSwitch.h"
+#include "llvm/MC/MCContext.h"
+#include "llvm/MC/MCExpr.h"
+#include "llvm/MC/MCInst.h"
+#include "llvm/MC/MCParser/MCAsmLexer.h"
+#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
+#include "llvm/MC/MCParser/MCTargetAsmParser.h"
+#include "llvm/MC/MCRegisterInfo.h"
+#include "llvm/MC/MCStreamer.h"
+#include "llvm/MC/MCSubtargetInfo.h"
+#include "llvm/Support/Casting.h"
+#include "llvm/Support/TargetRegistry.h"
+
+using namespace llvm;
+
+namespace {
+struct BPFOperand;
+
+class BPFAsmParser : public MCTargetAsmParser {
+  SMLoc getLoc() const { return getParser().getTok().getLoc(); }
+
+  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
+                               OperandVector &Operands, MCStreamer &Out,
+                               uint64_t &ErrorInfo,
+                               bool MatchingInlineAsm) override;
+
+  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) override;
+
+  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
+                        SMLoc NameLoc, OperandVector &Operands) override;
+
+  bool ParseDirective(AsmToken DirectiveID) override;
+
+  // "=" is used as assignment operator for assembly statment, so can't be used
+  // for symbol assignment.
+  bool equalIsAsmAssignment() override { return false; }
+  // "*" is used for dereferencing memory that it will be the start of
+  // statement.
+  bool starIsStartOfStatement() override { return true; }
+
+#define GET_ASSEMBLER_HEADER
+#include "BPFGenAsmMatcher.inc"
+
+  OperandMatchResultTy parseImmediate(OperandVector &Operands);
+  OperandMatchResultTy parseRegister(OperandVector &Operands);
+  OperandMatchResultTy parseOperandAsOperator(OperandVector &Operands);
+
+public:
+  enum BPFMatchResultTy {
+    Match_Dummy = FIRST_TARGET_MATCH_RESULT_TY,
+#define GET_OPERAND_DIAGNOSTIC_TYPES
+#include "BPFGenAsmMatcher.inc"
+#undef GET_OPERAND_DIAGNOSTIC_TYPES
+  };
+
+  BPFAsmParser(const MCSubtargetInfo &STI, MCAsmParser &Parser,
+               const MCInstrInfo &MII, const MCTargetOptions &Options)
+      : MCTargetAsmParser(Options, STI) {
+    setAvailableFeatures(ComputeAvailableFeatures(STI.getFeatureBits()));
+  }
+};
+
+/// BPFOperand - Instances of this class represent a parsed machine
+/// instruction
+struct BPFOperand : public MCParsedAsmOperand {
+
+  enum KindTy {
+    Token,
+    Register,
+    Immediate,
+  } Kind;
+
+  struct RegOp {
+    unsigned RegNum;
+  };
+
+  struct ImmOp {
+    const MCExpr *Val;
+  };
+
+  SMLoc StartLoc, EndLoc;
+  union {
+    StringRef Tok;
+    RegOp Reg;
+    ImmOp Imm;
+  };
+
+  BPFOperand(KindTy K) : MCParsedAsmOperand(), Kind(K) {}
+
+public:
+  BPFOperand(const BPFOperand &o) : MCParsedAsmOperand() {
+    Kind = o.Kind;
+    StartLoc = o.StartLoc;
+    EndLoc = o.EndLoc;
+
+    switch (Kind) {
+    case Register:
+      Reg = o.Reg;
+      break;
+    case Immediate:
+      Imm = o.Imm;
+      break;
+    case Token:
+      Tok = o.Tok;
+      break;
+    }
+  }
+
+  bool isToken() const override { return Kind == Token; }
+  bool isReg() const override { return Kind == Register; }
+  bool isImm() const override { return Kind == Immediate; }
+  bool isMem() const override { return false; }
+
+  bool isConstantImm() const {
+    return isImm() && dyn_cast<MCConstantExpr>(getImm());
+  }
+
+  int64_t getConstantImm() const {
+    const MCExpr *Val = getImm();
+    return static_cast<const MCConstantExpr *>(Val)->getValue();
+  }
+
+  bool isSImm12() const {
+    return (isConstantImm() && isInt<12>(getConstantImm()));
+  }
+
+  /// getStartLoc - Gets location of the first token of this operand
+  SMLoc getStartLoc() const override { return StartLoc; }
+  /// getEndLoc - Gets location of the last token of this operand
+  SMLoc getEndLoc() const override { return EndLoc; }
+
+  unsigned getReg() const override {
+    assert(Kind == Register && "Invalid type access!");
+    return Reg.RegNum;
+  }
+
+  const MCExpr *getImm() const {
+    assert(Kind == Immediate && "Invalid type access!");
+    return Imm.Val;
+  }
+
+  StringRef getToken() const {
+    assert(Kind == Token && "Invalid type access!");
+    return Tok;
+  }
+
+  void print(raw_ostream &OS) const override {
+    switch (Kind) {
+    case Immediate:
+      OS << *getImm();
+      break;
+    case Register:
+      OS << "<register x";
+      OS << getReg() << ">";
+      break;
+    case Token:
+      OS << "'" << getToken() << "'";
+      break;
+    }
+  }
+
+  void addExpr(MCInst &Inst, const MCExpr *Expr) const {
+    assert(Expr && "Expr shouldn't be null!");
+
+    if (auto *CE = dyn_cast<MCConstantExpr>(Expr))
+      Inst.addOperand(MCOperand::createImm(CE->getValue()));
+    else
+      Inst.addOperand(MCOperand::createExpr(Expr));
+  }
+
+  // Used by the TableGen Code
+  void addRegOperands(MCInst &Inst, unsigned N) const {
+    assert(N == 1 && "Invalid number of operands!");
+    Inst.addOperand(MCOperand::createReg(getReg()));
+  }
+
+  void addImmOperands(MCInst &Inst, unsigned N) const {
+    assert(N == 1 && "Invalid number of operands!");
+    addExpr(Inst, getImm());
+  }
+
+  static std::unique_ptr<BPFOperand> createToken(StringRef Str, SMLoc S) {
+    auto Op = make_unique<BPFOperand>(Token);
+    Op->Tok = Str;
+    Op->StartLoc = S;
+    Op->EndLoc = S;
+    return Op;
+  }
+
+  static std::unique_ptr<BPFOperand> createReg(unsigned RegNo, SMLoc S,
+                                               SMLoc E) {
+    auto Op = make_unique<BPFOperand>(Register);
+    Op->Reg.RegNum = RegNo;
+    Op->StartLoc = S;
+    Op->EndLoc = E;
+    return Op;
+  }
+
+  static std::unique_ptr<BPFOperand> createImm(const MCExpr *Val, SMLoc S,
+                                               SMLoc E) {
+    auto Op = make_unique<BPFOperand>(Immediate);
+    Op->Imm.Val = Val;
+    Op->StartLoc = S;
+    Op->EndLoc = E;
+    return Op;
+  }
+
+  // Identifiers that can be used at the start of a statment.
+  static bool isValidIdAtStart(StringRef Name) {
+    return StringSwitch<bool>(Name.lower())
+        .Case("if", true)
+        .Case("call", true)
+        .Case("goto", true)
+        .Case("*", true)
+        .Case("exit", true)
+        .Case("lock", true)
+        .Case("bswap64", true)
+        .Case("bswap32", true)
+        .Case("bswap16", true)
+        .Case("ld_pseudo", true)
+        .Default(false);
+  }
+
+  // Identifiers that can be used in the middle of a statment.
+  static bool isValidIdInMiddle(StringRef Name) {
+    return StringSwitch<bool>(Name.lower())
+        .Case("u64", true)
+        .Case("u32", true)
+        .Case("u16", true)
+        .Case("u8", true)
+        .Case("goto", true)
+        .Case("skb", true)
+        .Case("ll", true)
+        .Case("s", true)
+        .Default(false);
+  }
+};
+} // end anonymous namespace.
+
+#define GET_REGISTER_MATCHER
+#define GET_MATCHER_IMPLEMENTATION
+#include "BPFGenAsmMatcher.inc"
+
+bool BPFAsmParser::MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
+                                           OperandVector &Operands,
+                                           MCStreamer &Out, uint64_t &ErrorInfo,
+                                           bool MatchingInlineAsm) {
+  MCInst Inst;
+  SMLoc ErrorLoc;
+
+  switch (MatchInstructionImpl(Operands, Inst, ErrorInfo, MatchingInlineAsm)) {
+  default:
+    break;
+  case Match_Success:
+    Inst.setLoc(IDLoc);
+    Out.EmitInstruction(Inst, getSTI());
+    return false;
+  case Match_MissingFeature:
+    return Error(IDLoc, "instruction use requires an option to be enabled");
+  case Match_MnemonicFail:
+    return Error(IDLoc, "unrecognized instruction mnemonic");
+  case Match_InvalidOperand:
+    ErrorLoc = IDLoc;
+
+    if (ErrorInfo != ~0U) {
+      if (ErrorInfo >= Operands.size())
+        return Error(ErrorLoc, "too few operands for instruction");
+
+      ErrorLoc = ((BPFOperand &)*Operands[ErrorInfo]).getStartLoc();
+
+      if (ErrorLoc == SMLoc())
+        ErrorLoc = IDLoc;
+    }
+
+    return Error(ErrorLoc, "invalid operand for instruction");
+  }
+
+  llvm_unreachable("Unknown match type detected!");
+}
+
+bool BPFAsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
+                                 SMLoc &EndLoc) {
+  const AsmToken &Tok = getParser().getTok();
+  StartLoc = Tok.getLoc();
+  EndLoc = Tok.getEndLoc();
+  RegNo = 0;
+  StringRef Name = getLexer().getTok().getIdentifier();
+
+  if (!MatchRegisterName(Name)) {
+    getParser().Lex(); // Eat identifier token.
+    return false;
+  }
+
+  return Error(StartLoc, "invalid register name");
+}
+
+OperandMatchResultTy
+BPFAsmParser::parseOperandAsOperator(OperandVector &Operands) {
+  SMLoc S = getLoc();
+
+  if (getLexer().getKind() == AsmToken::Identifier) {
+    StringRef Name = getLexer().getTok().getIdentifier();
+
+    if (BPFOperand::isValidIdInMiddle(Name)) {
+      getLexer().Lex();
+      Operands.push_back(BPFOperand::createToken(Name, S));
+      return MatchOperand_Success;
+    }
+
+    return MatchOperand_NoMatch;
+  }
+
+  switch (getLexer().getKind()) {
+  case AsmToken::Minus:
+  case AsmToken::Plus: {
+    StringRef Name = getLexer().getTok().getString();
+
+    if (getLexer().peekTok().is(AsmToken::Integer))
+      return MatchOperand_NoMatch;
+
+    getLexer().Lex();
+    Operands.push_back(BPFOperand::createToken(Name, S));
+  }
+  // Fall through.
+
+  case AsmToken::Equal:
+  case AsmToken::Greater:
+  case AsmToken::Less:
+  case AsmToken::Pipe:
+  case AsmToken::Star:
+  case AsmToken::LParen:
+  case AsmToken::RParen:
+  case AsmToken::LBrac:
+  case AsmToken::RBrac:
+  case AsmToken::Slash:
+  case AsmToken::Amp:
+  case AsmToken::Percent:
+  case AsmToken::Caret: {
+    StringRef Name = getLexer().getTok().getString();
+    getLexer().Lex();
+    Operands.push_back(BPFOperand::createToken(Name, S));
+
+    return MatchOperand_Success;
+  }
+
+  case AsmToken::EqualEqual:
+  case AsmToken::ExclaimEqual:
+  case AsmToken::GreaterEqual:
+  case AsmToken::GreaterGreater:
+  case AsmToken::LessEqual:
+  case AsmToken::LessLess: {
+    Operands.push_back(BPFOperand::createToken(
+        getLexer().getTok().getString().substr(0, 1), S));
+    Operands.push_back(BPFOperand::createToken(
+        getLexer().getTok().getString().substr(1, 1), S));
+    getLexer().Lex();
+
+    return MatchOperand_Success;
+  }
+
+  default:
+    break;
+  }
+
+  return MatchOperand_NoMatch;
+}
+
+OperandMatchResultTy BPFAsmParser::parseRegister(OperandVector &Operands) {
+  SMLoc S = getLoc();
+  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);
+
+  switch (getLexer().getKind()) {
+  default:
+    return MatchOperand_NoMatch;
+  case AsmToken::Identifier:
+    StringRef Name = getLexer().getTok().getIdentifier();
+    unsigned RegNo = MatchRegisterName(Name);
+
+    if (RegNo == 0)
+      return MatchOperand_NoMatch;
+
+    getLexer().Lex();
+    Operands.push_back(BPFOperand::createReg(RegNo, S, E));
+  }
+  return MatchOperand_Success;
+}
+
+OperandMatchResultTy BPFAsmParser::parseImmediate(OperandVector &Operands) {
+  switch (getLexer().getKind()) {
+  default:
+    return MatchOperand_NoMatch;
+  case AsmToken::LParen:
+  case AsmToken::Minus:
+  case AsmToken::Plus:
+  case AsmToken::Integer:
+  case AsmToken::String:
+  case AsmToken::Identifier:
+    break;
+  }
+
+  const MCExpr *IdVal;
+  SMLoc S = getLoc();
+
+  if (getParser().parseExpression(IdVal))
+    return MatchOperand_ParseFail;
+
+  SMLoc E = SMLoc::getFromPointer(S.getPointer() - 1);
+  Operands.push_back(BPFOperand::createImm(IdVal, S, E));
+
+  return MatchOperand_Success;
+}
+
+/// ParseInstruction - Parse an BPF instruction which is in BPF verifier
+/// format.
+bool BPFAsmParser::ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
+                                    SMLoc NameLoc, OperandVector &Operands) {
+  // The first operand could be either register or actually an operator.
+  unsigned RegNo = MatchRegisterName(Name);
+
+  if (RegNo != 0) {
+    SMLoc E = SMLoc::getFromPointer(NameLoc.getPointer() - 1);
+    Operands.push_back(BPFOperand::createReg(RegNo, NameLoc, E));
+  } else if (BPFOperand::isValidIdAtStart (Name))
+    Operands.push_back(BPFOperand::createToken(Name, NameLoc));
+  else
+    return true;
+
+  while (!getLexer().is(AsmToken::EndOfStatement)) {
+    // Attempt to parse token as operator
+    if (parseOperandAsOperator(Operands) == MatchOperand_Success)
+      continue;
+
+    // Attempt to parse token as register
+    if (parseRegister(Operands) == MatchOperand_Success)
+      continue;
+
+    // Attempt to parse token as an immediate
+    if (parseImmediate(Operands) != MatchOperand_Success)
+      return true;
+  }
+
+  if (getLexer().isNot(AsmToken::EndOfStatement)) {
+    SMLoc Loc = getLexer().getLoc();
+
+    getParser().eatToEndOfStatement();
+
+    return Error(Loc, "unexpected token");
+  }
+
+  // Consume the EndOfStatement.
+  getParser().Lex();
+  return false;
+}
+
+bool BPFAsmParser::ParseDirective(AsmToken DirectiveID) { return true; }
+
+extern "C" void LLVMInitializeBPFAsmParser() {
+  RegisterMCAsmParser<BPFAsmParser> X(getTheBPFTarget());
+  RegisterMCAsmParser<BPFAsmParser> Y(getTheBPFleTarget());
+  RegisterMCAsmParser<BPFAsmParser> Z(getTheBPFbeTarget());
+}
diff --git a/lib/Target/BPF/AsmParser/CMakeLists.txt b/lib/Target/BPF/AsmParser/CMakeLists.txt
new file mode 100644
index 0000000..22fb4f0
--- /dev/null
+++ b/lib/Target/BPF/AsmParser/CMakeLists.txt
@@ -0,0 +1,3 @@
+add_llvm_library(LLVMBPFAsmParser
+  BPFAsmParser.cpp
+  )
diff --git a/lib/Target/BPF/AsmParser/LLVMBuild.txt b/lib/Target/BPF/AsmParser/LLVMBuild.txt
new file mode 100644
index 0000000..2733da9
--- /dev/null
+++ b/lib/Target/BPF/AsmParser/LLVMBuild.txt
@@ -0,0 +1,23 @@
+;===- ./lib/Target/BPF/AsmParser/LLVMBuild.txt ---------------*- Conf -*--===;
+;
+;                     The LLVM Compiler Infrastructure
+;
+; This file is distributed under the University of Illinois Open Source
+; License. See LICENSE.TXT for details.
+;
+;===------------------------------------------------------------------------===;
+;
+; This is an LLVMBuild description file for the components in this subdirectory.
+;
+; For more information on the LLVMBuild system, please see:
+;
+;   http://llvm.org/docs/LLVMBuild.html
+;
+;===------------------------------------------------------------------------===;
+
+[component_0]
+type = Library
+name = BPFAsmParser
+parent = BPF
+required_libraries = MC MCParser BPFDesc BPFInfo Support
+add_to_library_groups = BPF
diff --git a/lib/Target/BPF/CMakeLists.txt b/lib/Target/BPF/CMakeLists.txt
index 4918653..1e4b685 100644
--- a/lib/Target/BPF/CMakeLists.txt
+++ b/lib/Target/BPF/CMakeLists.txt
@@ -23,6 +23,7 @@ add_llvm_target(BPFCodeGen
   BPFTargetMachine.cpp
   )
 
+add_subdirectory(AsmParser)
 add_subdirectory(Disassembler)
 add_subdirectory(InstPrinter)
 add_subdirectory(TargetInfo)
diff --git a/lib/Target/BPF/LLVMBuild.txt b/lib/Target/BPF/LLVMBuild.txt
index 171536d..3f9849b 100644
--- a/lib/Target/BPF/LLVMBuild.txt
+++ b/lib/Target/BPF/LLVMBuild.txt
@@ -16,7 +16,7 @@
 ;===------------------------------------------------------------------------===;
 
 [common]
-subdirectories = InstPrinter Disassembler MCTargetDesc TargetInfo
+subdirectories = AsmParser InstPrinter Disassembler MCTargetDesc TargetInfo
 
 [component_0]
 type = TargetGroup
diff --git a/test/MC/BPF/bpf-insn-unit.s b/test/MC/BPF/bpf-insn-unit.s
new file mode 100644
index 0000000..512e729
--- /dev/null
+++ b/test/MC/BPF/bpf-insn-unit.s
@@ -0,0 +1,112 @@
+# RUN: llvm-mc -triple bpf -filetype=obj -o %t %s
+# RUN: llvm-objdump -d -r %t | FileCheck %s
+
+// ======== BPF_LD Class ========
+// Some extra whitespaces are deliberately added to test the parser.
+
+  r0 = *(u16 *)skb[2] // BPF_LD | BPF_ABS | BPF_H
+  r0 = * (u32*)skb[4] // BPF_LD | BPF_ABS | BPF_W
+
+  r0 = *  (u16 *)skb[r1] // BPF_LD | BPF_IND | BPF_H
+  r0 = *(u32 *)skb[r2]   // BPF_LD | BPF_IND | BPF_W
+
+  r1 = 8589934591 ll     // BPF_LD | BPF_DW | BPF_IMM
+  r1 = dummy_map ll      // Symbolic version
+
+// ======== BPF_LDX Class ========
+  r5 = *(u8 *)(r0 + 0)   // BPF_LDX | BPF_B
+  r6 = *(u16 *)(r1 + 8)  // BPF_LDX | BPF_H
+  r7 = *(u32 *)(r2 + 16) // BPF_LDX | BPF_W
+  r8 = *(u64 *)(r3 - 30) // BPF_LDX | BPF_DW
+
+// ======== TODO: BPF_ST Class ========
+
+// ======== BPF_STX Class ========
+  *(u8 *)(r0 + 0) = r7    // BPF_STX | BPF_B
+  *(u16 *)(r1 + 8) = r8   // BPF_STX | BPF_H
+  *(u32 *)(r2 + 16) = r9  // BPF_STX | BPF_W
+  *(u64 *)(r3 - 30) = r10 // BPF_STX | BPF_DW
+
+  lock *(u32 *)(r2 + 16) += r9  // BPF_STX | BPF_W | BPF_XADD
+  lock *(u64 *)(r3 - 30) += r10 // BPF_STX | BPF_DW | BPF_XADD
+
+// ======== BPF_JMP Class ========
+  goto Llabel0	// BPF_JA
+  if r0 == r1 goto Llabel0   // BPF_JEQ
+  if r1 > r2 goto Llabel0    // BPF_JGT
+  if r2 >= r3 goto Llabel0   // BPF_JGE
+  // TODO: BPF_JSET
+  if r3 != r4 goto Llabel0   // BPF_JNE
+  if r4 s> r5 goto Llabel0   // BPF_JSGT
+  if r5 s>= r6 goto Llabel0  // BPF_JSGE
+  call 1                     // BPF_CALL
+  exit                       // BPF_EXIT
+  if r6 < r7 goto Llabel0    // BPF_JLT
+  if r7 <= r8 goto Llabel0   // BPF_JLE
+  if r8 s< r9 goto Llabel0   // BPF_JSLT
+  if r9 s<= r10 goto Llabel0 // BPF_JSLE
+
+// ======== BPF_ALU64 Class ========
+  r0 += r1    // BPF_ADD
+  r1 -= r2    // BPF_SUB
+  r2 *= r3    // BPF_MUL
+  r3 /= r4    // BPF_DIV
+Llabel0:
+  r4 |= r5    // BPF_OR
+  r5 &= r6    // BPF_AND
+  r6 <<= r7   // BPF_LSH
+  r7 >>= r8   // BPF_RSH
+              // TODO: BPF_NEG
+              // TODO: BPF_MOD
+  r8 ^= r9    // BPF_XOR
+  r9 = r10    // BPF_MOV
+  r10 s>>= r0 // BPF_ARSH
+  bswap16 r1  // BPF_END | BPF_TO_BE
+  bswap32 r2  // BPF_END | BPF_TO_BE
+  bswap64 r3  // BPF_END | BPF_TO_BE
+              // TODO: BPF_END | BPF_TO_LE
+
+// CHECK: 0:	28 00 00 00 02 00 00 00 	r0 = *(u16 *)skb[2]
+// CHECK: 1:	20 00 00 00 04 00 00 00 	r0 = *(u32 *)skb[4]
+// CHECK: 2:	48 10 00 00 00 00 00 00 	r0 = *(u16 *)skb[r1]
+// CHECK: 3:	40 20 00 00 00 00 00 00 	r0 = *(u32 *)skb[r2]
+// CHECK: 4:	18 01 00 00 ff ff ff ff 00 00 00 00 01 00 00 00 	r1 = 8589934591ll
+// CHECK: 6:	18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 	r1 = 0ll
+// CHECK:	0000000000000030:  R_BPF_64_64	dummy_map
+// CHECK: 8:	71 05 00 00 00 00 00 00 	r5 = *(u8 *)(r0 + 0)
+// CHECK: 9:	69 16 08 00 00 00 00 00 	r6 = *(u16 *)(r1 + 8)
+// CHECK: 10:	61 27 10 00 00 00 00 00 	r7 = *(u32 *)(r2 + 16)
+// CHECK: 11:	79 38 e2 ff 00 00 00 00 	r8 = *(u64 *)(r3 - 30)
+// CHECK: 12:	73 70 00 00 00 00 00 00 	*(u8 *)(r0 + 0) = r7
+// CHECK: 13:	6b 81 08 00 00 00 00 00 	*(u16 *)(r1 + 8) = r8
+// CHECK: 14:	63 92 10 00 00 00 00 00 	*(u32 *)(r2 + 16) = r9
+// CHECK: 15:	7b a3 e2 ff 00 00 00 00 	*(u64 *)(r3 - 30) = r10
+// CHECK: 16:	c3 92 10 00 00 00 00 00 	lock *(u32 *)(r2 + 16) += r9
+// CHECK: 17:	db a3 e2 ff 00 00 00 00 	lock *(u64 *)(r3 - 30) += r10
+// CHECK: 18:	05 00 10 00 00 00 00 00 	goto 16
+// CHECK: 19:	1d 10 0f 00 00 00 00 00 	if r0 == r1 goto 15
+// CHECK: 20:	2d 21 0e 00 00 00 00 00 	if r1 > r2 goto 14
+// CHECK: 21:	3d 32 0d 00 00 00 00 00 	if r2 >= r3 goto 13
+// CHECK: 22:	5d 43 0c 00 00 00 00 00 	if r3 != r4 goto 12
+// CHECK: 23:	6d 54 0b 00 00 00 00 00 	if r4 s> r5 goto 11
+// CHECK: 24:	7d 65 0a 00 00 00 00 00 	if r5 s>= r6 goto 10
+// CHECK: 25:	85 00 00 00 01 00 00 00 	call 1
+// CHECK: 26:	95 00 00 00 00 00 00 00 	exit
+// CHECK: 27:	ad 76 07 00 00 00 00 00 	if r6 < r7 goto 7
+// CHECK: 28:	bd 87 06 00 00 00 00 00 	if r7 <= r8 goto 6
+// CHECK: 29:	cd 98 05 00 00 00 00 00 	if r8 s< r9 goto 5
+// CHECK: 30:	dd a9 04 00 00 00 00 00 	if r9 s<= r10 goto 4
+// CHECK: 31:	0f 10 00 00 00 00 00 00 	r0 += r1
+// CHECK: 32:	1f 21 00 00 00 00 00 00 	r1 -= r2
+// CHECK: 33:	2f 32 00 00 00 00 00 00 	r2 *= r3
+// CHECK: 34:	3f 43 00 00 00 00 00 00 	r3 /= r4
+// CHECK: 35:	4f 54 00 00 00 00 00 00 	r4 |= r5
+// CHECK: 36:	5f 65 00 00 00 00 00 00 	r5 &= r6
+// CHECK: 37:	6f 76 00 00 00 00 00 00 	r6 <<= r7
+// CHECK: 38:	7f 87 00 00 00 00 00 00 	r7 >>= r8
+// CHECK: 39:	af 98 00 00 00 00 00 00 	r8 ^= r9
+// CHECK: 40:	bf a9 00 00 00 00 00 00 	r9 = r10
+// CHECK: 41:	cf 0a 00 00 00 00 00 00 	r10 s>>= r0
+// CHECK: 42:	dc 01 00 00 10 00 00 00 	bswap16	r1
+// CHECK: 43:	dc 02 00 00 20 00 00 00 	bswap32	r2
+// CHECK: 44:	dc 03 00 00 40 00 00 00 	bswap64	r3
diff --git a/test/MC/BPF/lit.local.cfg b/test/MC/BPF/lit.local.cfg
new file mode 100644
index 0000000..a089ab8
--- /dev/null
+++ b/test/MC/BPF/lit.local.cfg
@@ -0,0 +1,3 @@
+if not 'BPF' in config.root.targets:
+    config.unsupported = True
+
-- 
2.7.4


--------------EF79ECE80FBA7A35ED32E4AF--
