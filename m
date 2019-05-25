Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37326 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfEYJDE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 25 May 2019 05:03:04 -0400
Date: Sat, 25 May 2019 14:32:57 +0530
From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Subject: [PATCH] libbpf: fix warning PTR_ERR_OR_ZERO can be used
Message-ID: <20190525090257.GA12104@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org

fix below warning reported by coccicheck

/tools/lib/bpf/libbpf.c:3461:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 tools/lib/bpf/libbpf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 197b574..33c25b6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3458,9 +3458,7 @@ bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
 
 long libbpf_get_error(const void *ptr)
 {
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-	return 0;
+	return PTR_ERR_OR_ZERO(ptr);
 }
 
 int bpf_prog_load(const char *file, enum bpf_prog_type type,
-- 
2.7.4
