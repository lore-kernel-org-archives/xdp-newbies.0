Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbfCMTL5 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Mar 2019 15:11:57 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 42/60] ixgbe: fix potential RX buffer starvation for AF_XDP
Date: Wed, 13 Mar 2019 15:10:03 -0400
Message-Id: <20190313191021.158171-42-sashal@kernel.org>
In-Reply-To: <20190313191021.158171-1-sashal@kernel.org>
References: <20190313191021.158171-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 4a9b32f30f805ca596d76605903a48eab58e0b88 ]

When the RX rings are created they are also populated with buffers so
that packets can be received. Usually these are kernel buffers, but
for AF_XDP in zero-copy mode, these are user-space buffers and in this
case the application might not have sent down any buffers to the
driver at this point. And if no buffers are allocated at ring creation
time, no packets can be received and no interrupts will be generated so
the NAPI poll function that allocates buffers to the rings will never
get executed.

To rectify this, we kick the NAPI context of any queue with an
attached AF_XDP zero-copy socket in two places in the code. Once after
an XDP program has loaded and once after the umem is registered.  This
take care of both cases: XDP program gets loaded first then AF_XDP
socket is created, and the reverse, AF_XDP socket is created first,
then XDP program is loaded.

Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 12 +++++++++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 12 ++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index aed1890514d6..8c47451f17f1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10207,6 +10207,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	int i, frame_size = dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct bpf_prog *old_prog;
+	bool need_reset;
 
 	if (adapter->flags & IXGBE_FLAG_SRIOV_ENABLED)
 		return -EINVAL;
@@ -10229,9 +10230,10 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 		return -ENOMEM;
 
 	old_prog = xchg(&adapter->xdp_prog, prog);
+	need_reset = (!!prog != !!old_prog);
 
 	/* If transitioning XDP modes reconfigure rings */
-	if (!!prog != !!old_prog) {
+	if (need_reset) {
 		int err = ixgbe_setup_tc(dev, adapter->hw_tcs);
 
 		if (err) {
@@ -10247,6 +10249,14 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
+	/* Kick start the NAPI context if there is an AF_XDP socket open
+	 * on that queue id. This so that receiving will start.
+	 */
+	if (need_reset && prog)
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			if (adapter->xdp_ring[i]->xsk_umem)
+				(void)ixgbe_xsk_async_xmit(adapter->netdev, i);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 65c3e2c979d4..654ae92342ea 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -144,11 +144,19 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 		ixgbe_txrx_ring_disable(adapter, qid);
 
 	err = ixgbe_add_xsk_umem(adapter, umem, qid);
+	if (err)
+		return err;
 
-	if (if_running)
+	if (if_running) {
 		ixgbe_txrx_ring_enable(adapter, qid);
 
-	return err;
+		/* Kick start the NAPI context so that receiving will start */
+		err = ixgbe_xsk_async_xmit(adapter->netdev, qid);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 static int ixgbe_xsk_umem_disable(struct ixgbe_adapter *adapter, u16 qid)
-- 
2.19.1
