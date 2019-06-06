Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53564 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfFFMkX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 6 Jun 2019 08:40:23 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190606124022euoutp02ac10d667b3efb43aac9320d33d37cd38~lnGlUIT3I2143021430euoutp02C
        for <xdp-newbies@vger.kernel.org>; Thu,  6 Jun 2019 12:40:22 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH] net: Fix hang while unregistering device bound to xdp
 socket
Date: Thu,  6 Jun 2019 15:40:14 +0300
Message-Id: <20190606124014.23231-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190606124020eucas1p2007396ae8f23a426a17e0e5481636187@eucas1p2.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Ilya Maximets <i.maximets@samsung.com>

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

Fix that by counting XDP references for the device and failing
RTM_DELLINK with EBUSY if device is still in use by any XDP socket.

With this change:

  # ip link del p1
  RTNETLINK answers: Device or resource busy

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---

Another option could be to force closing all the corresponding AF_XDP
sockets, but I didn't figure out how to do this properly yet.

 include/linux/netdevice.h | 25 +++++++++++++++++++++++++
 net/core/dev.c            | 10 ++++++++++
 net/core/rtnetlink.c      |  6 ++++++
 net/xdp/xsk.c             |  7 ++++++-
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..24451cfc5590 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1705,6 +1705,7 @@ enum netdev_priv_flags {
  *	@watchdog_timer:	List of timers
  *
  *	@pcpu_refcnt:		Number of references to this device
+ *	@pcpu_xdp_refcnt:	Number of XDP socket references to this device
  *	@todo_list:		Delayed register/unregister
  *	@link_watch_list:	XXX: need comments on this one
  *
@@ -1966,6 +1967,7 @@ struct net_device {
 	struct timer_list	watchdog_timer;
 
 	int __percpu		*pcpu_refcnt;
+	int __percpu		*pcpu_xdp_refcnt;
 	struct list_head	todo_list;
 
 	struct list_head	link_watch_list;
@@ -2636,6 +2638,7 @@ static inline void unregister_netdevice(struct net_device *dev)
 }
 
 int netdev_refcnt_read(const struct net_device *dev);
+int netdev_xdp_refcnt_read(const struct net_device *dev);
 void free_netdev(struct net_device *dev);
 void netdev_freemem(struct net_device *dev);
 void synchronize_net(void);
@@ -3739,6 +3742,28 @@ static inline void dev_hold(struct net_device *dev)
 	this_cpu_inc(*dev->pcpu_refcnt);
 }
 
+/**
+ *	dev_put_xdp - release xdp reference to device
+ *	@dev: network device
+ *
+ * Decrease the reference counter of XDP sockets bound to device.
+ */
+static inline void dev_put_xdp(struct net_device *dev)
+{
+	this_cpu_dec(*dev->pcpu_xdp_refcnt);
+}
+
+/**
+ *	dev_hold_xdp - get xdp reference to device
+ *	@dev: network device
+ *
+ * Increase the reference counter of XDP sockets bound to device.
+ */
+static inline void dev_hold_xdp(struct net_device *dev)
+{
+	this_cpu_inc(*dev->pcpu_xdp_refcnt);
+}
+
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
  * who is responsible for serialization of these calls.
diff --git a/net/core/dev.c b/net/core/dev.c
index 66f7508825bd..f6f7cf3d8e93 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8840,6 +8840,16 @@ int netdev_refcnt_read(const struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_refcnt_read);
 
+int netdev_xdp_refcnt_read(const struct net_device *dev)
+{
+	int i, refcnt = 0;
+
+	for_each_possible_cpu(i)
+		refcnt += *per_cpu_ptr(dev->pcpu_xdp_refcnt, i);
+	return refcnt;
+}
+EXPORT_SYMBOL(netdev_xdp_refcnt_read);
+
 /**
  * netdev_wait_allrefs - wait until all references are gone.
  * @dev: target net_device
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index adcc045952c2..f88bf52d41b3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2777,6 +2777,9 @@ static int rtnl_group_dellink(const struct net *net, int group)
 			ops = dev->rtnl_link_ops;
 			if (!ops || !ops->dellink)
 				return -EOPNOTSUPP;
+
+			if (netdev_xdp_refcnt_read(dev))
+				return -EBUSY;
 		}
 	}
 
@@ -2805,6 +2808,9 @@ int rtnl_delete_link(struct net_device *dev)
 	if (!ops || !ops->dellink)
 		return -EOPNOTSUPP;
 
+	if (netdev_xdp_refcnt_read(dev))
+		return -EBUSY;
+
 	ops->dellink(dev, &list_kill);
 	unregister_netdevice_many(&list_kill);
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..215cc8712b8d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -361,6 +361,7 @@ static int xsk_release(struct socket *sock)
 		xdp_del_sk_umem(xs->umem, xs);
 		xs->dev = NULL;
 		synchronize_net();
+		dev_put_xdp(dev);
 		dev_put(dev);
 	}
 
@@ -423,6 +424,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		goto out_release;
 	}
 
+	dev_hold_xdp(dev);
+
 	if (!xs->rx && !xs->tx) {
 		err = -EINVAL;
 		goto out_unlock;
@@ -490,8 +493,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xdp_add_sk_umem(xs->umem, xs);
 
 out_unlock:
-	if (err)
+	if (err) {
+		dev_put_xdp(dev);
 		dev_put(dev);
+	}
 out_release:
 	mutex_unlock(&xs->mutex);
 	return err;
-- 
2.17.1
