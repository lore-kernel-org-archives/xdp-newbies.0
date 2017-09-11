Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:32974 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdIKO25 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 11 Sep 2017 10:28:57 -0400
Received: by mail-wr0-f177.google.com with SMTP id a43so15093117wrc.0
        for <xdp-newbies@vger.kernel.org>; Mon, 11 Sep 2017 07:28:56 -0700 (PDT)
Subject: [v2][PATCH RFC] Add BPF AsmParser support in LLVM
References: <9c6783db-25ac-2854-142a-b44b72cfdc9a@netronome.com>
 <CAH3MdRVUmUbT4295RBr2EyoNJHTGHgvxo8c-wG3e2bJr0DiA4Q@mail.gmail.com>
 <ed89863b-97b6-ecaf-e710-e2cafab30325@netronome.com>
 <CAH3MdRXbVb-gTKdaiFCpy6zoEVJRTME_0HXHwp+p__zJ=RiEXA@mail.gmail.com>
From: Jiong Wang <jiong.wang@netronome.com>
Message-ID: <a9e3b287-f10e-72b7-0836-f3ec393c2b59@netronome.com>
Date: Mon, 11 Sep 2017 15:28:52 +0100
MIME-Version: 1.0
In-Reply-To: <CAH3MdRXbVb-gTKdaiFCpy6zoEVJRTME_0HXHwp+p__zJ=RiEXA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------4356372CAEAAD6F8A7D1BF4C"
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Y Song <ys114321@gmail.com>
Cc: xdp-newbies@vger.kernel.org, oss-drivers@netronome.com, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>, Jakub Kicinski <jakub.kicinski@netronome.com>

This is a multi-part message in MIME format.
--------------4356372CAEAAD6F8A7D1BF4C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/17 00:47, Y Song wrote:
> On Fri, Sep 8, 2017 at 1:00 PM, Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>> Hi Y Song,
>>
>>   Thanks for the review and test.
>>
>> [snip]
>>>
>>> I guess, we may need to add something like LD_VAR_ADDR so that
>>> the proper assembly code can be issued. Also we could drop "ll" with
>>> "r1 = tx_port"?
>>
>>
>> Personally, I prefer drop "ll". The "ll" suffix was there to tell people it is 64bit
>> constant while the register "r1" is with 64-bit width so I feel it is enough. For
>> 32-bit situation, we need new register set, some thing like "w1 = tx_port".
>
> I just push a patch (similar to your suggestion below but without
> assertion) which still has
> "ll" suffix for the constant, but no "ll" suffix for symbols. The
> reason is that  we use "ll"
> in the asm printout to differentiate "r = 5"=>"mov r, 5" (32bit imm) and
> "r = 5ll" => "ld_imm64 r, 5ll" (64bit imm).
>
> Also, for long long constant, C standard does not allow space between
> value and "ll" and
> hence "567 ll" is not allowed to represent a number "567ll". Could you
> try to disallow
> 64bit immediate like "567 ll" as well in your patch?

Hi Y Song,

Thanks, patch updated, please review.

Changes since the initial version:

   * Addressed all comments on instruction unit tests.
     - Renamed test file to "insn-unit.s".
     - Removed unnecessary comments.
     - Added BPF_B tests for load and store.
     - Added BPF_K test for jmp and alu.
       (Noticed a seperate issue with unsigned compare then jump. Looks like BPF
        backend is alway printing the immediate as signed, I guess we need to
        change the operand types in instruction patterns.)
     - Adjusted constant load tests.
     - Interleaved the expected results with input insns.

   * Changed the disassembly output "ll" to "LL" in BPFInstPrinter.cpp.
     This is because I noticed MC parser only accept "LL" as long long suffix.
     It might be the reason documented here:

       https://www.securecoding.cert.org/confluence/pages/viewpage.action?pageId=19759250


--------------4356372CAEAAD6F8A7D1BF4C
Content-Type: text/x-patch;
 name="bpf-asmparser-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bpf-asmparser-v2.patch"

Reviewed-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>

