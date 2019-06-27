Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbfF0Aih (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 26 Jun 2019 20:38:37 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 44/60] bpf, devmap: Add missing RCU read lock on flush
Date: Wed, 26 Jun 2019 20:35:59 -0400
Message-Id: <20190627003616.20767-44-sashal@kernel.org>
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>, David Ahern <dsahern@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

From: Toshiaki Makita <toshiaki.makita1@gmail.com>

[ Upstream commit 86723c8640633bee4b4588d3c7784ee7a0032f65 ]

.ndo_xdp_xmit() assumes it is called under RCU. For example virtio_net
uses RCU to detect it has setup the resources for tx. The assumption
accidentally broke when introducing bulk queue in devmap.

Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 357d456d57b9..fc500ca464d0 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -282,6 +282,7 @@ void __dev_map_flush(struct bpf_map *map)
 	unsigned long *bitmap = this_cpu_ptr(dtab->flush_needed);
 	u32 bit;
 
+	rcu_read_lock();
 	for_each_set_bit(bit, bitmap, map->max_entries) {
 		struct bpf_dtab_netdev *dev = READ_ONCE(dtab->netdev_map[bit]);
 		struct xdp_bulk_queue *bq;
@@ -297,6 +298,7 @@ void __dev_map_flush(struct bpf_map *map)
 
 		__clear_bit(bit, bitmap);
 	}
+	rcu_read_unlock();
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or
@@ -389,6 +391,7 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 
 		int cpu;
 
+		rcu_read_lock();
 		for_each_online_cpu(cpu) {
 			bitmap = per_cpu_ptr(dev->dtab->flush_needed, cpu);
 			__clear_bit(dev->bit, bitmap);
@@ -396,6 +399,7 @@ static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
 			bq = per_cpu_ptr(dev->bulkq, cpu);
 			bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, false);
 		}
+		rcu_read_unlock();
 	}
 }
 
-- 
2.20.1
