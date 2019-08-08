Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40064 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732310AbfHHJiJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 8 Aug 2019 05:38:09 -0400
Received: by mail-lf1-f65.google.com with SMTP id b17so66333116lff.7
        for <xdp-newbies@vger.kernel.org>; Thu, 08 Aug 2019 02:38:08 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 bpf-next] xdp: xdp_umem: fix umem pages mapping for 32bits systems
Date: Thu,  8 Aug 2019 12:38:03 +0300
Message-Id: <20190808093803.4918-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc: davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com, hawk@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Use kmap instead of page_address as it's not always in low memory.

Acked-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on bpf-next/master
v2..v1:
	included highmem.h

v1: https://lkml.org/lkml/2019/6/26/693

 net/xdp/xdp_umem.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..a0607969f8c0 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/idr.h>
+#include <linux/highmem.h>
 
 #include "xdp_umem.h"
 #include "xsk_queue.h"
@@ -164,6 +165,14 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 	umem->zc = false;
 }
 
+static void xdp_umem_unmap_pages(struct xdp_umem *umem)
+{
+	unsigned int i;
+
+	for (i = 0; i < umem->npgs; i++)
+		kunmap(umem->pgs[i]);
+}
+
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
 	unsigned int i;
@@ -207,6 +216,7 @@ static void xdp_umem_release(struct xdp_umem *umem)
 
 	xsk_reuseq_destroy(umem);
 
+	xdp_umem_unmap_pages(umem);
 	xdp_umem_unpin_pages(umem);
 
 	kfree(umem->pages);
@@ -369,7 +379,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	}
 
 	for (i = 0; i < umem->npgs; i++)
-		umem->pages[i].addr = page_address(umem->pgs[i]);
+		umem->pages[i].addr = kmap(umem->pgs[i]);
 
 	return 0;
 
-- 
2.17.1
