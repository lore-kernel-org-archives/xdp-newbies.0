Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33696 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391762AbfEXT7P (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 24 May 2019 15:59:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so1919699wmh.0
        for <xdp-newbies@vger.kernel.org>; Fri, 24 May 2019 12:59:15 -0700 (PDT)
From: Matteo Croce <mcroce@redhat.com>
Subject: [PATCH bpf] samples: bpf: add ibumad sample to .gitignore
Date: Fri, 24 May 2019 21:59:12 +0200
Message-Id: <20190524195912.4966-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

This commit adds ibumad to .gitignore which is
currently ommited from the ignore file.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 samples/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index c7498457595a..74d31fd3c99c 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -1,6 +1,7 @@
 cpustat
 fds_example
 hbm
+ibumad
 lathist
 lwt_len_hist
 map_perf_test
-- 
2.21.0
