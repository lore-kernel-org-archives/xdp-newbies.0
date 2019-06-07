Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53243 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730270AbfFGRbv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 7 Jun 2019 13:31:51 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190607173150euoutp0149846c529884c9c453e3c6f9f744ab3f~l_uXH_Pmz1309113091euoutp01X
        for <xdp-newbies@vger.kernel.org>; Fri,  7 Jun 2019 17:31:50 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v2] xdp: fix hang while unregistering device bound to
 xdp socket
Date: Fri,  7 Jun 2019 20:31:43 +0300
Message-Id: <20190607173143.4919-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e@eucas1p1.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Ilya Maximets <i.maximets@samsung.com>

Device that bound to XDP socket will not have zero refcount until the
userspace application will not close it. This leads to hang inside
'netdev_wait_allrefs()' if device unregistering requested:

  # ip link del p1
  < hang on recvmsg on netlink socket >

  # ps -x | grep ip
  5126  pts/0    D+   0:00 ip link del p1

  # journalctl -b

  Jun 05 07:19:16 kernel:
  unregister_netdevice: waiting for p1 to become free. Usage count = 1

  Jun 05 07:19:27 kernel:
  unregister_netdevice: waiting for p1 to become free. Usage count = 1
  ...

Fix that by implementing NETDEV_UNREGISTER event notification handler
to properly clean up all the resources and unref device.

This should also allow socket killing via ss(8) utility.

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 net/xdp/xsk.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..3f3979579d21 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -693,6 +693,54 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 			       size, vma->vm_page_prot);
 }
 
+static int xsk_notifier(struct notifier_block *this,
+			unsigned long msg, void *ptr)
+{
+	struct sock *sk;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	int i, unregister_count = 0;
+
+	mutex_lock(&net->xdp.lock);
+	sk_for_each(sk, &net->xdp.list) {
+		struct xdp_sock *xs = xdp_sk(sk);
+
+		mutex_lock(&xs->mutex);
+		switch (msg) {
+		case NETDEV_UNREGISTER:
+			if (dev != xs->dev)
+				break;
+
+			sk->sk_err = ENETDOWN;
+			if (!sock_flag(sk, SOCK_DEAD))
+				sk->sk_error_report(sk);
+
+			/* Wait for driver to stop using the xdp socket. */
+			xdp_del_sk_umem(xs->umem, xs);
+			xs->dev = NULL;
+			synchronize_net();
+
+			/* Clear device references in umem. */
+			xdp_put_umem(xs->umem);
+			xs->umem = NULL;
+
+			unregister_count++;
+			break;
+		}
+		mutex_unlock(&xs->mutex);
+	}
+	mutex_unlock(&net->xdp.lock);
+
+	if (unregister_count) {
+		/* Wait for umem clearing completion. */
+		synchronize_net();
+		for (i = 0; i < unregister_count; i++)
+			dev_put(dev);
+	}
+
+	return NOTIFY_DONE;
+}
+
 static struct proto xsk_proto = {
 	.name =		"XDP",
 	.owner =	THIS_MODULE,
@@ -727,7 +775,8 @@ static void xsk_destruct(struct sock *sk)
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;
 
-	xdp_put_umem(xs->umem);
+	if (xs->umem)
+		xdp_put_umem(xs->umem);
 
 	sk_refcnt_debug_dec(sk);
 }
@@ -784,6 +833,10 @@ static const struct net_proto_family xsk_family_ops = {
 	.owner	= THIS_MODULE,
 };
 
+static struct notifier_block xsk_netdev_notifier = {
+	.notifier_call	= xsk_notifier,
+};
+
 static int __net_init xsk_net_init(struct net *net)
 {
 	mutex_init(&net->xdp.lock);
@@ -816,8 +869,15 @@ static int __init xsk_init(void)
 	err = register_pernet_subsys(&xsk_net_ops);
 	if (err)
 		goto out_sk;
+
+	err = register_netdevice_notifier(&xsk_netdev_notifier);
+	if (err)
+		goto out_pernet;
+
 	return 0;
 
+out_pernet:
+	unregister_pernet_subsys(&xsk_net_ops);
 out_sk:
 	sock_unregister(PF_XDP);
 out_proto:
-- 
2.17.1
