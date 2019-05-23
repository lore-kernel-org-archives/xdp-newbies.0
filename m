Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35441 "EHLO
        tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWK6j (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 May 2019 06:58:39 -0400
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Subject: [PATCH bpf-next 2/3] xdp: Add tracepoint for bulk XDP_TX
Date: Thu, 23 May 2019 19:56:47 +0900
Message-Id: <1558609008-2590-3-git-send-email-makita.toshiaki@lab.ntt.co.jp>
In-Reply-To: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

This is introduced for admins to check what is happening on XDP_TX when
bulk XDP_TX is in use.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
---
 include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 2 files changed, 26 insertions(+)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index e95cb86..e06ea65 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -50,6 +50,31 @@
 		  __entry->ifindex)
 );
 
+TRACE_EVENT(xdp_bulk_tx,
+
+	TP_PROTO(const struct net_device *dev,
+		 int sent, int drops, int err),
+
+	TP_ARGS(dev, sent, drops, err),
+
+	TP_STRUCT__entry(
+		__field(int, ifindex)
+		__field(int, drops)
+		__field(int, sent)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__entry->ifindex	= dev->ifindex;
+		__entry->drops		= drops;
+		__entry->sent		= sent;
+		__entry->err		= err;
+	),
+
+	TP_printk("ifindex=%d sent=%d drops=%d err=%d",
+		  __entry->ifindex, __entry->sent, __entry->drops, __entry->err)
+);
+
 DECLARE_EVENT_CLASS(xdp_redirect_template,
 
 	TP_PROTO(const struct net_device *dev,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 242a643..7687488 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2108,3 +2108,4 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 #include <linux/bpf_trace.h>
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_exception);
+EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_bulk_tx);
-- 
1.8.3.1
