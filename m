Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729755AbfDVTpa (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 22 Apr 2019 15:45:30 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 07/68] xsk: fix umem memory leak on cleanup
Date: Mon, 22 Apr 2019 15:44:15 -0400
Message-Id: <20190422194516.11634-7-sashal@kernel.org>
In-Reply-To: <20190422194516.11634-1-sashal@kernel.org>
References: <20190422194516.11634-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Daniel Borkmann <daniel@iogearbox.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 044175a06706d516aa42874bb44dbbfc3c4d20eb ]

When the umem is cleaned up, the task that created it might already be
gone. If the task was gone, the xdp_umem_release function did not free
the pages member of struct xdp_umem.

It turned out that the task lookup was not needed at all; The code was
a left-over when we moved from task accounting to user accounting [1].

This patch fixes the memory leak by removing the task lookup logic
completely.

[1] https://lore.kernel.org/netdev/20180131135356.19134-3-bjorn.topel@gmail.com/

Link: https://lore.kernel.org/netdev/c1cb2ca8-6a14-3980-8672-f3de0bb38dfd@suse.cz/
Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 include/net/xdp_sock.h |  1 -
 net/xdp/xdp_umem.c     | 19 +------------------
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 7161856bcf9c..c2c10cc9ffa0 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -34,7 +34,6 @@ struct xdp_umem {
 	u32 headroom;
 	u32 chunk_size_nohr;
 	struct user_struct *user;
-	struct pid *pid;
 	unsigned long address;
 	refcount_t users;
 	struct work_struct work;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index bfe2dbea480b..a3b037fbfecd 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -152,9 +152,6 @@ static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
 
 static void xdp_umem_release(struct xdp_umem *umem)
 {
-	struct task_struct *task;
-	struct mm_struct *mm;
-
 	xdp_umem_clear_dev(umem);
 
 	if (umem->fq) {
@@ -169,21 +166,10 @@ static void xdp_umem_release(struct xdp_umem *umem)
 
 	xdp_umem_unpin_pages(umem);
 
-	task = get_pid_task(umem->pid, PIDTYPE_PID);
-	put_pid(umem->pid);
-	if (!task)
-		goto out;
-	mm = get_task_mm(task);
-	put_task_struct(task);
-	if (!mm)
-		goto out;
-
-	mmput(mm);
 	kfree(umem->pages);
 	umem->pages = NULL;
 
 	xdp_umem_unaccount_pages(umem);
-out:
 	kfree(umem);
 }
 
@@ -312,7 +298,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (size_chk < 0)
 		return -EINVAL;
 
-	umem->pid = get_task_pid(current, PIDTYPE_PID);
 	umem->address = (unsigned long)addr;
 	umem->props.chunk_mask = ~((u64)chunk_size - 1);
 	umem->props.size = size;
@@ -328,7 +313,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 
 	err = xdp_umem_account_pages(umem);
 	if (err)
-		goto out;
+		return err;
 
 	err = xdp_umem_pin_pages(umem);
 	if (err)
@@ -347,8 +332,6 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 
 out_account:
 	xdp_umem_unaccount_pages(umem);
-out:
-	put_pid(umem->pid);
 	return err;
 }
 
-- 
2.19.1
