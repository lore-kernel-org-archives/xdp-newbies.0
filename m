Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:48944 "EHLO
        tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWK6X (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 May 2019 06:58:23 -0400
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Subject: [PATCH bpf-next 1/3] xdp: Add bulk XDP_TX queue
Date: Thu, 23 May 2019 19:56:46 +0900
Message-Id: <1558609008-2590-2-git-send-email-makita.toshiaki@lab.ntt.co.jp>
In-Reply-To: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

XDP_TX is similar to XDP_REDIRECT as it essentially redirects packets to
the device itself. XDP_REDIRECT has bulk transmit mechanism to avoid the
heavy cost of indirect call but it also reduces lock acquisition on the
destination device that needs locks like veth and tun.

XDP_TX does not use indirect calls but drivers which require locks can
benefit from the bulk transmit for XDP_TX as well.

This patch adds per-cpu queues which can be used for bulk transmit on
XDP_TX. I did not add functions like enqueue/flush but exposed the queue
directly because we should avoid indirect calls on XDP_TX.

Note that the queue must be flushed, i.e. "count" member needs to be
set to 0, when a NAPI handler which used this queue exits. Otherwise
packets left in the queue will be transmitted from totally unintentional
devices.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
---
 include/net/xdp.h | 7 +++++++
 net/core/xdp.c    | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 0f25b36..30b36c8 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -84,6 +84,13 @@ struct xdp_frame {
 	struct net_device *dev_rx; /* used by cpumap */
 };
 
+#define XDP_TX_BULK_SIZE	16
+struct xdp_tx_bulk_queue {
+	struct xdp_frame *q[XDP_TX_BULK_SIZE];
+	unsigned int count;
+};
+DECLARE_PER_CPU(struct xdp_tx_bulk_queue, xdp_tx_bq);
+
 /* Clear kernel pointers in xdp_frame */
 static inline void xdp_scrub_frame(struct xdp_frame *frame)
 {
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4b2b194..0622f2d 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -40,6 +40,9 @@ struct xdp_mem_allocator {
 	struct rcu_head rcu;
 };
 
+DEFINE_PER_CPU(struct xdp_tx_bulk_queue, xdp_tx_bq);
+EXPORT_PER_CPU_SYMBOL_GPL(xdp_tx_bq);
+
 static u32 xdp_mem_id_hashfn(const void *data, u32 len, u32 seed)
 {
 	const u32 *k = data;
-- 
1.8.3.1
