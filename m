Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbfHGMgW (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 7 Aug 2019 08:36:22 -0400
Subject: [bpf-next PATCH 1/3] samples/bpf: xdp_fwd rename devmap name to be
 xdp_tx_ports
From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 07 Aug 2019 14:36:18 +0200
Message-ID: <156518137803.5636.11766023213864836956.stgit@firesoul>
In-Reply-To: <156518133219.5636.728822418668658886.stgit@firesoul>
References: <156518133219.5636.728822418668658886.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com, dsahern@gmail.com, Jesper Dangaard Brouer <brouer@redhat.com>

The devmap name 'tx_port' came from a copy-paste from xdp_redirect_map
which only have a single TX port. Change name to xdp_tx_ports
to make it more descriptive.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp_fwd_kern.c |    5 +++--
 samples/bpf/xdp_fwd_user.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index a7e94e7ff87d..e6ffc4ea06f4 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -23,7 +23,8 @@
 
 #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
 
-struct bpf_map_def SEC("maps") tx_port = {
+/* For TX-traffic redirect requires net_device ifindex to be in this devmap */
+struct bpf_map_def SEC("maps") xdp_tx_ports = {
 	.type = BPF_MAP_TYPE_DEVMAP,
 	.key_size = sizeof(int),
 	.value_size = sizeof(int),
@@ -117,7 +118,7 @@ static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
 
 		memcpy(eth->h_dest, fib_params.dmac, ETH_ALEN);
 		memcpy(eth->h_source, fib_params.smac, ETH_ALEN);
-		return bpf_redirect_map(&tx_port, fib_params.ifindex, 0);
+		return bpf_redirect_map(&xdp_tx_ports, fib_params.ifindex, 0);
 	}
 
 	return XDP_PASS;
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index 5b46ee12c696..ba012d9f93dd 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -113,7 +113,7 @@ int main(int argc, char **argv)
 			return 1;
 		}
 		map_fd = bpf_map__fd(bpf_object__find_map_by_name(obj,
-								  "tx_port"));
+							"xdp_tx_ports"));
 		if (map_fd < 0) {
 			printf("map not found: %s\n", strerror(map_fd));
 			return 1;
