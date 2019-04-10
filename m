Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35497 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfDJCcP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Apr 2019 22:32:15 -0400
From: Huang Rui <huangruippp@gmail.com>
Subject: [PATCH] net:bridge:always disable auto-tuning when the user specified MTU
Date: Wed, 10 Apr 2019 02:32:08 +0000
Message-Id: <20190410023208.25435-1-huangruiPPP@gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: davem@davemloft.net
Cc: ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, jiri@mellanox.com, ecree@solarflare.com, idosch@mellanox.com, petrm@mellanox.com, alexander.h.duyck@intel.com, amritha.nambiar@intel.com, lirongqing@baidu.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com, bridge@lists.linux-foundation.org, huangruiPPP@gmail.com

For example.
My purpose is to create a bridge br0 and join eth0 into br0.
if we use this following way, the auto-tuning flag will not be disabled.

If eth0's mtu is 1200
step 1.brctl addbr br0
step 2.brctl addif br0 eth0
step 3.ifconfig br0 mtu 1200
step 4.ifconfig eth0 mtu 1500

Result:
br0's MTU: 1500, eth0's MTU: 1500

Expected:
br0's MTU: 1200, eth0's MTU: 1500

I have specified br0's MTU,  but auto-min policy works. So the MTU is
not the result what we expected.
As expected, if i have specified bridge's MTU, it will set the flag:
BROPT_MTU_SET_BY_USER in net_bridge_opts disabled and auto-min/max
policy will not work.But in this case, because the dev_set_mtu return
early, the BROPT_MTU_SET_BY_USER flag will not be disabled and
auto-min/max policy will still work.

Signed-off-by: Huang Rui <huangruiPPP@gmail.com>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2b67f2aa59dd..ba410d76bb49 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7670,8 +7670,12 @@ int dev_set_mtu_ext(struct net_device *dev, int new_mtu,
 {
 	int err, orig_mtu;
 
-	if (new_mtu == dev->mtu)
-		return 0;
+	if (new_mtu == dev->mtu) {
+		if (dev->priv_flags & IFF_EBRIDGE)
+			return __dev_set_mtu(dev, new_mtu);
+		else
+			return 0;
+	}
 
 	/* MTU must be positive, and in range */
 	if (new_mtu < 0 || new_mtu < dev->min_mtu) {
-- 
2.11.0
