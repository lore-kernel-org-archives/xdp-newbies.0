Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731138AbfEWROB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 May 2019 13:14:01 -0400
From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 RESEND 0/2] Move bpf_printk to bpf_helpers.h
Date: Thu, 23 May 2019 16:51:20 +0000
Message-ID: <4642ca96-22ab-ad61-a6a1-1d2ef7239cb8@fb.com>
References: <20190523125355.18437-1-mrostecki@opensuse.org>
In-Reply-To: <20190523125355.18437-1-mrostecki@opensuse.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD6A272AAD7B7F488C08810609D42B8E@namprd15.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Michal Rostecki <mrostecki@opensuse.org>
Cc: Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, "open list:BPF (Safe dynamic programs and tools)" <netdev@vger.kernel.org>, "open list:BPF (Safe dynamic programs and tools)" <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:XDP (eXpress Data Path)" <xdp-newbies@vger.kernel.org>



On 5/23/19 5:53 AM, Michal Rostecki wrote:
> This series of patches move the commonly used bpf_printk macro to
> bpf_helpers.h which is already included in all BPF programs which
> defined that macro on their own.
> 
> v1->v2:
> - If HBM_DEBUG is not defined in hbm sample, undefine bpf_printk and set
>    an empty macro for it.
> 
> Michal Rostecki (2):
>    selftests: bpf: Move bpf_printk to bpf_helpers.h
>    samples: bpf: Do not define bpf_printk macro
> 
>   samples/bpf/hbm_kern.h                                | 11 ++---------
>   samples/bpf/tcp_basertt_kern.c                        |  7 -------
>   samples/bpf/tcp_bufs_kern.c                           |  7 -------
>   samples/bpf/tcp_clamp_kern.c                          |  7 -------
>   samples/bpf/tcp_cong_kern.c                           |  7 -------
>   samples/bpf/tcp_iw_kern.c                             |  7 -------
>   samples/bpf/tcp_rwnd_kern.c                           |  7 -------
>   samples/bpf/tcp_synrto_kern.c                         |  7 -------
>   samples/bpf/tcp_tos_reflect_kern.c                    |  7 -------
>   samples/bpf/xdp_sample_pkts_kern.c                    |  7 -------
>   tools/testing/selftests/bpf/bpf_helpers.h             |  8 ++++++++
>   .../testing/selftests/bpf/progs/sockmap_parse_prog.c  |  7 -------
>   .../selftests/bpf/progs/sockmap_tcp_msg_prog.c        |  7 -------
>   .../selftests/bpf/progs/sockmap_verdict_prog.c        |  7 -------
>   .../testing/selftests/bpf/progs/test_lwt_seg6local.c  |  7 -------
>   tools/testing/selftests/bpf/progs/test_xdp_noinline.c |  7 -------
>   tools/testing/selftests/bpf/test_sockmap_kern.h       |  7 -------
>   17 files changed, 10 insertions(+), 114 deletions(-)

Ack for the whole series.
Acked-by: Yonghong Song <yhs@fb.com>
