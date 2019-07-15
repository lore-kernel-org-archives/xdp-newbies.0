Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732702AbfGON5c (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 15 Jul 2019 09:57:32 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 175/249] xsk: Properly terminate assignment in xskq_produce_flush_desc
Date: Mon, 15 Jul 2019 09:45:40 -0400
Message-Id: <20190715134655.4076-175-sashal@kernel.org>
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nathan Chancellor <natechancellor@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Song Liu <songliubraving@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, clang-built-linux@googlegroups.com

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit f7019b7b0ad14bde732b8953161994edfc384953 ]

Clang warns:

In file included from net/xdp/xsk_queue.c:10:
net/xdp/xsk_queue.h:292:2: warning: expression result unused
[-Wunused-value]
        WRITE_ONCE(q->ring->producer, q->prod_tail);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
        __u.__val;                                      \
        ~~~ ^~~~~
1 warning generated.

The q->prod_tail assignment has a comma at the end, not a semi-colon.
Fix that so clang no longer warns and everything works as expected.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Link: https://github.com/ClangBuiltLinux/linux/issues/544
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 88b9ae24658d..cba4a640d5e8 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -288,7 +288,7 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
 	/* Order producer and data */
 	smp_wmb(); /* B, matches C */
 
-	q->prod_tail = q->prod_head,
+	q->prod_tail = q->prod_head;
 	WRITE_ONCE(q->ring->producer, q->prod_tail);
 }
 
-- 
2.20.1
