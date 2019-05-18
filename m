Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40044 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbfERAqp (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 17 May 2019 20:46:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id 15so4155543wmg.5
        for <xdp-newbies@vger.kernel.org>; Fri, 17 May 2019 17:46:43 -0700 (PDT)
From: Matteo Croce <mcroce@redhat.com>
Subject: [PATCH 1/5] samples/bpf: fix test_lru_dist build
Date: Sat, 18 May 2019 02:46:35 +0200
Message-Id: <20190518004639.20648-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

Fix the following error by removing a duplicate struct definition:

samples/bpf/test_lru_dist.c:39:8: error: redefinition of ‘struct list_head’
   39 | struct list_head {
      |        ^~~~~~~~~
In file included from samples/bpf/test_lru_dist.c:9:
./tools/include/linux/types.h:69:8: note: originally defined here
   69 | struct list_head {
      |        ^~~~~~~~~
make[2]: *** [scripts/Makefile.host:92: samples/bpf/test_lru_dist] Error 1
make[1]: *** [Makefile:1763: samples/bpf/] Error 2

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 samples/bpf/test_lru_dist.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index eec3e2509ce8..f532b894654b 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -36,10 +36,6 @@ static int nr_cpus;
 static unsigned long long *dist_keys;
 static unsigned int dist_key_counts;
 
-struct list_head {
-	struct list_head *next, *prev;
-};
-
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
 	list->next = list;
-- 
2.21.0
