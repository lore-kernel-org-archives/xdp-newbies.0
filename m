Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53964 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbfGDOZN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jul 2019 10:25:13 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190704142511euoutp0260b6d36d107a7caf01b7ce92c893ba57~uOmGO3aYJ1485514855euoutp02k
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jul 2019 14:25:11 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] xdp: fix possible cq entry leak
Date: Thu,  4 Jul 2019 17:25:03 +0300
Message-Id: <20190704142503.23501-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

Completion queue address reservation could not be undone.
In case of bad 'queue_id' or skb allocation failure, reserved entry
will be leaked reducing the total capacity of completion queue.

Fix that by moving reservation to the point where failure is not
possible. Additionally, 'queue_id' checking moved out from the loop
since there is no point to check it there.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 net/xdp/xsk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f53a6ef7c155..703cf5ea448b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -226,6 +226,9 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 
 	mutex_lock(&xs->mutex);
 
+	if (xs->queue_id >= xs->dev->real_num_tx_queues)
+		goto out;
+
 	while (xskq_peek_desc(xs->tx, &desc)) {
 		char *buffer;
 		u64 addr;
@@ -236,12 +239,6 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 			goto out;
 		}
 
-		if (xskq_reserve_addr(xs->umem->cq))
-			goto out;
-
-		if (xs->queue_id >= xs->dev->real_num_tx_queues)
-			goto out;
-
 		len = desc.len;
 		skb = sock_alloc_send_skb(sk, len, 1, &err);
 		if (unlikely(!skb)) {
@@ -253,7 +250,7 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 		addr = desc.addr;
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-		if (unlikely(err)) {
+		if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
 			kfree_skb(skb);
 			goto out;
 		}
-- 
2.17.1
