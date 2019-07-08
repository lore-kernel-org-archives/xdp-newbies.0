Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46220 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbfGHLDx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 07:03:53 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190708110352euoutp01417900eff1792b919bccbd8e0166152e~vabdflDrw1172311723euoutp01k
        for <xdp-newbies@vger.kernel.org>; Mon,  8 Jul 2019 11:03:52 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] xdp: fix potential deadlock on socket mutex
Date: Mon,  8 Jul 2019 14:03:44 +0300
Message-Id: <20190708110344.23278-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190708110350eucas1p16357da1f812ff8309b1edc98d4cdacc1@eucas1p1.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

There are 2 call chains:

  a) xsk_bind --> xdp_umem_assign_dev
  b) unregister_netdevice_queue --> xsk_notifier

with the following locking order:

  a) xs->mutex --> rtnl_lock
  b) rtnl_lock --> xdp.lock --> xs->mutex

Different order of taking 'xs->mutex' and 'rtnl_lock' could produce a
deadlock here. Fix that by moving the 'rtnl_lock' before 'xs->lock' in
the bind call chain (a).

Reported-by: syzbot+bf64ec93de836d7f4c2c@syzkaller.appspotmail.com
Fixes: 455302d1c9ae ("xdp: fix hang while unregistering device bound to xdp socket")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---

This patch is a fix for patch that is not yet in mainline, but
already in 'net' tree. I'm not sure what is the correct process
for applying such fixes.

 net/xdp/xdp_umem.c | 16 ++++++----------
 net/xdp/xsk.c      |  2 ++
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 20c91f02d3d8..83de74ca729a 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -87,21 +87,20 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	struct netdev_bpf bpf;
 	int err = 0;
 
+	ASSERT_RTNL();
+
 	force_zc = flags & XDP_ZEROCOPY;
 	force_copy = flags & XDP_COPY;
 
 	if (force_zc && force_copy)
 		return -EINVAL;
 
-	rtnl_lock();
-	if (xdp_get_umem_from_qid(dev, queue_id)) {
-		err = -EBUSY;
-		goto out_rtnl_unlock;
-	}
+	if (xdp_get_umem_from_qid(dev, queue_id))
+		return -EBUSY;
 
 	err = xdp_reg_umem_at_qid(dev, umem, queue_id);
 	if (err)
-		goto out_rtnl_unlock;
+		return err;
 
 	umem->dev = dev;
 	umem->queue_id = queue_id;
@@ -110,7 +109,7 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 
 	if (force_copy)
 		/* For copy-mode, we are done. */
-		goto out_rtnl_unlock;
+		return 0;
 
 	if (!dev->netdev_ops->ndo_bpf ||
 	    !dev->netdev_ops->ndo_xsk_async_xmit) {
@@ -125,7 +124,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	err = dev->netdev_ops->ndo_bpf(dev, &bpf);
 	if (err)
 		goto err_unreg_umem;
-	rtnl_unlock();
 
 	umem->zc = true;
 	return 0;
@@ -135,8 +133,6 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 		err = 0; /* fallback to copy mode */
 	if (err)
 		xdp_clear_umem_at_qid(dev, queue_id);
-out_rtnl_unlock:
-	rtnl_unlock();
 	return err;
 }
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 703cf5ea448b..2aa6072a3e55 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -416,6 +416,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY))
 		return -EINVAL;
 
+	rtnl_lock();
 	mutex_lock(&xs->mutex);
 	if (xs->state != XSK_READY) {
 		err = -EBUSY;
@@ -501,6 +502,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		xs->state = XSK_BOUND;
 out_release:
 	mutex_unlock(&xs->mutex);
+	rtnl_unlock();
 	return err;
 }
 
-- 
2.17.1
