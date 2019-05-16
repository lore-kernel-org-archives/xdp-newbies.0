Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33932 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbfEPLV3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 May 2019 07:21:29 -0400
From: Michal Rostecki <mrostecki@opensuse.org>
Subject: [PATCH bpf-next 0/2] Move bpf_printk to bpf_helpers.h
Date: Thu, 16 May 2019 13:20:56 +0200
Message-Id: <20190516112105.12887-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Cc: Michal Rostecki <mrostecki@opensuse.org>, Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jiong Wang <jiong.wang@netronome.com>, Mathieu Xhonneux <m.xhonneux@gmail.com>, linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, xdp-newbies@vger.kernel.org

This series of patches move the commonly used bpf_printk macro to
bpf_helpers.h which is already included in all BPF programs which
defined that macro on their own.

Michal Rostecki (2):
  selftests: bpf: Move bpf_printk to bpf_helpers.h
  samples: bpf: Do not define bpf_printk macro

 samples/bpf/hbm_kern.h                               | 12 +++---------
 samples/bpf/hbm_out_kern.c                           |  2 ++
 samples/bpf/tcp_basertt_kern.c                       |  7 -------
 samples/bpf/tcp_bufs_kern.c                          |  7 -------
 samples/bpf/tcp_clamp_kern.c                         |  7 -------
 samples/bpf/tcp_cong_kern.c                          |  7 -------
 samples/bpf/tcp_iw_kern.c                            |  7 -------
 samples/bpf/tcp_rwnd_kern.c                          |  7 -------
 samples/bpf/tcp_synrto_kern.c                        |  7 -------
 samples/bpf/tcp_tos_reflect_kern.c                   |  7 -------
 samples/bpf/xdp_sample_pkts_kern.c                   |  7 -------
 tools/testing/selftests/bpf/bpf_helpers.h            |  8 ++++++++
 .../testing/selftests/bpf/progs/sockmap_parse_prog.c |  7 -------
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c       |  7 -------
 .../selftests/bpf/progs/sockmap_verdict_prog.c       |  7 -------
 .../testing/selftests/bpf/progs/test_lwt_seg6local.c |  7 -------
 .../testing/selftests/bpf/progs/test_xdp_noinline.c  |  7 -------
 tools/testing/selftests/bpf/test_sockmap_kern.h      |  7 -------
 18 files changed, 13 insertions(+), 114 deletions(-)

-- 
2.21.0
