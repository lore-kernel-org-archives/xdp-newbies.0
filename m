Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41343 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfHLMok (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 12 Aug 2019 08:44:40 -0400
Received: by mail-lj1-f195.google.com with SMTP id d24so98125563ljg.8
        for <xdp-newbies@vger.kernel.org>; Mon, 12 Aug 2019 05:44:39 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory size pgoff for 32bits
Date: Mon, 12 Aug 2019 15:43:26 +0300
Message-Id: <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: bjorn.topel@intel.com, linux-mm@kvack.org
Cc: xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ast@kernel.org, magnus.karlsson@intel.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
established already and are part of configuration interface.

But for 32-bit systems, while AF_XDP socket configuration, the values
are to large to pass maximum allowed file size verification.
The offsets can be tuned ofc, but instead of changing existent
interface - extend max allowed file size for sockets.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on bpf-next/master

v2..v1:
	removed not necessarily #ifdev as ULL and UL for 64 has same size

 mm/mmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7e8c3e8ae75f..578f52812361 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1358,6 +1358,9 @@ static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
 	if (S_ISBLK(inode->i_mode))
 		return MAX_LFS_FILESIZE;
 
+	if (S_ISSOCK(inode->i_mode))
+		return MAX_LFS_FILESIZE;
+
 	/* Special "we do even unsigned file positions" case */
 	if (file->f_mode & FMODE_UNSIGNED_OFFSET)
 		return 0;
-- 
2.17.1
