Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48785 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfGBOgn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 2 Jul 2019 10:36:43 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190702143641euoutp02a668241473ec02c9e112edf10928d958~tndkYMvks3036530365euoutp02G
        for <xdp-newbies@vger.kernel.org>; Tue,  2 Jul 2019 14:36:41 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] xdp: fix race on generic receive path
Date: Tue,  2 Jul 2019 17:36:34 +0300
Message-Id: <20190702143634.19688-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

Unlike driver mode, generic xdp receive could be triggered
by different threads on different CPU cores at the same time
leading to the fill and rx queue breakage. For example, this
could happen while sending packets from two processes to the
first interface of veth pair while the second part of it is
open with AF_XDP socket.

Need to take a lock for each generic receive to avoid race.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 include/net/xdp_sock.h |  2 ++
 net/xdp/xsk.c          | 32 +++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d60f8a..ac3c047d058c 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -67,6 +67,8 @@ struct xdp_sock {
 	 * in the SKB destructor callback.
 	 */
 	spinlock_t tx_completion_lock;
+	/* Protects generic receive. */
+	spinlock_t rx_lock;
 	u64 rx_dropped;
 };
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..19f41d2b670c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 {
 	u32 metalen = xdp->data - xdp->data_meta;
 	u32 len = xdp->data_end - xdp->data;
+	unsigned long flags;
 	void *buffer;
 	u64 addr;
 	int err;
 
-	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
-		return -EINVAL;
+	spin_lock_irqsave(&xs->rx_lock, flags);
+
+	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 
 	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
 	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
-		xs->rx_dropped++;
-		return -ENOSPC;
+		err = -ENOSPC;
+		goto out_drop;
 	}
 
 	addr += xs->umem->headroom;
@@ -138,13 +143,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	memcpy(buffer, xdp->data_meta, len + metalen);
 	addr += metalen;
 	err = xskq_produce_batch_desc(xs->rx, addr, len);
-	if (!err) {
-		xskq_discard_addr(xs->umem->fq);
-		xsk_flush(xs);
-		return 0;
-	}
+	if (err)
+		goto out_drop;
+
+	xskq_discard_addr(xs->umem->fq);
+	xskq_produce_flush_desc(xs->rx);
 
+	spin_unlock_irqrestore(&xs->rx_lock, flags);
+
+	xs->sk.sk_data_ready(&xs->sk);
+	return 0;
+
+out_drop:
 	xs->rx_dropped++;
+out_unlock:
+	spin_unlock_irqrestore(&xs->rx_lock, flags);
 	return err;
 }
 
@@ -765,6 +778,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 
 	xs = xdp_sk(sk);
 	mutex_init(&xs->mutex);
+	spin_lock_init(&xs->rx_lock);
 	spin_lock_init(&xs->tx_completion_lock);
 
 	mutex_lock(&net->xdp.lock);
-- 
2.17.1
