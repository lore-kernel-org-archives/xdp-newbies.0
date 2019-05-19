Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41785 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfESRGm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 19 May 2019 13:06:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id q17so6029758pfq.8
        for <xdp-newbies@vger.kernel.org>; Sun, 19 May 2019 10:06:41 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net 2/2] net: core: generic XDP support for stacked device
Date: Sat, 18 May 2019 20:10:46 -0700
Message-Id: <20190519031046.4049-3-sthemmin@microsoft.com>
In-Reply-To: <20190519031046.4049-1-sthemmin@microsoft.com>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>, Jason Wang <jasowang@redhat.com>

When a device is stacked like (team, bonding, failsafe or netvsc) the
XDP generic program for the parent device is not called.  In these
cases, the rx handler changes skb->dev to its own in the receive
handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
do_xdp_generic if necessary before starting another round.

Review of all the places RX_HANDLER_ANOTHER is returned
show that the current devices do correctly change skb->dev.

There was an older patch that got abandoned that did the
same thing, this is just a rewrite.

Suggested-by: Jason Wang <jasowang@redhat.com>
Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 net/core/dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e..240d0b2de1a8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4921,6 +4921,16 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 			ret = NET_RX_SUCCESS;
 			goto out;
 		case RX_HANDLER_ANOTHER:
+			if (static_branch_unlikely(&generic_xdp_needed_key)) {
+				struct bpf_prog *xdp_prog;
+
+				xdp_prog = rcu_dereference(skb->dev->xdp_prog);
+				ret = do_xdp_generic(xdp_prog, skb);
+				if (ret != XDP_PASS) {
+					ret = NET_RX_SUCCESS;
+					goto out;
+				}
+			}
 			goto another_round;
 		case RX_HANDLER_EXACT:
 			deliver_exact = true;
-- 
2.20.1
