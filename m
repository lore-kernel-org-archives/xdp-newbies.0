Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:19103 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbfFYCcv (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 24 Jun 2019 22:32:51 -0400
From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] xdp: Make __mem_id_disconnect static
Date: Tue, 25 Jun 2019 10:31:37 +0800
Message-ID: <20190625023137.29272-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, hawk@kernel.org, john.fastabend@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

net/core/xdp.c:88:6: warning:
 symbol '__mem_id_disconnect' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/core/xdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index b29d7b5..829377c 100644
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
2.7.4
