Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388801AbfB1PPP (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Feb 2019 10:15:15 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 36/36] qed: Consider TX tcs while deriving the max num_queues for PF.
Date: Thu, 28 Feb 2019 10:13:37 -0500
Message-Id: <20190228151337.12176-36-sashal@kernel.org>
In-Reply-To: <20190228151337.12176-1-sashal@kernel.org>
References: <20190228151337.12176-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>, Ariel Elior <aelior@marvell.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>

[ Upstream commit fb1faab74ddef9ec2d841d54e5d0912a097b3abe ]

Max supported queues is derived incorrectly in the case of multi-CoS.
Need to consider TCs while calculating num_queues for PF.

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 83c1c4fa102b7..13db311c16e5e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -2161,7 +2161,7 @@ static int qed_fill_eth_dev_info(struct qed_dev *cdev,
 			u16 num_queues = 0;
 
 			/* Since the feature controls only queue-zones,
-			 * make sure we have the contexts [rx, tx, xdp] to
+			 * make sure we have the contexts [rx, xdp, tcs] to
 			 * match.
 			 */
 			for_each_hwfn(cdev, i) {
@@ -2171,7 +2171,8 @@ static int qed_fill_eth_dev_info(struct qed_dev *cdev,
 				u16 cids;
 
 				cids = hwfn->pf_params.eth_pf_params.num_cons;
-				num_queues += min_t(u16, l2_queues, cids / 3);
+				cids /= (2 + info->num_tc);
+				num_queues += min_t(u16, l2_queues, cids);
 			}
 
 			/* queues might theoretically be >256, but interrupts'
-- 
2.19.1
