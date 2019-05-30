Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44635 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfE3SUx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 30 May 2019 14:20:53 -0400
Received: by mail-lj1-f196.google.com with SMTP id e13so6968486ljl.11
        for <xdp-newbies@vger.kernel.org>; Thu, 30 May 2019 11:20:51 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 net-next 1/7] net: page_pool: add helper function to retrieve dma addresses
Date: Thu, 30 May 2019 21:20:33 +0300
Message-Id: <20190530182039.4945-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc: ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, Jesper Dangaard Brouer <brouer@redhat.com>, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

On a previous patch dma addr was stored in 'struct page'.
Use that to retrieve DMA addresses used by network drivers

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 include/net/page_pool.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 694d055e01ef..b885d86cb7a1 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -132,6 +132,11 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	__page_pool_put_page(pool, page, true);
 }
 
+static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
+{
+	return page->dma_addr;
+}
+
 static inline bool is_page_pool_compiled_in(void)
 {
 #ifdef CONFIG_PAGE_POOL
-- 
2.17.1
