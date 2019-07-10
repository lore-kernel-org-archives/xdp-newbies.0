Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33974 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfGJX52 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jul 2019 19:57:28 -0400
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-4-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-4-krzesimir@kinvolk.io>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 10 Jul 2019 16:57:15 -0700
Message-ID: <CAEf4BzbM6EiCkN5mwK1YP-NC2bavkkHV7nFR-PXCWGOvVt7nTg@mail.gmail.com>
Subject: Re: [bpf-next v3 03/12] selftests/bpf: Avoid another case of errno clobbering
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Mon, Jul 8, 2019 at 3:43 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> Commit 8184d44c9a57 ("selftests/bpf: skip verifier tests for
> unsupported program types") added a check for an unsupported program
> type. The function doing it changes errno, so test_verifier should
> save it before calling it if test_verifier wants to print a reason why
> verifying a BPF program of a supported type failed.
>
> Changes since v2:
> - Move the declaration to fit the reverse christmas tree style.
>
> Fixes: 8184d44c9a57 ("selftests/bpf: skip verifier tests for unsupported program types")
> Cc: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 3fe126e0083b..c7541f572932 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -864,6 +864,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>         int run_errs, run_successes;
>         int map_fds[MAX_NR_MAPS];
>         const char *expected_err;
> +       int saved_errno;
>         int fixup_skips;

nit: combine those ints? or even with i and err below as well?

>         __u32 pflags;
>         int i, err;
> @@ -894,6 +895,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                 pflags |= BPF_F_ANY_ALIGNMENT;
>         fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
>                                      "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
> +       saved_errno = errno;
>         if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
>                 printf("SKIP (unsupported program type %d)\n", prog_type);
>                 skips++;
> @@ -910,7 +912,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>         if (expected_ret == ACCEPT) {
>                 if (fd_prog < 0) {
>                         printf("FAIL\nFailed to load prog '%s'!\n",
> -                              strerror(errno));
> +                              strerror(saved_errno));
>                         goto fail_log;
>                 }
>  #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> --
> 2.20.1
>
