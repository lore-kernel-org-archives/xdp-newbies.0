Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41499 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfE1Sru (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 May 2019 14:47:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id z3so6893772pgp.8
        for <xdp-newbies@vger.kernel.org>; Tue, 28 May 2019 11:47:49 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH PATCH v4 1/2] netvsc: unshare skb in VF rx handler
Date: Tue, 28 May 2019 11:47:30 -0700
Message-Id: <20190528184731.7464-2-sthemmin@microsoft.com>
In-Reply-To: <20190528184731.7464-1-sthemmin@microsoft.com>
References: <20190528184731.7464-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: davem@davemloft.net, saeedm@mellanox.com, jasowang@redhat.com, brouer@redhat.com
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>

The netvsc VF skb handler should make sure that skb is not
shared. Similar logic already exists in bonding and team device
drivers.

This is not an issue in practice because the VF devicex
does not send up shared skb's. But the netvsc driver
should do the right thing if it did.

Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 06393b215102..9873b8679f81 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2000,6 +2000,12 @@ static rx_handler_result_t netvsc_vf_handle_frame(struct sk_buff **pskb)
 	struct netvsc_vf_pcpu_stats *pcpu_stats
 		 = this_cpu_ptr(ndev_ctx->vf_stats);
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return RX_HANDLER_CONSUMED;
+
+	*pskb = skb;
+
 	skb->dev = ndev;
 
 	u64_stats_update_begin(&pcpu_stats->syncp);
-- 
2.20.1
