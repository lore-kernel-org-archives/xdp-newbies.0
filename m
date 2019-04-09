Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41311 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfDIHgt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Apr 2019 03:36:49 -0400
From: Huang Rui <huangruippp@gmail.com>
Subject: [PATCH] net:bridge:bridge mtu auto tuning does not always work
Date: Tue,  9 Apr 2019 07:36:42 +0000
Message-Id: <20190409073642.12953-1-huangruiPPP@gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: davem@davemloft.net
Cc: ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, jiri@mellanox.com, ecree@solarflare.com, idosch@mellanox.com, petrm@mellanox.com, alexander.h.duyck@intel.com, amritha.nambiar@intel.com, lirongqing@baidu.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, huangruiPPP@gmail.com

If someone setup a bridge and add a port(for example: eth0)
into the bridge, but configure the bridge's mtu which is equal
to eth0's mtu, the auto tuning flag will not be set true. But
the meaning of the auto tuning flag is that it will be set true
if a user configure bridge's mtu.

Signed-off-by: Huang Rui <huangruiPPP@gmail.com>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2b67f2a..ba410d7 100644
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
1.8.3.1
