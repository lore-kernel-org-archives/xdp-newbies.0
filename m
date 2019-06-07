Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42843 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730188AbfFGR1l (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 7 Jun 2019 13:27:41 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190607172739euoutp02d42b165a2c1fcd7fe3575403a54e793d~l_qthHUzC1359213592euoutp026
        for <xdp-newbies@vger.kernel.org>; Fri,  7 Jun 2019 17:27:39 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] xdp: check device pointer before clearing
Date: Fri,  7 Jun 2019 20:27:32 +0300
Message-Id: <20190607172732.4710-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190607172737eucas1p28508d5e198907695bc77f9fd18ce233e@eucas1p2.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Ilya Maximets <i.maximets@samsung.com>

We should not call 'ndo_bpf()' or 'dev_put()' with NULL argument.

Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---

I'm not sure if this fixes any real NULL pointer dereference, but code
is not consistent anyway and should be fixed.

 net/xdp/xdp_umem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 2b18223e7eb8..9c6de4f114f8 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -143,6 +143,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 	struct netdev_bpf bpf;
 	int err;
 
+	if (!umem->dev)
+		return;
+
 	if (umem->zc) {
 		bpf.command = XDP_SETUP_XSK_UMEM;
 		bpf.xsk.umem = NULL;
@@ -156,11 +159,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 			WARN(1, "failed to disable umem!\n");
 	}
 
-	if (umem->dev) {
-		rtnl_lock();
-		xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
-		rtnl_unlock();
-	}
+	rtnl_lock();
+	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
+	rtnl_unlock();
 
 	if (umem->zc) {
 		dev_put(umem->dev);
-- 
2.17.1
