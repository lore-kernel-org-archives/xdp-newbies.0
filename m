Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43944 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfGDXOi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jul 2019 19:14:38 -0400
Received: by mail-lf1-f65.google.com with SMTP id j29so5089860lfk.10
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Jul 2019 16:14:37 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v7 net-next 4/5] net: ethernet: ti: cpsw_ethtool: allow res split while down
Date: Fri,  5 Jul 2019 02:14:05 +0300
Message-Id: <20190704231406.27083-5-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
References: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc: ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

That's possible to set channel num while interfaces are down. When
interface gets up it should resplit budget. This resplit can happen
after phy is up but only if speed is changed, so should be set before
this, for this allow it to happen while changing number of channels,
when interfaces are down.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index c477e6b620d6..e4d7185fde49 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -620,8 +620,7 @@ int cpsw_set_channels_common(struct net_device *ndev,
 		}
 	}
 
-	if (cpsw->usage_count)
-		cpsw_split_res(cpsw);
+	cpsw_split_res(cpsw);
 
 	ret = cpsw_resume_data_pass(ndev);
 	if (!ret)
-- 
2.17.1
