Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38619 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbfE1Srv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 May 2019 14:47:51 -0400
Received: by mail-pg1-f196.google.com with SMTP id v11so11517939pgl.5
        for <xdp-newbies@vger.kernel.org>; Tue, 28 May 2019 11:47:50 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH PATCH v4 2/2] net: core: support XDP generic on stacked devices.
Date: Tue, 28 May 2019 11:47:31 -0700
Message-Id: <20190528184731.7464-3-sthemmin@microsoft.com>
In-Reply-To: <20190528184731.7464-1-sthemmin@microsoft.com>
References: <20190528184731.7464-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: davem@davemloft.net, saeedm@mellanox.com, jasowang@redhat.com, brouer@redhat.com
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>

When a device is stacked like (team, bonding, failsafe or netvsc) the
XDP generic program for the parent device was not called.

Move the call to XDP generic inside __netif_receive_skb_core where
it can be done multiple times for stacked case.

Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
v1 - call xdp_generic in netvsc handler
v2 - do xdp_generic in generic rx handler processing
v3 - move xdp_generic call inside the another pass loop
v4 - reset skb mac_len after xdp is called

 net/core/dev.c | 58 +++++++++++---------------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e..cc2a4e257324 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4502,23 +4502,6 @@ static int netif_rx_internal(struct sk_buff *skb)
 
 	trace_netif_rx(skb);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		/* Consider XDP consuming the packet a success from
-		 * the netdev point of view we do not want to count
-		 * this as an error.
-		 */
-		if (ret != XDP_PASS)
-			return NET_RX_SUCCESS;
-	}
-
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
@@ -4858,6 +4841,18 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 
 	__this_cpu_inc(softnet_data.processed);
 
+	if (static_branch_unlikely(&generic_xdp_needed_key)) {
+		int ret2;
+
+		preempt_disable();
+		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		preempt_enable();
+
+		if (ret2 != XDP_PASS)
+			return NET_RX_DROP;
+		skb_reset_mac_len(skb);
+	}
+
 	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
 	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
 		skb = skb_vlan_untag(skb);
@@ -5178,19 +5173,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		int ret;
-
-		preempt_disable();
-		rcu_read_lock();
-		ret = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
-		rcu_read_unlock();
-		preempt_enable();
-
-		if (ret != XDP_PASS)
-			return NET_RX_DROP;
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
@@ -5211,7 +5193,6 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 
 static void netif_receive_skb_list_internal(struct list_head *head)
 {
-	struct bpf_prog *xdp_prog = NULL;
 	struct sk_buff *skb, *next;
 	struct list_head sublist;
 
@@ -5224,21 +5205,6 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 	}
 	list_splice_init(&sublist, head);
 
-	if (static_branch_unlikely(&generic_xdp_needed_key)) {
-		preempt_disable();
-		rcu_read_lock();
-		list_for_each_entry_safe(skb, next, head, list) {
-			xdp_prog = rcu_dereference(skb->dev->xdp_prog);
-			skb_list_del_init(skb);
-			if (do_xdp_generic(xdp_prog, skb) == XDP_PASS)
-				list_add_tail(&skb->list, &sublist);
-		}
-		rcu_read_unlock();
-		preempt_enable();
-		/* Put passed packets back on main list */
-		list_splice_init(&sublist, head);
-	}
-
 	rcu_read_lock();
 #ifdef CONFIG_RPS
 	if (static_branch_unlikely(&rps_needed)) {
-- 
2.20.1