---
 include/llvm/MC/MCParser/MCTargetAsmParser.h  |   2 +
 lib/MC/MCParser/AsmParser.cpp                 |   5 +
 lib/Target/BPF/AsmParser/BPFAsmParser.cpp     | 471 ++++++++++++++++++++++++++
 lib/Target/BPF/AsmParser/CMakeLists.txt       |   3 +
 lib/Target/BPF/AsmParser/LLVMBuild.txt        |  23 ++
 lib/Target/BPF/CMakeLists.txt                 |   1 +
 lib/Target/BPF/InstPrinter/BPFInstPrinter.cpp |   2 +-
 lib/Target/BPF/LLVMBuild.txt                  |   2 +-
 test/MC/BPF/insn-unit.s                       | 164 +++++++++
 test/MC/BPF/lit.local.cfg                     |   3 +
 10 files changed, 674 insertions(+), 2 deletions(-)
 create mode 100644 lib/Target/BPF/AsmParser/BPFAsmParser.cpp
 create mode 100644 lib/Target/BPF/AsmParser/CMakeLists.txt
 create mode 100644 lib/Target/BPF/AsmParser/LLVMBuild.txt
 create mode 100644 test/MC/BPF/insn-unit.s
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
index 0000000..a36d8b1
--- /dev/null
+++ b/lib/Target/BPF/AsmParser/BPFAsmParser.cpp
@@ -0,0 +1,471 @@
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
diff --git a/lib/Target/BPF/InstPrinter/BPFInstPrinter.cpp b/lib/Target/BPF/InstPrinter/BPFInstPrinter.cpp
index bb5546e..11b3f5f 100644
--- a/lib/Target/BPF/InstPrinter/BPFInstPrinter.cpp
+++ b/lib/Target/BPF/InstPrinter/BPFInstPrinter.cpp
@@ -88,7 +88,7 @@ void BPFInstPrinter::printImm64Operand(const MCInst *MI, unsigned OpNo,
                                        raw_ostream &O) {
   const MCOperand &Op = MI->getOperand(OpNo);
   if (Op.isImm())
-    O << (uint64_t)Op.getImm() << "ll";
+    O << (uint64_t)Op.getImm() << "LL";
   else if (Op.isExpr())
     printExpr(Op.getExpr(), O);
   else
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
diff --git a/test/MC/BPF/insn-unit.s b/test/MC/BPF/insn-unit.s
new file mode 100644
index 0000000..a1fcdbb
--- /dev/null
+++ b/test/MC/BPF/insn-unit.s
@@ -0,0 +1,164 @@
+# RUN: llvm-mc -triple bpf -filetype=obj -o %t %s
+# RUN: llvm-objdump -d -r %t | FileCheck %s
+
+// ======== BPF_LD Class ========
+// Some extra whitespaces are deliberately added to test the parser.
+
+  r0 = * (u8 *)skb[0]    // BPF_LD | BPF_ABS | BPF_B
+  r0 = *(u16 *)skb[2]    // BPF_LD | BPF_ABS | BPF_H
+  r0 = * (u32*)skb[4]    // BPF_LD | BPF_ABS | BPF_W
+// CHECK: 30 00 00 00 00 00 00 00 	r0 = *(u8 *)skb[0]
+// CHECK: 28 00 00 00 02 00 00 00 	r0 = *(u16 *)skb[2]
+// CHECK: 20 00 00 00 04 00 00 00 	r0 = *(u32 *)skb[4]
+
+  r0 = * (u8 *)skb[r0]   // BPF_LD | BPF_IND | BPF_B
+  r0 = *  (u16 *)skb[r1] // BPF_LD | BPF_IND | BPF_H
+  r0 = *(u32 *)skb[r2]   // BPF_LD | BPF_IND | BPF_W
+// CHECK: 50 00 00 00 00 00 00 00 	r0 = *(u8 *)skb[r0]
+// CHECK: 48 10 00 00 00 00 00 00 	r0 = *(u16 *)skb[r1]
+// CHECK: 40 20 00 00 00 00 00 00 	r0 = *(u32 *)skb[r2]
+
+  r9 = 0xffffffff        // BPF_LD | BPF_DW | BPF_IMM
+  r9 = 8589934591LL      // BPF_LD | BPF_DW | BPF_IMM
+  r9 = 8589934591        // BPF_LD | BPF_DW | BPF_IMM
+  r9 = dummy_map         // BPF_LD | BPF_DW | BPF_IMM
+// CHECK: 18 09 00 00 ff ff ff ff 00 00 00 00 00 00 00 00 	r9 = 4294967295LL
+// CHECK: 18 09 00 00 ff ff ff ff 00 00 00 00 01 00 00 00 	r9 = 8589934591LL
+// CHECK: 18 09 00 00 ff ff ff ff 00 00 00 00 01 00 00 00 	r9 = 8589934591LL
+// CHECK: 18 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00 	r9 = 0LL
+// CHECK: 0000000000000060:  R_BPF_64_64	dummy_map
+
+// ======== BPF_LDX Class ========
+  r5 = *(u8 *)(r0 + 0)   // BPF_LDX | BPF_B
+  r6 = *(u16 *)(r1 + 8)  // BPF_LDX | BPF_H
+  r7 = *(u32 *)(r2 + 16) // BPF_LDX | BPF_W
+  r8 = *(u64 *)(r3 - 30) // BPF_LDX | BPF_DW
+// CHECK: 71 05 00 00 00 00 00 00 	r5 = *(u8 *)(r0 + 0)
+// CHECK: 69 16 08 00 00 00 00 00 	r6 = *(u16 *)(r1 + 8)
+// CHECK: 61 27 10 00 00 00 00 00 	r7 = *(u32 *)(r2 + 16)
+// CHECK: 79 38 e2 ff 00 00 00 00 	r8 = *(u64 *)(r3 - 30)
+
+// ======== BPF_STX Class ========
+  *(u8 *)(r0 + 0) = r7    // BPF_STX | BPF_B
+  *(u16 *)(r1 + 8) = r8   // BPF_STX | BPF_H
+  *(u32 *)(r2 + 16) = r9  // BPF_STX | BPF_W
+  *(u64 *)(r3 - 30) = r10 // BPF_STX | BPF_DW
+// CHECK: 73 70 00 00 00 00 00 00 	*(u8 *)(r0 + 0) = r7
+// CHECK: 6b 81 08 00 00 00 00 00 	*(u16 *)(r1 + 8) = r8
+// CHECK: 63 92 10 00 00 00 00 00 	*(u32 *)(r2 + 16) = r9
+// CHECK: 7b a3 e2 ff 00 00 00 00 	*(u64 *)(r3 - 30) = r10
+
+  lock *(u32 *)(r2 + 16) += r9  // BPF_STX | BPF_W | BPF_XADD
+  lock *(u64 *)(r3 - 30) += r10 // BPF_STX | BPF_DW | BPF_XADD
+// CHECK: c3 92 10 00 00 00 00 00 	lock *(u32 *)(r2 + 16) += r9
+// CHECK: db a3 e2 ff 00 00 00 00 	lock *(u64 *)(r3 - 30) += r10
+
+// ======== BPF_JMP Class ========
+  goto Llabel0               // BPF_JA
+  call 1                     // BPF_CALL
+  exit                       // BPF_EXIT
+// CHECK: 05 00 1a 00 00 00 00 00 	goto 26
+// CHECK: 85 00 00 00 01 00 00 00 	call 1
+// CHECK: 95 00 00 00 00 00 00 00 	exit
+
+  if r0 == r1 goto Llabel0   // BPF_JEQ  | BPF_X
+  if r3 != r4 goto Llabel0   // BPF_JNE  | BPF_X
+// CHECK: 1d 10 17 00 00 00 00 00 	if r0 == r1 goto 23
+// CHECK: 5d 43 16 00 00 00 00 00 	if r3 != r4 goto 22
+
+  if r1 > r2 goto Llabel0    // BPF_JGT  | BPF_X
+  if r2 >= r3 goto Llabel0   // BPF_JGE  | BPF_X
+  if r4 s> r5 goto Llabel0   // BPF_JSGT | BPF_X
+  if r5 s>= r6 goto Llabel0  // BPF_JSGE | BPF_X
+// CHECK: 2d 21 15 00 00 00 00 00 	if r1 > r2 goto 21
+// CHECK: 3d 32 14 00 00 00 00 00 	if r2 >= r3 goto 20
+// CHECK: 6d 54 13 00 00 00 00 00 	if r4 s> r5 goto 19
+// CHECK: 7d 65 12 00 00 00 00 00 	if r5 s>= r6 goto 18
+
+  if r6 < r7 goto Llabel0    // BPF_JLT  | BPF_X
+  if r7 <= r8 goto Llabel0   // BPF_JLE  | BPF_X
+  if r8 s< r9 goto Llabel0   // BPF_JSLT | BPF_X
+  if r9 s<= r10 goto Llabel0 // BPF_JSLE | BPF_X
+// CHECK: ad 76 11 00 00 00 00 00 	if r6 < r7 goto 17
+// CHECK: bd 87 10 00 00 00 00 00 	if r7 <= r8 goto 16
+// CHECK: cd 98 0f 00 00 00 00 00 	if r8 s< r9 goto 15
+// CHECK: dd a9 0e 00 00 00 00 00 	if r9 s<= r10 goto 14
+
+  if r0 == 0 goto Llabel0           // BPF_JEQ  | BPF_K
+  if r3 != -1 goto Llabel0          // BPF_JNE  | BPF_K
+// CHECK: 15 00 0d 00 00 00 00 00 	if r0 == 0 goto 13
+// CHECK: 55 03 0c 00 ff ff ff ff 	if r3 != -1 goto 12
+
+  if r1 > 64 goto Llabel0           // BPF_JGT  | BPF_K
+  if r2 >= 0xffffffff goto Llabel0  // BPF_JGE  | BPF_K
+  if r4 s> 0xffffffff goto Llabel0  // BPF_JSGT | BPF_K
+  if r5 s>= 0x7fffffff goto Llabel0 // BPF_JSGE | BPF_K
+// CHECK: 25 01 0b 00 40 00 00 00 	if r1 > 64 goto 11
+// CHECK: 35 02 0a 00 ff ff ff ff 	if r2 >= -1 goto 10
+// CHECK: 65 04 09 00 ff ff ff ff 	if r4 s> -1 goto 9
+// CHECK: 75 05 08 00 ff ff ff 7f 	if r5 s>= 2147483647 goto 8
+
+  if r6 < 0xff goto Llabel0         // BPF_JLT  | BPF_K
+  if r7 <= 0xffff goto Llabel0      // BPF_JLE  | BPF_K
+  if r8 s< 0 goto Llabel0           // BPF_JSLT | BPF_K
+  if r9 s<= -1 goto Llabel0         // BPF_JSLE | BPF_K
+// CHECK: a5 06 07 00 ff 00 00 00 	if r6 < 255 goto 7
+// CHECK: b5 07 06 00 ff ff 00 00 	if r7 <= 65535 goto 6
+// CHECK: c5 08 05 00 00 00 00 00 	if r8 s< 0 goto 5
+// CHECK: d5 09 04 00 ff ff ff ff 	if r9 s<= -1 goto 4
+
+// ======== BPF_ALU64 Class ========
+  r0 += r1    // BPF_ADD  | BPF_X
+  r1 -= r2    // BPF_SUB  | BPF_X
+  r2 *= r3    // BPF_MUL  | BPF_X
+  r3 /= r4    // BPF_DIV  | BPF_X
+// CHECK: 0f 10 00 00 00 00 00 00 	r0 += r1
+// CHECK: 1f 21 00 00 00 00 00 00 	r1 -= r2
+// CHECK: 2f 32 00 00 00 00 00 00 	r2 *= r3
+// CHECK: 3f 43 00 00 00 00 00 00 	r3 /= r4
+
+Llabel0 :
+  r4 |= r5    // BPF_OR   | BPF_X
+  r5 &= r6    // BPF_AND  | BPF_X
+  r6 <<= r7   // BPF_LSH  | BPF_X
+  r7 >>= r8   // BPF_RSH  | BPF_X
+  r8 ^= r9    // BPF_XOR  | BPF_X
+  r9 = r10    // BPF_MOV  | BPF_X
+  r10 s>>= r0 // BPF_ARSH | BPF_X
+// CHECK:Llabel0:
+// CHECK: 4f 54 00 00 00 00 00 00 	r4 |= r5
+// CHECK: 5f 65 00 00 00 00 00 00 	r5 &= r6
+// CHECK: 6f 76 00 00 00 00 00 00 	r6 <<= r7
+// CHECK: 7f 87 00 00 00 00 00 00 	r7 >>= r8
+// CHECK: af 98 00 00 00 00 00 00 	r8 ^= r9
+// CHECK: bf a9 00 00 00 00 00 00 	r9 = r10
+// CHECK: cf 0a 00 00 00 00 00 00 	r10 s>>= r0
+
+  bswap16 r1  // BPF_END  | BPF_TO_BE
+  bswap32 r2  // BPF_END  | BPF_TO_BE
+  bswap64 r3  // BPF_END  | BPF_TO_BE
+// CHECK: dc 01 00 00 10 00 00 00 	bswap16	r1
+// CHECK: dc 02 00 00 20 00 00 00 	bswap32	r2
+// CHECK: dc 03 00 00 40 00 00 00 	bswap64	r3
+
+  r0 += 1           // BPF_ADD  | BPF_K
+  r1 -= 0x1         // BPF_SUB  | BPF_K
+  r2 *= -4          // BPF_MUL  | BPF_K
+  r3 /= 5           // BPF_DIV  | BPF_K
+// CHECK: 07 00 00 00 01 00 00 00 	r0 += 1
+// CHECK: 17 01 00 00 01 00 00 00 	r1 -= 1
+// CHECK: 27 02 00 00 fc ff ff ff 	r2 *= -4
+// CHECK: 37 03 00 00 05 00 00 00 	r3 /= 5
+
+  r4 |= 0xff        // BPF_OR   | BPF_K
+  r5 &= 0xFF        // BPF_AND  | BPF_K
+  r6 <<= 63         // BPF_LSH  | BPF_K
+  r7 >>= 32         // BPF_RSH  | BPF_K
+  r8 ^= 0           // BPF_XOR  | BPF_K
+  r10 s>>= 64       // BPF_ARSH | BPF_K
+// CHECK: 47 04 00 00 ff 00 00 00 	r4 |= 255
+// CHECK: 57 05 00 00 ff 00 00 00 	r5 &= 255
+// CHECK: 67 06 00 00 3f 00 00 00 	r6 <<= 63
+// CHECK: 77 07 00 00 20 00 00 00 	r7 >>= 32
+// CHECK: a7 08 00 00 00 00 00 00 	r8 ^= 0
+// CHECK: c7 0a 00 00 40 00 00 00 	r10 s>>= 64
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


--------------4356372CAEAAD6F8A7D1BF4C--
