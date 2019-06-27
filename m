Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39319 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfF0KPl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 27 Jun 2019 06:15:41 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190627101539euoutp017ff449189154c319067b69496fa74f00~sBrPBbVXY0553905539euoutp01-
        for <xdp-newbies@vger.kernel.org>; Thu, 27 Jun 2019 10:15:39 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v5 1/2] xdp: hold device for umem regardless of
 zero-copy mode
Date: Thu, 27 Jun 2019 13:15:28 +0300
Message-Id: <20190627101529.11234-2-i.maximets@samsung.com>
In-Reply-To: <20190627101529.11234-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20190627101529.11234-1-i.maximets@samsung.com>
        <CGME20190627101538eucas1p23924bd4173eb4b7b59c624b588ecb787@eucas1p2.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

Device pointer stored in umem regardless of zero-copy mode,
so we heed to hold the device in all cases.

Fixes: c9b47cc1fabc ("xsk: fix bug when trying to use both copy and zero-copy on one queue id")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 net/xdp/xdp_umem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9c6de4f114f8..267b82a4cbcf 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -105,6 +105,9 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 
 	umem->dev = dev;
 	umem->queue_id = queue_id;
+
+	dev_hold(dev);
+
 	if (force_copy)
 		/* For copy-mode, we are done. */
 		goto out_rtnl_unlock;
@@ -124,7 +127,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 		goto err_unreg_umem;
 	rtnl_unlock();
 
-	dev_hold(dev);
 	umem->zc = true;
 	return 0;
 
@@ -163,10 +165,9 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
 	rtnl_unlock();
 
-	if (umem->zc) {
-		dev_put(umem->dev);
-		umem->zc = false;
-	}
+	dev_put(umem->dev);
+	umem->dev = NULL;
+	umem->zc = false;
 }
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
-- 
2.17.1
