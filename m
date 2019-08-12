Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43508 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbfHLLef (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 12 Aug 2019 07:34:35 -0400
Received: by mail-lf1-f67.google.com with SMTP id c19so73993103lfm.10
        for <xdp-newbies@vger.kernel.org>; Mon, 12 Aug 2019 04:34:34 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next] mm: mmap: increase sockets maximum memory size pgoff for 32bits
Date: Mon, 12 Aug 2019 14:34:29 +0300
Message-Id: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
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
interface - extend max allowed file size for sockets. The 64-bit
systems seems like ok with this, so extend threshold only for
32-bits for now.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on bpf-next/master

 mm/mmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 7e8c3e8ae75f..238ce6b71405 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1358,6 +1358,11 @@ static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
 	if (S_ISBLK(inode->i_mode))
 		return MAX_LFS_FILESIZE;
 
+#if BITS_PER_LONG == 32
+	if (S_ISSOCK(inode->i_mode))
+		return MAX_LFS_FILESIZE;
+#endif
+
 	/* Special "we do even unsigned file positions" case */
 	if (file->f_mode & FMODE_UNSIGNED_OFFSET)
 		return 0;
-- 
2.17.1
