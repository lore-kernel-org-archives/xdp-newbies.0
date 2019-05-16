Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45874 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbfEPVya (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 May 2019 17:54:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id a5so2252799pls.12
        for <xdp-newbies@vger.kernel.org>; Thu, 16 May 2019 14:54:30 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net 3/3] netdevice: clarify meaning of rx_handler_result
Date: Thu, 16 May 2019 14:54:23 -0700
Message-Id: <20190516215423.14185-4-sthemmin@microsoft.com>
In-Reply-To: <20190516215423.14185-1-sthemmin@microsoft.com>
References: <20190516215423.14185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>

Make the language in comment about rx_handler_result clearer.
Especially the meaning of RX_HANDLER_ANOTHER.

Replace use of "should" with "must" to be in line with common
usage in standards documents.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 include/linux/netdevice.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..56f613561909 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -374,10 +374,10 @@ typedef enum gro_result gro_result_t;
 
 /*
  * enum rx_handler_result - Possible return values for rx_handlers.
- * @RX_HANDLER_CONSUMED: skb was consumed by rx_handler, do not process it
- * further.
- * @RX_HANDLER_ANOTHER: Do another round in receive path. This is indicated in
- * case skb->dev was changed by rx_handler.
+ * @RX_HANDLER_CONSUMED: skb was consumed by rx_handler.
+ *  Do not process it further.
+ * @RX_HANDLER_ANOTHER: skb->dev was modified by rx_handler,
+ *  Do another round in receive path. This is indicated in
  * @RX_HANDLER_EXACT: Force exact delivery, no wildcard.
  * @RX_HANDLER_PASS: Do nothing, pass the skb as if no rx_handler was called.
  *
@@ -394,20 +394,20 @@ typedef enum gro_result gro_result_t;
  * Upon return, rx_handler is expected to tell __netif_receive_skb() what to
  * do with the skb.
  *
- * If the rx_handler consumed the skb in some way, it should return
+ * If the rx_handler consumed the skb in some way, it must return
  * RX_HANDLER_CONSUMED. This is appropriate when the rx_handler arranged for
  * the skb to be delivered in some other way.
  *
  * If the rx_handler changed skb->dev, to divert the skb to another
- * net_device, it should return RX_HANDLER_ANOTHER. The rx_handler for the
+ * net_device, it must return RX_HANDLER_ANOTHER. The rx_handler for the
  * new device will be called if it exists.
  *
- * If the rx_handler decides the skb should be ignored, it should return
+ * If the rx_handler decides the skb should be ignored, it must return
  * RX_HANDLER_EXACT. The skb will only be delivered to protocol handlers that
  * are registered on exact device (ptype->dev == skb->dev).
  *
  * If the rx_handler didn't change skb->dev, but wants the skb to be normally
- * delivered, it should return RX_HANDLER_PASS.
+ * delivered, it must return RX_HANDLER_PASS.
  *
  * A device without a registered rx_handler will behave as if rx_handler
  * returned RX_HANDLER_PASS.
-- 
2.20.1
