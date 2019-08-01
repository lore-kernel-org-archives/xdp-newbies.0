Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13799 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfHASAZ (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 1 Aug 2019 14:00:25 -0400
Subject: [net v1 PATCH 2/4] selftests/bpf: add wrapper scripts for
 test_xdp_vlan.sh
From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 01 Aug 2019 20:00:21 +0200
Message-ID: <156468242168.27559.5291011507782758991.stgit@firesoul>
In-Reply-To: <156468229108.27559.2443904494495785131.stgit@firesoul>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: xdp-newbies@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, brandon.cazander@multapplied.net, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>

In-order to test both native-XDP (xdpdrv) and generic-XDP (xdpgeneric)
create two wrapper test scripts, that start the test_xdp_vlan.sh script
with these modes.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/Makefile               |    3 ++-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |    5 ++++-
 .../selftests/bpf/test_xdp_vlan_mode_generic.sh    |    9 +++++++++
 .../selftests/bpf/test_xdp_vlan_mode_native.sh     |    9 +++++++++
 4 files changed, 24 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3bd0f4a0336a..29001f944db7 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -57,7 +57,8 @@ TEST_PROGS := test_kmod.sh \
 	test_lirc_mode2.sh \
 	test_skb_cgroup_id.sh \
 	test_flow_dissector.sh \
-	test_xdp_vlan.sh \
+	test_xdp_vlan_mode_generic.sh \
+	test_xdp_vlan_mode_native.sh \
 	test_lwt_ip_encap.sh \
 	test_tcp_check_syncookie.sh \
 	test_tc_tunnel.sh \
diff --git a/tools/testing/selftests/bpf/test_xdp_vlan.sh b/tools/testing/selftests/bpf/test_xdp_vlan.sh
index c8aed63b0ffe..7348661be815 100755
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -2,7 +2,10 @@
 # SPDX-License-Identifier: GPL-2.0
 # Author: Jesper Dangaard Brouer <hawk@kernel.org>
 
-TESTNAME=xdp_vlan
+# Allow wrapper scripts to name test
+if [ -z "$TESTNAME" ]; then
+    TESTNAME=xdp_vlan
+fi
 
 # Default XDP mode
 XDP_MODE=xdpgeneric
diff --git a/tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh b/tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
new file mode 100755
index 000000000000..c515326d6d59
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Exit on failure
+set -e
+
+# Wrapper script to test generic-XDP
+export TESTNAME=xdp_vlan_mode_generic
+./test_xdp_vlan.sh --mode=xdpgeneric
diff --git a/tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh b/tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh
new file mode 100755
index 000000000000..5cf7ce1f16c1
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh
@@ -0,0 +1,9 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Exit on failure
+set -e
+
+# Wrapper script to test native-XDP
+export TESTNAME=xdp_vlan_mode_native
+./test_xdp_vlan.sh --mode=xdpdrv
