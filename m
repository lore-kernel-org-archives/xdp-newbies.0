Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35290 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389250AbfGHQbz (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 12:31:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so9256960wrm.2
        for <xdp-newbies@vger.kernel.org>; Mon, 08 Jul 2019 09:31:54 -0700 (PDT)
From: Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 06/12] selftests/bpf: Make sure that preexisting tests for perf event work
Date: Mon,  8 Jul 2019 18:31:15 +0200
Message-Id: <20190708163121.18477-7-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Alban Crequy <alban@kinvolk.io>, =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, Krzesimir Nowak <krzesimir@kinvolk.io>

We are going to introduce a test run implementation for perf event in
a later commit and it will not allow passing any data out or ctx out
to it, and requires their sizes to be specified to zero. To avoid test
failures when the feature is introduced, override the data out size to
zero. That will also cause NULL buffer to be sent to the kernel.

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 .../testing/selftests/bpf/verifier/perf_event_sample_period.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
index 471c1a5950d8..19f5d824b275 100644
--- a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
+++ b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
@@ -13,6 +13,7 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.override_data_out_len = true,
 },
 {
 	"check bpf_perf_event_data->sample_period half load permitted",
@@ -29,6 +30,7 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.override_data_out_len = true,
 },
 {
 	"check bpf_perf_event_data->sample_period word load permitted",
@@ -45,6 +47,7 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.override_data_out_len = true,
 },
 {
 	"check bpf_perf_event_data->sample_period dword load permitted",
@@ -56,4 +59,5 @@
 	},
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_PERF_EVENT,
+	.override_data_out_len = true,
 },
-- 
2.20.1
