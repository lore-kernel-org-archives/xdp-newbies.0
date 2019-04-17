Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36559 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733150AbfDQRuK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 17 Apr 2019 13:50:10 -0400
Received: by mail-lj1-f194.google.com with SMTP id r24so23314828ljg.3
        for <xdp-newbies@vger.kernel.org>; Wed, 17 Apr 2019 10:50:08 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [RFC PATCH 1/3] net: ethernet: ti: davinci_cpdma: add dma mapped submit
Date: Wed, 17 Apr 2019 20:49:40 +0300
Message-Id: <20190417174942.11811-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
References: <20190417174942.11811-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: grygorii.strashko@ti.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ilias.apalodimas@linaro.org, hawk@kernel.org, xdp-newbies@vger.kernel.org, ast@kernel.org, aniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

In case if dma mapped packet needs to be sent, like with XDP
page pool, the "mapped" submit can be used. This patch adds dma
mapped submit based on regular one.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 84 ++++++++++++++++++++-----
 drivers/net/ethernet/ti/davinci_cpdma.h |  2 +
 2 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 4236dcdd5634..96ec1d9d8f47 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -132,6 +132,15 @@ struct cpdma_chan {
 	u32				rate;
 };
 
+struct submit_info {
+	struct cpdma_chan *chan;
+	int directed;
+	void *token;
+	void *data;
+	int flags;
+	int len;
+};
+
 struct cpdma_control_info {
 	u32		reg;
 	u32		shift, mask;
@@ -183,6 +192,8 @@ static struct cpdma_control_info controls[] = {
 				 (directed << CPDMA_TO_PORT_SHIFT));	\
 	} while (0)
 
+#define CPDMA_DMA_EXT_MAP		BIT(16)
+
 static void cpdma_desc_pool_destroy(struct cpdma_ctlr *ctlr)
 {
 	struct cpdma_desc_pool *pool = ctlr->pool;
@@ -1026,10 +1037,11 @@ static void __cpdma_chan_submit(struct cpdma_chan *chan,
 	}
 }
 
-int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
-		      int len, int directed)
+static int cpdma_chan_submit_si(struct submit_info *si)
 {
+	struct cpdma_chan		*chan = si->chan;
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
+	int				len = si->len;
 	struct cpdma_desc __iomem	*desc;
 	dma_addr_t			buffer;
 	unsigned long			flags;
@@ -1061,16 +1073,22 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		chan->stats.runt_transmit_buff++;
 	}
 
-	buffer = dma_map_single(ctlr->dev, data, len, chan->dir);
-	ret = dma_mapping_error(ctlr->dev, buffer);
-	if (ret) {
-		cpdma_desc_free(ctlr->pool, desc, 1);
-		ret = -EINVAL;
-		goto unlock_ret;
-	}
-
 	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
-	cpdma_desc_to_port(chan, mode, directed);
+	cpdma_desc_to_port(chan, mode, si->directed);
+
+	if (si->flags & CPDMA_DMA_EXT_MAP) {
+		buffer = (dma_addr_t)si->data;
+		dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
+		len |= CPDMA_DMA_EXT_MAP;
+	} else {
+		buffer = dma_map_single(ctlr->dev, si->data, len, chan->dir);
+		ret = dma_mapping_error(ctlr->dev, buffer);
+		if (ret) {
+			cpdma_desc_free(ctlr->pool, desc, 1);
+			ret = -EINVAL;
+			goto unlock_ret;
+		}
+	}
 
 	/* Relaxed IO accessors can be used here as there is read barrier
 	 * at the end of write sequence.
@@ -1079,7 +1097,7 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 	writel_relaxed(buffer, &desc->hw_buffer);
 	writel_relaxed(len, &desc->hw_len);
 	writel_relaxed(mode | len, &desc->hw_mode);
-	writel_relaxed((uintptr_t)token, &desc->sw_token);
+	writel_relaxed((uintptr_t)si->token, &desc->sw_token);
 	writel_relaxed(buffer, &desc->sw_buffer);
 	writel_relaxed(len, &desc->sw_len);
 	desc_read(desc, sw_len);
@@ -1095,8 +1113,39 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return ret;
 }
+
+int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data, int len,
+		      int directed)
+{
+	struct submit_info si;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = data;
+	si.len = len;
+	si.directed = directed;
+	si.flags = 0;
+
+	return cpdma_chan_submit_si(&si);
+}
 EXPORT_SYMBOL_GPL(cpdma_chan_submit);
 
+int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token, void *data,
+			     int len, int directed)
+{
+	struct submit_info si;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = data;
+	si.len = len;
+	si.directed = directed;
+	si.flags = CPDMA_DMA_EXT_MAP;
+
+	return cpdma_chan_submit_si(&si);
+}
+EXPORT_SYMBOL_GPL(cpdma_chan_submit_mapped);
+
 bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
 {
 	struct cpdma_ctlr	*ctlr = chan->ctlr;
@@ -1123,10 +1172,17 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
 	uintptr_t			token;
 
 	token      = desc_read(desc, sw_token);
-	buff_dma   = desc_read(desc, sw_buffer);
 	origlen    = desc_read(desc, sw_len);
 
-	dma_unmap_single(ctlr->dev, buff_dma, origlen, chan->dir);
+	buff_dma   = desc_read(desc, sw_buffer);
+	if (origlen & CPDMA_DMA_EXT_MAP) {
+		origlen &= ~CPDMA_DMA_EXT_MAP;
+		dma_sync_single_for_cpu(ctlr->dev, buff_dma, origlen,
+					chan->dir);
+	} else {
+		dma_unmap_single(ctlr->dev, buff_dma, origlen, chan->dir);
+	}
+
 	cpdma_desc_free(pool, desc, 1);
 	(*chan->handler)((void *)token, outlen, status);
 }
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index d399af5389b8..20e4d43df6d1 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -84,6 +84,8 @@ int cpdma_chan_stop(struct cpdma_chan *chan);
 
 int cpdma_chan_get_stats(struct cpdma_chan *chan,
 			 struct cpdma_chan_stats *stats);
+int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token, void *data,
+			     int len, int directed);
 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		      int len, int directed);
 int cpdma_chan_process(struct cpdma_chan *chan, int quota);
-- 
2.17.1
