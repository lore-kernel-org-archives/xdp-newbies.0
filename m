Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388035AbfBMCfd (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 12 Feb 2019 21:35:33 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 074/105] samples/bpf: workaround clang asm goto compilation errors
Date: Tue, 12 Feb 2019 21:33:05 -0500
Message-Id: <20190213023336.19019-74-sashal@kernel.org>
In-Reply-To: <20190213023336.19019-1-sashal@kernel.org>
References: <20190213023336.19019-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 6bf3bbe1f4d4cf405e3c2bf07bbdff56d3223ec8 ]

x86 compilation has required asm goto support since 4.17.
Since clang does not support asm goto, at 4.17,
Commit b1ae32dbab50 ("x86/cpufeature: Guard asm_volatile_goto usage
for BPF compilation") worked around the issue by permitting an
alternative implementation without asm goto for clang.

At 5.0, more asm goto usages appeared.
  [yhs@148 x86]$ egrep -r asm_volatile_goto
  include/asm/cpufeature.h:     asm_volatile_goto("1: jmp 6f\n"
  include/asm/jump_label.h:     asm_volatile_goto("1:"
  include/asm/jump_label.h:     asm_volatile_goto("1:"
  include/asm/rmwcc.h:  asm_volatile_goto (fullop "; j" #cc " %l[cc_label]"     \
  include/asm/uaccess.h:        asm_volatile_goto("\n"                          \
  include/asm/uaccess.h:        asm_volatile_goto("\n"                          \
  [yhs@148 x86]$

Compiling samples/bpf directories, most bpf programs failed
compilation with error messages like:
  In file included from /home/yhs/work/bpf-next/samples/bpf/xdp_sample_pkts_kern.c:2:
  In file included from /home/yhs/work/bpf-next/include/linux/ptrace.h:6:
  In file included from /home/yhs/work/bpf-next/include/linux/sched.h:15:
  In file included from /home/yhs/work/bpf-next/include/linux/sem.h:5:
  In file included from /home/yhs/work/bpf-next/include/uapi/linux/sem.h:5:
  In file included from /home/yhs/work/bpf-next/include/linux/ipc.h:9:
  In file included from /home/yhs/work/bpf-next/include/linux/refcount.h:72:
  /home/yhs/work/bpf-next/arch/x86/include/asm/refcount.h:70:9: error: 'asm goto' constructs are not supported yet
        return GEN_BINARY_SUFFIXED_RMWcc(LOCK_PREFIX "subl",
               ^
  /home/yhs/work/bpf-next/arch/x86/include/asm/rmwcc.h:67:2: note: expanded from macro 'GEN_BINARY_SUFFIXED_RMWcc'
        __GEN_RMWcc(op " %[val], %[var]\n\t" suffix, var, cc,           \
        ^
  /home/yhs/work/bpf-next/arch/x86/include/asm/rmwcc.h:21:2: note: expanded from macro '__GEN_RMWcc'
        asm_volatile_goto (fullop "; j" #cc " %l[cc_label]"             \
        ^
  /home/yhs/work/bpf-next/include/linux/compiler_types.h:188:37: note: expanded from macro 'asm_volatile_goto'
  #define asm_volatile_goto(x...) asm goto(x)

Most implementation does not even provide an alternative
implementation. And it is also not practical to make changes
for each call site.

This patch workarounded the asm goto issue by redefining the macro like below:
  #define asm_volatile_goto(x...) asm volatile("invalid use of asm_volatile_goto")

If asm_volatile_goto is not used by bpf programs, which is typically the case, nothing bad
will happen. If asm_volatile_goto is used by bpf programs, which is incorrect, the compiler
will issue an error since "invalid use of asm_volatile_goto" is not valid assembly codes.

With this patch, all bpf programs under samples/bpf can pass compilation.

Note that bpf programs under tools/testing/selftests/bpf/ compiled fine as
they do not access kernel internal headers.

Fixes: e769742d3584 ("Revert "x86/jump-labels: Macrofy inline assembly code to work around GCC inlining bugs"")
Fixes: 18fe58229d80 ("x86, asm: change the GEN_*_RMWcc() macros to not quote the condition")
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile              |  1 +
 samples/bpf/asm_goto_workaround.h | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)
 create mode 100644 samples/bpf/asm_goto_workaround.h

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index be0a961450bc..f5ce993c78e4 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -273,6 +273,7 @@ $(obj)/%.o: $(src)/%.c
 		-Wno-gnu-variable-sized-type-not-at-end \
 		-Wno-address-of-packed-member -Wno-tautological-compare \
 		-Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
+		-I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
 		-O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
 ifeq ($(DWARF2BTF),y)
 	$(BTF_PAHOLE) -J $@
diff --git a/samples/bpf/asm_goto_workaround.h b/samples/bpf/asm_goto_workaround.h
new file mode 100644
index 000000000000..5cd7c1d1a5d5
--- /dev/null
+++ b/samples/bpf/asm_goto_workaround.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019 Facebook */
+#ifndef __ASM_GOTO_WORKAROUND_H
+#define __ASM_GOTO_WORKAROUND_H
+
+/* this will bring in asm_volatile_goto macro definition
+ * if enabled by compiler and config options.
+ */
+#include <linux/types.h>
+
+#ifdef asm_volatile_goto
+#undef asm_volatile_goto
+#define asm_volatile_goto(x...) asm volatile("invalid use of asm_volatile_goto")
+#endif
+
+#endif
-- 
2.19.1
