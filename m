Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbfCMTMP (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Mar 2019 15:12:15 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 47/60] ixgbe: don't do any AF_XDP zero-copy transmit if netif is not OK
Date: Wed, 13 Mar 2019 15:10:08 -0400
Message-Id: <20190313191021.158171-47-sashal@kernel.org>
In-Reply-To: <20190313191021.158171-1-sashal@kernel.org>
References: <20190313191021.158171-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Sokolowski <jan.sokolowski@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>

[ Upstream commit c685c69fba71462c3f9f6a1fb6151cded6c74d42 ]

An issue has been found while testing zero-copy XDP that
causes a reset to be triggered. As it takes some time to
turn the carrier on after setting zc, and we already
start trying to transmit some packets, watchdog considers
this as an erroneous state and triggers a reset.

Don't do any work if netif carrier is not OK.

Fixes: 8221c5eba8c13 (ixgbe: add AF_XDP zero-copy Tx support)
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 654ae92342ea..36a8879536a4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -642,7 +642,8 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	dma_addr_t dma;
 
 	while (budget-- > 0) {
-		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
+		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
+		    !netif_carrier_ok(xdp_ring->netdev)) {
 			work_done = false;
 			break;
 		}
-- 
2.19.1
