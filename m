Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42234 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfFEFgt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 5 Jun 2019 01:36:49 -0400
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: [PATCH v2 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
Date: Wed,  5 Jun 2019 14:36:12 +0900
Message-Id: <20190605053613.22888-2-toshiaki.makita1@gmail.com>
In-Reply-To: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>, Jason Wang <jasowang@redhat.com>

This is introduced for admins to check what is happening on XDP_TX when
bulk XDP_TX is in use, which will be first introduced in veth in next
commit.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
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
index 33fb292..3a3f4af 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2106,3 +2106,4 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 #include <linux/bpf_trace.h>
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_exception);
+EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_bulk_tx);
-- 
1.8.3.1
