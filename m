Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbfCMTLz (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Mar 2019 15:11:55 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 41/60] i40e: fix potential RX buffer starvation for AF_XDP
Date: Wed, 13 Mar 2019 15:10:02 -0400
Message-Id: <20190313191021.158171-41-sashal@kernel.org>
In-Reply-To: <20190313191021.158171-1-sashal@kernel.org>
References: <20190313191021.158171-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Magnus Karlsson <magnus.karlsson@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 14ffeb52f3693ae0b674e59453452a2365ae9fd9 ]

When the RX rings are created they are also populated with buffers
so that packets can be received. Usually these are kernel buffers,
but for AF_XDP in zero-copy mode, these are user-space buffers and
in this case the application might not have sent down any buffers
to the driver at this point. And if no buffers are allocated at ring
creation time, no packets can be received and no interrupts will be
generated so the NAPI poll function that allocates buffers to the
rings will never get executed.

To rectify this, we kick the NAPI context of any queue with an
attached AF_XDP zero-copy socket in two places in the code. Once
after an XDP program has loaded and once after the umem is registered.
This take care of both cases: XDP program gets loaded first then AF_XDP
socket is created, and the reverse, AF_XDP socket is created first,
then XDP program is loaded.

Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 13 ++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  5 +++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f97c3d5ab884..89a072b5ce6c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3290,8 +3290,11 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	     i40e_alloc_rx_buffers_zc(ring, I40E_DESC_UNUSED(ring)) :
 	     !i40e_alloc_rx_buffers(ring, I40E_DESC_UNUSED(ring));
 	if (!ok) {
+		/* Log this in case the user has forgotten to give the kernel
+		 * any buffers, even later in the application.
+		 */
 		dev_info(&vsi->back->pdev->dev,
-			 "Failed allocate some buffers on %sRx ring %d (pf_q %d)\n",
+			 "Failed to allocate some buffers on %sRx ring %d (pf_q %d)\n",
 			 ring->xsk_umem ? "UMEM enabled " : "",
 			 ring->queue_index, pf_q);
 	}
@@ -11895,6 +11898,14 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
+	/* Kick start the NAPI context if there is an AF_XDP socket open
+	 * on that queue id. This so that receiving will start.
+	 */
+	if (need_reset && prog)
+		for (i = 0; i < vsi->num_queue_pairs; i++)
+			if (vsi->xdp_rings[i]->xsk_umem)
+				(void)i40e_xsk_async_xmit(vsi->netdev, i);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 870cf654e436..3827f16e6923 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -183,6 +183,11 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 		err = i40e_queue_pair_enable(vsi, qid);
 		if (err)
 			return err;
+
+		/* Kick start the NAPI context so that receiving will start */
+		err = i40e_xsk_async_xmit(vsi->netdev, qid);
+		if (err)
+			return err;
 	}
 
 	return 0;
-- 
2.19.1
