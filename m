Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbfC0SC1 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Mar 2019 14:02:27 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 016/262] xsk: fix to reject invalid flags in xsk_bind
Date: Wed, 27 Mar 2019 13:57:51 -0400
Message-Id: <20190327180158.10245-16-sashal@kernel.org>
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Daniel Borkmann <daniel@iogearbox.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit f54ba391d88f5a5d032175b4c308c176e34b80b7 ]

Passing a non-existing flag in the sxdp_flags member of struct
sockaddr_xdp was, incorrectly, silently ignored. This patch addresses
that behavior, and rejects any non-existing flags.

We have examined existing user space code, and to our best knowledge,
no one is relying on the current incorrect behavior. AF_XDP is still
in its infancy, so from our perspective, the risk of breakage is very
low, and addressing this problem now is important.

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 85e4fe4f18cc..f3031c8907d9 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -407,6 +407,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	if (sxdp->sxdp_family != AF_XDP)
 		return -EINVAL;
 
+	flags = sxdp->sxdp_flags;
+	if (flags & ~(XDP_SHARED_UMEM | XDP_COPY | XDP_ZEROCOPY))
+		return -EINVAL;
+
 	mutex_lock(&xs->mutex);
 	if (xs->dev) {
 		err = -EBUSY;
@@ -425,7 +429,6 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	}
 
 	qid = sxdp->sxdp_queue_id;
-	flags = sxdp->sxdp_flags;
 
 	if (flags & XDP_SHARED_UMEM) {
 		struct xdp_sock *umem_xs;
-- 
2.19.1
