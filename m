Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:45529 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdIRUsG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Sep 2017 16:48:06 -0400
Received: by mail-wm0-f42.google.com with SMTP id g206so171271wme.0
        for <xdp-newbies@vger.kernel.org>; Mon, 18 Sep 2017 13:48:06 -0700 (PDT)
From: Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH RFC 3/4] New 32-bit register set
Date: Mon, 18 Sep 2017 16:47:20 -0400
Message-Id: <1505767641-40512-4-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>

This patch introduce the new "w*" 32-bit register set and alias them to the low
32-bit of the corresponding 64-bit register.

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 lib/Target/BPF/BPFRegisterInfo.td | 74 ++++++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 21 deletions(-)

diff --git a/lib/Target/BPF/BPFRegisterInfo.td b/lib/Target/BPF/BPFRegisterInfo.td
index c8e24f8..a5722fe 100644
--- a/lib/Target/BPF/BPFRegisterInfo.td
+++ b/lib/Target/BPF/BPFRegisterInfo.td
@@ -11,31 +11,63 @@
 //  Declarations that describe the BPF register file
 //===----------------------------------------------------------------------===//
 
+let Namespace = "BPF" in {
+  def sub_32 : SubRegIndex<32>;
+}
+
+class Wi<bits<16> Enc, string n> : Register<n> {
+  let HWEncoding = Enc;
+  let Namespace = "BPF";
+}
+
 // Registers are identified with 4-bit ID numbers.
 // Ri - 64-bit integer registers
-class Ri<bits<16> Enc, string n> : Register<n> {
-  let Namespace = "BPF";
+class Ri<bits<16> Enc, string n, list<Register> subregs>
+  : RegisterWithSubRegs<n, subregs> {
   let HWEncoding = Enc;
+  let Namespace = "BPF";
+  let SubRegIndices = [sub_32];
 }
 
-// Integer registers
-def R0 : Ri< 0, "r0">, DwarfRegNum<[0]>;
-def R1 : Ri< 1, "r1">, DwarfRegNum<[1]>;
-def R2 : Ri< 2, "r2">, DwarfRegNum<[2]>;
-def R3 : Ri< 3, "r3">, DwarfRegNum<[3]>;
-def R4 : Ri< 4, "r4">, DwarfRegNum<[4]>;
-def R5 : Ri< 5, "r5">, DwarfRegNum<[5]>;
-def R6 : Ri< 6, "r6">, DwarfRegNum<[6]>;
-def R7 : Ri< 7, "r7">, DwarfRegNum<[7]>;
-def R8 : Ri< 8, "r8">, DwarfRegNum<[8]>;
-def R9 : Ri< 9, "r9">, DwarfRegNum<[9]>;
-def R10 : Ri<10, "r10">, DwarfRegNum<[10]>;
-def R11 : Ri<11, "r11">, DwarfRegNum<[11]>;
+// 32-bit Integer registers which alias to low part of 64-bit one.
+def W0  : Wi<0,  "w0">,  DwarfRegNum<[0]>;
+def W1  : Wi<1,  "w1">,  DwarfRegNum<[1]>;
+def W2  : Wi<2,  "w2">,  DwarfRegNum<[2]>;
+def W3  : Wi<3,  "w3">,  DwarfRegNum<[3]>;
+def W4  : Wi<4,  "w4">,  DwarfRegNum<[4]>;
+def W5  : Wi<5,  "w5">,  DwarfRegNum<[5]>;
+def W6  : Wi<6,  "w6">,  DwarfRegNum<[6]>;
+def W7  : Wi<7,  "w7">,  DwarfRegNum<[7]>;
+def W8  : Wi<8,  "w8">,  DwarfRegNum<[8]>;
+def W9  : Wi<9,  "w9">,  DwarfRegNum<[9]>;
+def W10 : Wi<10, "w10">, DwarfRegNum<[10]>;
+def W11 : Wi<11, "w11">, DwarfRegNum<[11]>;
+
+// 64-bit Integer registers
+def R0  : Ri<0,  "r0",  [W0]>,  DwarfRegNum<[0]>;
+def R1  : Ri<1,  "r1",  [W1]>,  DwarfRegNum<[1]>;
+def R2  : Ri<2,  "r2",  [W2]>,  DwarfRegNum<[2]>;
+def R3  : Ri<3,  "r3",  [W3]>,  DwarfRegNum<[3]>;
+def R4  : Ri<4,  "r4",  [W4]>,  DwarfRegNum<[4]>;
+def R5  : Ri<5,  "r5",  [W5]>,  DwarfRegNum<[5]>;
+def R6  : Ri<6,  "r6",  [W6]>,  DwarfRegNum<[6]>;
+def R7  : Ri<7,  "r7",  [W7]>,  DwarfRegNum<[7]>;
+def R8  : Ri<8,  "r8",  [W8]>,  DwarfRegNum<[8]>;
+def R9  : Ri<9,  "r9",  [W9]>,  DwarfRegNum<[9]>;
+def R10 : Ri<10, "r10", [W10]>, DwarfRegNum<[10]>;
+def R11 : Ri<11, "r11", [W11]>, DwarfRegNum<[11]>;
 
 // Register classes.
-def GPR : RegisterClass<"BPF", [i64], 64, (add R1, R2, R3, R4, R5,
-                                           R6, R7, R8, R9, // callee saved
-                                           R0,  // return value
-                                           R11, // stack ptr
-                                           R10  // frame ptr
-                                          )>;
+def GPR32 : RegisterClass<"BPF", [i32], 32, (add
+  (sequence "W%u", 1, 9), // Callee saved
+  W0, // Return value
+  W11, // Stack Ptr
+  W10  // Frame Ptr
+)>;
+
+def GPR : RegisterClass<"BPF", [i64], 64, (add
+  (sequence "R%u", 1, 9), // Callee saved
+  R0, // Return value
+  R11, // Stack Ptr
+  R10  // Frame Ptr
+)>;
-- 
2.7.4
