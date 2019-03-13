Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbfCMTMO (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Mar 2019 15:12:14 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 46/60] i40e: fix XDP_REDIRECT/XDP xmit ring cleanup race
Date: Wed, 13 Mar 2019 15:10:07 -0400
Message-Id: <20190313191021.158171-46-sashal@kernel.org>
In-Reply-To: <20190313191021.158171-1-sashal@kernel.org>
References: <20190313191021.158171-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 59eb2a884f5380011179acc4662fc2cc2d850454 ]

When the driver clears the XDP xmit ring due to re-configuration or
teardown, in-progress ndo_xdp_xmit must be taken into consideration.

The ndo_xdp_xmit function is typically called from a NAPI context that
the driver does not control. Therefore, we must be careful not to
clear the XDP ring, while the call is on-going. This patch adds a
synchronize_rcu() to wait for napi(s) (preempt-disable regions and
softirqs), prior clearing the queue. Further, the __I40E_CONFIG_BUSY
flag is checked in the ndo_xdp_xmit implementation to avoid touching
the XDP xmit queue during re-configuration.

Fixes: d9314c474d4f ("i40e: add support for XDP_REDIRECT")
Fixes: 123cecd427b6 ("i40e: added queue pair disable/enable functions")
Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 14 ++++++++++++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |  4 +++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 89a072b5ce6c..393647153857 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6729,8 +6729,13 @@ void i40e_down(struct i40e_vsi *vsi)
 
 	for (i = 0; i < vsi->num_queue_pairs; i++) {
 		i40e_clean_tx_ring(vsi->tx_rings[i]);
-		if (i40e_enabled_xdp_vsi(vsi))
+		if (i40e_enabled_xdp_vsi(vsi)) {
+			/* Make sure that in-progress ndo_xdp_xmit
+			 * calls are completed.
+			 */
+			synchronize_rcu();
 			i40e_clean_tx_ring(vsi->xdp_rings[i]);
+		}
 		i40e_clean_rx_ring(vsi->rx_rings[i]);
 	}
 
@@ -11966,8 +11971,13 @@ static void i40e_queue_pair_reset_stats(struct i40e_vsi *vsi, int queue_pair)
 static void i40e_queue_pair_clean_rings(struct i40e_vsi *vsi, int queue_pair)
 {
 	i40e_clean_tx_ring(vsi->tx_rings[queue_pair]);
-	if (i40e_enabled_xdp_vsi(vsi))
+	if (i40e_enabled_xdp_vsi(vsi)) {
+		/* Make sure that in-progress ndo_xdp_xmit calls are
+		 * completed.
+		 */
+		synchronize_rcu();
 		i40e_clean_tx_ring(vsi->xdp_rings[queue_pair]);
+	}
 	i40e_clean_rx_ring(vsi->rx_rings[queue_pair]);
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d0a95424ce58..48a0d8a53895 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3708,6 +3708,7 @@ int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	struct i40e_netdev_priv *np = netdev_priv(dev);
 	unsigned int queue_index = smp_processor_id();
 	struct i40e_vsi *vsi = np->vsi;
+	struct i40e_pf *pf = vsi->back;
 	struct i40e_ring *xdp_ring;
 	int drops = 0;
 	int i;
@@ -3715,7 +3716,8 @@ int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	if (test_bit(__I40E_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
 
-	if (!i40e_enabled_xdp_vsi(vsi) || queue_index >= vsi->num_queue_pairs)
+	if (!i40e_enabled_xdp_vsi(vsi) || queue_index >= vsi->num_queue_pairs ||
+	    test_bit(__I40E_CONFIG_BUSY, pf->state))
 		return -ENXIO;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
-- 
2.19.1
