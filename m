Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751107AbeDPVHM (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 16 Apr 2018 17:07:12 -0400
Date: Mon, 16 Apr 2018 23:07:04 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
Message-ID: <20180416230704.65629b9f@redhat.com>
In-Reply-To: <20180416122706.GA20624@infradead.org>
References: <20180412155029.0324fe58@redhat.com>
        <20180416122706.GA20624@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, brouer@redhat.com

On Mon, 16 Apr 2018 05:27:06 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> Can you try the following hack which avoids indirect calls entirely
> for the fast path direct mapping case?
> 
> ---
> From b256a008c1b305e6a1c2afe7c004c54ad2e96d4b Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Mon, 16 Apr 2018 14:18:14 +0200
> Subject: dma-mapping: bypass dma_ops for direct mappings
> 
> Reportedly the retpoline mitigation for spectre causes huge penalties
> for indirect function calls.  This hack bypasses the dma_ops mechanism
> for simple direct mappings.

I did below to get it compiling, and working...

On X86 swiotlb fallback (via get_dma_ops -> get_arch_dma_ops) to use
x86_swiotlb_dma_ops, instead of swiotlb_dma_ops.  I also included that
in below fix patch.

Performance improved to 8.9 Mpps from approx 6.5Mpps.

(This was without my bulking for net_device->ndo_xdp_xmit, so that
number should improve more).

---
[PATCH RFC] fixups for Hellwig's DMA avoid retpoline overhead patch

From: Jesper Dangaard Brouer <brouer@redhat.com>

Performance improved to 8.9 Mpps
    8917613 pkt/s

it was around 6.5 Mpps before.
---
 arch/x86/kernel/pci-swiotlb.c                 |    3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    1 +
 include/linux/dma-mapping.h                   |   14 +++++++++++++-
 lib/Kconfig                                   |    2 +-
 lib/Makefile                                  |    1 +
 lib/dma-direct.c                              |    2 ++
 lib/swiotlb.c                                 |    1 +
 7 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 0ee0f8f34251..46207e288587 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -48,7 +48,7 @@ void x86_swiotlb_free_coherent(struct device *dev, size_t size,
 		dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
 }
 
-static const struct dma_map_ops x86_swiotlb_dma_ops = {
+const struct dma_map_ops x86_swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc = x86_swiotlb_alloc_coherent,
 	.free = x86_swiotlb_free_coherent,
@@ -62,6 +62,7 @@ static const struct dma_map_ops x86_swiotlb_dma_ops = {
 	.unmap_page = swiotlb_unmap_page,
 	.dma_supported = NULL,
 };
+EXPORT_SYMBOL(x86_swiotlb_dma_ops);
 
 /*
  * pci_swiotlb_detect_override - set swiotlb to 1 if necessary
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0daccaf72a30..6d2e3f75febc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10297,6 +10297,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return err;
 
 	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
+		pr_info("XXX %s() dma_set_mask_and_coherent\n", __func__);
 		pci_using_dac = 1;
 	} else {
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index f2fb5aec7626..7fa92664ebfd 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -622,6 +622,7 @@ static inline int dma_supported(struct device *dev, u64 mask)
 }
 
 extern const struct dma_map_ops swiotlb_dma_ops;
+extern const struct dma_map_ops x86_swiotlb_dma_ops;
 
 #ifndef HAVE_ARCH_DMA_SET_MASK
 static inline int dma_set_mask(struct device *dev, u64 mask)
@@ -632,12 +633,23 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 	dma_check_mask(dev, mask);
 
 	*dev->dma_mask = mask;
+#ifdef CONFIG_DMA_DIRECT_OPS
 	if (dev->dma_ops == &dma_direct_ops ||
+# ifdef CONFIG_SWIOTLB
 	    (dev->dma_ops == &swiotlb_dma_ops &&
-	     mask == DMA_BIT_MASK(64)))
+	     mask == DMA_BIT_MASK(64)) ||
+#  ifdef CONFIG_X86
+	    (get_dma_ops(dev) == &x86_swiotlb_dma_ops &&
+	     mask == DMA_BIT_MASK(64))
+#  endif /* CONFIG_X86 */
+# endif /* CONFIG_SWIOTLB */
+	   )
 		dev->is_dma_direct = true;
 	else
+#endif /* CONFIG_DMA_DIRECT_OPS */
 		dev->is_dma_direct = false;
+
+	pr_info("XXX: %s() DMA is direct: %d\n", __func__, dev->is_dma_direct);
 	return 0;
 }
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index e96089499371..6eba2bcf468a 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -416,7 +416,7 @@ config SGL_ALLOC
 config DMA_DIRECT_OPS
 	bool
 	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
-	default n
+	default y
 
 config DMA_VIRT_OPS
 	bool
diff --git a/lib/Makefile b/lib/Makefile
index a90d4fcd748f..df4885eabf9c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -29,6 +29,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 lib-$(CONFIG_DMA_DIRECT_OPS) += dma-direct.o
+#lib-y += dma-direct.o
 lib-$(CONFIG_DMA_VIRT_OPS) += dma-virt.o
 
 lib-y	+= kobject.o klist.o
diff --git a/lib/dma-direct.c b/lib/dma-direct.c
index ea69f8777e7f..d945efea3dae 100644
--- a/lib/dma-direct.c
+++ b/lib/dma-direct.c
@@ -107,6 +107,7 @@ dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
 		return DIRECT_MAPPING_ERROR;
 	return dma_addr;
 }
+EXPORT_SYMBOL(dma_direct_map_page);
 
 int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 		int nents, enum dma_data_direction dir, unsigned long attrs)
@@ -125,6 +126,7 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 
 	return nents;
 }
+EXPORT_SYMBOL(dma_direct_map_sg);
 
 int dma_direct_supported(struct device *dev, u64 mask)
 {
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index c43ec2271469..ecb70f5e95ba 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -1132,4 +1132,5 @@ const struct dma_map_ops swiotlb_dma_ops = {
 	.unmap_page		= swiotlb_unmap_page,
 	.dma_supported		= swiotlb_dma_supported,
 };
+EXPORT_SYMBOL(swiotlb_dma_ops);
 #endif /* CONFIG_DMA_DIRECT_OPS */
