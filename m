Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36853 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404182AbfEXUtl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 24 May 2019 16:49:41 -0400
MIME-Version: 1.0
References: <20190523125355.18437-1-mrostecki@opensuse.org> <4642ca96-22ab-ad61-a6a1-1d2ef7239cb8@fb.com>
In-Reply-To: <4642ca96-22ab-ad61-a6a1-1d2ef7239cb8@fb.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 May 2019 13:49:26 -0700
Message-ID: <CAADnVQKYiv2ZMTLcJ6ZAoSA8u7+GZe+o-00qidefuNPa7KsbbA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 RESEND 0/2] Move bpf_printk to bpf_helpers.h
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Yonghong Song <yhs@fb.com>
Cc: Michal Rostecki <mrostecki@opensuse.org>, Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, "open list:BPF (Safe dynamic programs and tools)" <netdev@vger.kernel.org>, "open list:BPF (Safe dynamic programs and tools)" <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:XDP (eXpress Data Path)" <xdp-newbies@vger.kernel.org>

On Thu, May 23, 2019 at 9:52 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/23/19 5:53 AM, Michal Rostecki wrote:
> > This series of patches move the commonly used bpf_printk macro to
> > bpf_helpers.h which is already included in all BPF programs which
> > defined that macro on their own.
> >
> > v1->v2:
> > - If HBM_DEBUG is not defined in hbm sample, undefine bpf_printk and set
> >    an empty macro for it.
> >
> > Michal Rostecki (2):
> >    selftests: bpf: Move bpf_printk to bpf_helpers.h
> >    samples: bpf: Do not define bpf_printk macro
> >
> >   samples/bpf/hbm_kern.h                                | 11 ++---------
> >   samples/bpf/tcp_basertt_kern.c                        |  7 -------
> >   samples/bpf/tcp_bufs_kern.c                           |  7 -------
> >   samples/bpf/tcp_clamp_kern.c                          |  7 -------
> >   samples/bpf/tcp_cong_kern.c                           |  7 -------
> >   samples/bpf/tcp_iw_kern.c                             |  7 -------
> >   samples/bpf/tcp_rwnd_kern.c                           |  7 -------
> >   samples/bpf/tcp_synrto_kern.c                         |  7 -------
> >   samples/bpf/tcp_tos_reflect_kern.c                    |  7 -------
> >   samples/bpf/xdp_sample_pkts_kern.c                    |  7 -------
> >   tools/testing/selftests/bpf/bpf_helpers.h             |  8 ++++++++
> >   .../testing/selftests/bpf/progs/sockmap_parse_prog.c  |  7 -------
> >   .../selftests/bpf/progs/sockmap_tcp_msg_prog.c        |  7 -------
> >   .../selftests/bpf/progs/sockmap_verdict_prog.c        |  7 -------
> >   .../testing/selftests/bpf/progs/test_lwt_seg6local.c  |  7 -------
> >   tools/testing/selftests/bpf/progs/test_xdp_noinline.c |  7 -------
> >   tools/testing/selftests/bpf/test_sockmap_kern.h       |  7 -------
> >   17 files changed, 10 insertions(+), 114 deletions(-)
>
> Ack for the whole series.
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
