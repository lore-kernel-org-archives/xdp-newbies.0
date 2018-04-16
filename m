Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeDPM1J (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 16 Apr 2018 08:27:09 -0400
Date: Mon, 16 Apr 2018 05:27:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180416122706.GA20624@infradead.org>
References: <20180412155029.0324fe58@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180412155029.0324fe58@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>

Can you try the following hack which avoids indirect calls entirely
for the fast path direct mapping case?

---
From b256a008c1b305e6a1c2afe7c004c54ad2e96d4b Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Mon, 16 Apr 2018 14:18:14 +0200
Subject: dma-mapping: bypass dma_ops for direct mappings

Reportedly the retpoline mitigation for spectre causes huge penalties
for indirect function calls.  This hack bypasses the dma_ops mechanism
for simple direct mappings.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/device.h      |  1 +
 include/linux/dma-mapping.h | 53 +++++++++++++++++++++++++++----------
 lib/dma-direct.c            |  4 +--
 3 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 0059b99e1f25..725eec4c6653 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -990,6 +990,7 @@ struct device {
 	bool			offline_disabled:1;
 	bool			offline:1;
 	bool			of_node_reused:1;
+	bool			is_dma_direct:1;
 };
 
 static inline struct device *kobj_to_dev(struct kobject *kobj)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index f8ab1c0f589e..c5d384ae25d6 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -223,6 +223,13 @@ static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 }
 #endif
 
+/* do not use directly! */
+dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size, enum dma_data_direction dir,
+		unsigned long attrs);
+int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
+		int nents, enum dma_data_direction dir, unsigned long attrs);
+
 static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 					      size_t size,
 					      enum dma_data_direction dir,
@@ -232,9 +239,13 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
-	addr = ops->map_page(dev, virt_to_page(ptr),
-			     offset_in_page(ptr), size,
-			     dir, attrs);
+	if (dev->is_dma_direct) {
+		addr = dma_direct_map_page(dev, virt_to_page(ptr),
+				offset_in_page(ptr), size, dir, attrs);
+	} else {
+		addr = ops->map_page(dev, virt_to_page(ptr),
+				offset_in_page(ptr), size, dir, attrs);
+	}
 	debug_dma_map_page(dev, virt_to_page(ptr),
 			   offset_in_page(ptr), size,
 			   dir, addr, true);
@@ -249,7 +260,7 @@ static inline void dma_unmap_single_attrs(struct device *dev, dma_addr_t addr,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->unmap_page)
+	if (!dev->is_dma_direct && ops->unmap_page)
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	debug_dma_unmap_page(dev, addr, size, dir, true);
 }
@@ -266,7 +277,10 @@ static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 	int ents;
 
 	BUG_ON(!valid_dma_direction(dir));
-	ents = ops->map_sg(dev, sg, nents, dir, attrs);
+	if (dev->is_dma_direct)
+		ents = dma_direct_map_sg(dev, sg, nents, dir, attrs);
+	else
+		ents = ops->map_sg(dev, sg, nents, dir, attrs);
 	BUG_ON(ents < 0);
 	debug_dma_map_sg(dev, sg, nents, ents, dir);
 
@@ -281,7 +295,7 @@ static inline void dma_unmap_sg_attrs(struct device *dev, struct scatterlist *sg
 
 	BUG_ON(!valid_dma_direction(dir));
 	debug_dma_unmap_sg(dev, sg, nents, dir);
-	if (ops->unmap_sg)
+	if (!dev->is_dma_direct && ops->unmap_sg)
 		ops->unmap_sg(dev, sg, nents, dir, attrs);
 }
 
@@ -295,7 +309,10 @@ static inline dma_addr_t dma_map_page_attrs(struct device *dev,
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
-	addr = ops->map_page(dev, page, offset, size, dir, attrs);
+	if (dev->is_dma_direct)
+		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
+	else
+		addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
 
 	return addr;
@@ -309,7 +326,7 @@ static inline void dma_unmap_page_attrs(struct device *dev,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->unmap_page)
+	if (!dev->is_dma_direct && ops->unmap_page)
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	debug_dma_unmap_page(dev, addr, size, dir, false);
 }
@@ -356,7 +373,7 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_for_cpu)
+	if (!dev->is_dma_direct && ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
 	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
 }
@@ -368,7 +385,7 @@ static inline void dma_sync_single_for_device(struct device *dev,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_for_device)
+	if (!dev->is_dma_direct && ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr, size, dir);
 	debug_dma_sync_single_for_device(dev, addr, size, dir);
 }
@@ -382,7 +399,7 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_for_cpu)
+	if (!dev->is_dma_direct && ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr + offset, size, dir);
 	debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 }
@@ -396,7 +413,7 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_single_for_device)
+	if (!dev->is_dma_direct && ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr + offset, size, dir);
 	debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 }
@@ -408,7 +425,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_sg_for_cpu)
+	if (!dev->is_dma_direct && ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
 }
@@ -420,7 +437,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	BUG_ON(!valid_dma_direction(dir));
-	if (ops->sync_sg_for_device)
+	if (!dev->is_dma_direct && ops->sync_sg_for_device)
 		ops->sync_sg_for_device(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_device(dev, sg, nelems, dir);
 
@@ -600,6 +617,8 @@ static inline int dma_supported(struct device *dev, u64 mask)
 	return ops->dma_supported(dev, mask);
 }
 
+extern const struct dma_map_ops swiotlb_dma_ops;
+
 #ifndef HAVE_ARCH_DMA_SET_MASK
 static inline int dma_set_mask(struct device *dev, u64 mask)
 {
@@ -609,6 +628,12 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 	dma_check_mask(dev, mask);
 
 	*dev->dma_mask = mask;
+	if (dev->dma_ops == &dma_direct_ops ||
+	    (dev->dma_ops == &swiotlb_dma_ops &&
+	     mask == DMA_BIT_MASK(64)))
+		dev->is_dma_direct = true;
+	else
+		dev->is_dma_direct = false;
 	return 0;
 }
 #endif
diff --git a/lib/dma-direct.c b/lib/dma-direct.c
index c0bba30fef0a..3deb8666974b 100644
--- a/lib/dma-direct.c
+++ b/lib/dma-direct.c
@@ -120,7 +120,7 @@ void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
 		free_pages((unsigned long)cpu_addr, page_order);
 }
 
-static dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
+dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
 		unsigned long attrs)
 {
@@ -131,7 +131,7 @@ static dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
 	return dma_addr;
 }
 
-static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
+int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	int i;
-- 
2.17.0
