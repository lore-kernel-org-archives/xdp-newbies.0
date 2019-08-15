Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38972 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731778AbfHOMOc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 15 Aug 2019 08:14:32 -0400
Received: by mail-lf1-f68.google.com with SMTP id x3so1501858lfn.6
        for <xdp-newbies@vger.kernel.org>; Thu, 15 Aug 2019 05:14:30 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next v2 3/3] samples: bpf: syscal_nrs: use mmap2 if defined
Date: Thu, 15 Aug 2019 15:13:56 +0300
Message-Id: <20190815121356.8848-4-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc: davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org, jlemon@flugsvamp.com, yhs@fb.com, andrii.nakryiko@gmail.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

For arm32 xdp sockets mmap2 is preferred, so use it if it's defined.
Declaration of __NR_mmap can be skipped and it breaks build.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/syscall_nrs.c  |  6 ++++++
 samples/bpf/tracex5_kern.c | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/samples/bpf/syscall_nrs.c b/samples/bpf/syscall_nrs.c
index 516e255cbe8f..88f940052450 100644
--- a/samples/bpf/syscall_nrs.c
+++ b/samples/bpf/syscall_nrs.c
@@ -9,5 +9,11 @@ void syscall_defines(void)
 	COMMENT("Linux system call numbers.");
 	SYSNR(__NR_write);
 	SYSNR(__NR_read);
+#ifdef __NR_mmap2
+	SYSNR(__NR_mmap2);
+#endif
+#ifdef __NR_mmap
 	SYSNR(__NR_mmap);
+#endif
+
 }
diff --git a/samples/bpf/tracex5_kern.c b/samples/bpf/tracex5_kern.c
index f57f4e1ea1ec..35cb0eed3be5 100644
--- a/samples/bpf/tracex5_kern.c
+++ b/samples/bpf/tracex5_kern.c
@@ -68,12 +68,25 @@ PROG(SYS__NR_read)(struct pt_regs *ctx)
 	return 0;
 }
 
+#ifdef __NR_mmap2
+PROG(SYS__NR_mmap2)(struct pt_regs *ctx)
+{
+	char fmt[] = "mmap2\n";
+
+	bpf_trace_printk(fmt, sizeof(fmt));
+	return 0;
+}
+#endif
+
+#ifdef __NR_mmap
 PROG(SYS__NR_mmap)(struct pt_regs *ctx)
 {
 	char fmt[] = "mmap\n";
+
 	bpf_trace_printk(fmt, sizeof(fmt));
 	return 0;
 }
+#endif
 
 char _license[] SEC("license") = "GPL";
 u32 _version SEC("version") = LINUX_VERSION_CODE;
-- 
2.17.1
