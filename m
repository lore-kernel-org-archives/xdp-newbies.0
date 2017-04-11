Return-path: <xdp-newbies-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57202 "EHLO
 youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with
 ESMTP id S1752286AbdDKDfX (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
 Mon, 10 Apr 2017 23:35:23 -0400
From: Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH] Enable Netdev XDP tutorial for Ubuntu 17.04
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20601.1491881713.1@famine>
Date: Mon, 10 Apr 2017 20:35:13 -0700
Message-ID: <20602.1491881713@famine>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: xdp-newbies@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Andy Gospodarek <andy@greyhouse.net>

	This patch resolves build issues when compiling the samples on
Ubuntu 17.04 with the distro 4.10 kernel and the linux-headers package
installed.  This permits running the samples using distro packages
without needing to rebuild the kernel from source.

	Tested on a 17.04 VM using virtio_net.

Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---

	I haven't tried the patched version of this on a built from
source kernel yet, so it might break that.

 kernel/samples/bpf/Makefile                       | 18 ++++--------------
 kernel/samples/bpf/libbpf.h                       |  2 +-
 kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c |  3 +--
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/kernel/samples/bpf/Makefile b/kernel/samples/bpf/Makefile
index 2aa4f73a6bba..7d77e53d6cd8 100644
--- a/kernel/samples/bpf/Makefile
+++ b/kernel/samples/bpf/Makefile
@@ -49,17 +49,7 @@ KERNEL=$(kbuilddir)
 CFLAGS := -O2 -Wall
 
 # Local copy of kernel/tools/lib/
-CFLAGS += -I./tools/lib
-#CFLAGS += -I$(KERNEL)/tools/lib
-#
-# Local copy of uapi/linux/bpf.h kept under ./tools/include
-# needed due to enum dependency in bpf_helpers.h
-CFLAGS += -I./tools/include
-CFLAGS += -I$(KERNEL)/tools/include
-#CFLAGS += -I$(KERNEL)/tools/perf
-CFLAGS += -I$(KERNEL)/usr/include
-# Strange dependency to "selftests" due to "bpf_util.h"
-#CFLAGS += -I$(KERNEL)/tools/testing/selftests/bpf/
+USER_CFLAGS := $(CFLAGS) -I./tools/lib
 
 LDFLAGS= -lelf
 
@@ -151,7 +141,7 @@ $(OBJECT_LIBBPF): %.o: %.c
 	$(CC) $(CFLAGS) -o $@ -c $<
 
 $(OBJECT_LOADBPF): bpf_load.c
-	$(CC) $(CFLAGS) -o $@ -c $<
+	$(CC) $(USER_CFLAGS) -o $@ -c $<
 
 # Compiling of eBPF restricted-C code with LLVM
 #  clang option -S generated output file with suffix .ll
@@ -168,7 +158,7 @@ $(KERN_OBJECTS): %.o: %.c
 	$(LLC) -march=bpf -filetype=obj -o $@ ${@:.o=.ll}
 
 $(TARGETS): %: %_user.c $(OBJECTS) Makefile
-	$(CC) $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
+	$(CC) $(USER_CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
 
 $(CMDLINE_TOOLS): %: %.c $(OBJECTS) Makefile $(COMMON_H)
-	$(CC) -g $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
+	$(CC) -g $(USER_CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<
diff --git a/kernel/samples/bpf/libbpf.h b/kernel/samples/bpf/libbpf.h
index 1a3c7a06f4c3..b572a0517498 100644
--- a/kernel/samples/bpf/libbpf.h
+++ b/kernel/samples/bpf/libbpf.h
@@ -9,7 +9,7 @@
  * construct of -I$(KERNEL)/tools/lib/ this include find
  * tools/lib/bpf/bpf.h which defines the userspace API
  */
-#include <bpf/bpf.h>
+#include "bpf/bpf.h"
 
 struct bpf_insn;
 
diff --git a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
index 11157f94b062..5cf297ee2664 100644
--- a/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
+++ b/kernel/samples/bpf/xdp_ddos01_blacklist_cmdline.c
@@ -13,7 +13,6 @@ static const char *__doc__=
 #include <string.h>
 #include <unistd.h>
 #include <locale.h>
-#include <linux/bitops.h>
 
 #include <sys/resource.h>
 #include <getopt.h>
@@ -212,7 +211,7 @@ static void blacklist_print_proto(int key, __u64 count)
 	printf("\n\t\"%s\" : %llu", xdp_proto_filter_names[key], count);
 }
 
-static void blacklist_print_port(int key, u32 val, int countfds[])
+static void blacklist_print_port(int key, __u32 val, int countfds[])
 {
 	int i;
 	__u64 count;
-- 
2.7.4
