Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50635 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389081AbfGHQbx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 12:31:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so168740wml.0
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 09:31:52 -0700 (PDT)
From: Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 04/12] selftests/bpf: Use bpf_prog_test_run_xattr
Date: Mon,  8 Jul 2019 18:31:13 +0200
Message-Id: <20190708163121.18477-5-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Alban Crequy <alban@kinvolk.io>, =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, Krzesimir Nowak <krzesimir@kinvolk.io>

The bpf_prog_test_run_xattr function gives more options to set up a
test run of a BPF program than the bpf_prog_test_run function.

We will need this extra flexibility to pass ctx data later.

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index c7541f572932..1640ba9f12c1 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -822,14 +822,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 {
 	__u8 tmp[TEST_DATA_LEN << 2];
 	__u32 size_tmp = sizeof(tmp);
-	uint32_t retval;
 	int saved_errno;
 	int err;
+	struct bpf_prog_test_run_attr attr = {
+		.prog_fd = fd_prog,
+		.repeat = 1,
+		.data_in = data,
+		.data_size_in = size_data,
+		.data_out = tmp,
+		.data_size_out = size_tmp,
+	};
 
 	if (unpriv)
 		set_admin(true);
-	err = bpf_prog_test_run(fd_prog, 1, data, size_data,
-				tmp, &size_tmp, &retval, NULL);
+	err = bpf_prog_test_run_xattr(&attr);
 	saved_errno = errno;
 	if (unpriv)
 		set_admin(false);
@@ -846,9 +852,9 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 			return err;
 		}
 	}
-	if (retval != expected_val &&
+	if (attr.retval != expected_val &&
 	    expected_val != POINTER_VALUE) {
-		printf("FAIL retval %d != %d ", retval, expected_val);
+		printf("FAIL retval %d != %d ", attr.retval, expected_val);
 		return 1;
 	}
 
-- 
2.20.1
