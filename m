Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36336 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728703AbfFYLmw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 07:42:52 -0400
Received: by mail-lf1-f66.google.com with SMTP id q26so12419684lfc.3
        for <xdp-newbies@vger.kernel.org>; Tue, 25 Jun 2019 04:42:51 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [[PATCH net-next]] net: core: xdp: make __mem_id_disconnect to be static
Date: Tue, 25 Jun 2019 14:42:46 +0300
Message-Id: <20190625114246.14726-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org, hawk@kernel.org, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Add missed static for local __mem_id_disconnect().

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index b29d7b513a18..829377cc83db 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 	kfree(xa);
 }
 
-bool __mem_id_disconnect(int id, bool force)
+static bool __mem_id_disconnect(int id, bool force)
 {
 	struct xdp_mem_allocator *xa;
 	bool safe_to_remove = true;
-- 
2.17.1
