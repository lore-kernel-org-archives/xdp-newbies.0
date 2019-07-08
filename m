Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35275 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388429AbfGHQbu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 12:31:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so9256700wrm.2
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 09:31:49 -0700 (PDT)
From: Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 02/12] selftests/bpf: Avoid a clobbering of errno
Date: Mon,  8 Jul 2019 18:31:11 +0200
Message-Id: <20190708163121.18477-3-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Alban Crequy <alban@kinvolk.io>, =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, Krzesimir Nowak <krzesimir@kinvolk.io>

Save errno right after bpf_prog_test_run returns, so we later check
the error code actually set by bpf_prog_test_run, not by some libcap
function.

Changes since v1:
- Fix the "Fixes:" tag to mention actual commit that introduced the
  bug

Changes since v2:
- Move the declaration so it fits the reverse christmas tree style.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 832c6f2c29ec ("bpf: test make sure to run unpriv test cases in test_verifier")
Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index b8d065623ead..3fe126e0083b 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -823,16 +823,18 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 	__u8 tmp[TEST_DATA_LEN << 2];
 	__u32 size_tmp = sizeof(tmp);
 	uint32_t retval;
+	int saved_errno;
 	int err;
 
 	if (unpriv)
 		set_admin(true);
 	err = bpf_prog_test_run(fd_prog, 1, data, size_data,
 				tmp, &size_tmp, &retval, NULL);
+	saved_errno = errno;
 	if (unpriv)
 		set_admin(false);
 	if (err) {
-		switch (errno) {
+		switch (saved_errno) {
 		case 524/*ENOTSUPP*/:
 			printf("Did not run the program (not supported) ");
 			return 0;
-- 
2.20.1
