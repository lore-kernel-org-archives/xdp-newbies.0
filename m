Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387515AbfC0SE5 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Mar 2019 14:04:57 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 095/262] veth: Fix -Wformat-truncation
Date: Wed, 27 Mar 2019 13:59:10 -0400
Message-Id: <20190327180158.10245-95-sashal@kernel.org>
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit abdf47aab4123ece48877cab4153db44fe4dc340 ]

Provide a precision hint to snprintf() in order to eliminate a
-Wformat-truncation warning provided below. A maximum of 11 characters
is allowed to reach a maximum of 32 - 1 characters given a possible
maximum value of queues using up to UINT_MAX which occupies 10
characters. Incidentally 11 is the number of characters for
"xdp_packets" which is the largest string we append.

drivers/net/veth.c: In function 'veth_get_strings':
drivers/net/veth.c:118:47: warning: '%s' directive output may be
truncated writing up to 31 bytes into a region of size between 12 and 21
[-Wformat-truncation=]
     snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_%s",
                                               ^~
drivers/net/veth.c:118:5: note: 'snprintf' output between 12 and 52
bytes into a destination of size 32
     snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_%s",
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       i, veth_rq_stats_desc[j].desc);
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index f412ea1cef18..b203d1867959 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -115,7 +115,8 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 		p += sizeof(ethtool_stats_keys);
 		for (i = 0; i < dev->real_num_rx_queues; i++) {
 			for (j = 0; j < VETH_RQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_%s",
+				snprintf(p, ETH_GSTRING_LEN,
+					 "rx_queue_%u_%.11s",
 					 i, veth_rq_stats_desc[j].desc);
 				p += ETH_GSTRING_LEN;
 			}
-- 
2.19.1
