Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39916 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfGJXwD (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jul 2019 19:52:03 -0400
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-3-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-3-krzesimir@kinvolk.io>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 10 Jul 2019 16:51:51 -0700
Message-ID: <CAEf4BzYra9njHOB8t6kxRu6n5NJdjjAG541OLt8ci=0zbbcUSg@mail.gmail.com>
Subject: Re: [bpf-next v3 02/12] selftests/bpf: Avoid a clobbering of errno
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> Save errno right after bpf_prog_test_run returns, so we later check
> the error code actually set by bpf_prog_test_run, not by some libcap
> function.
>
> Changes since v1:
> - Fix the "Fixes:" tag to mention actual commit that introduced the
>   bug
>
> Changes since v2:
> - Move the declaration so it fits the reverse christmas tree style.
>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Fixes: 832c6f2c29ec ("bpf: test make sure to run unpriv test cases in test_verifier")
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index b8d065623ead..3fe126e0083b 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -823,16 +823,18 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>         __u8 tmp[TEST_DATA_LEN << 2];
>         __u32 size_tmp = sizeof(tmp);
>         uint32_t retval;
> +       int saved_errno;
>         int err;
>
>         if (unpriv)
>                 set_admin(true);
>         err = bpf_prog_test_run(fd_prog, 1, data, size_data,
>                                 tmp, &size_tmp, &retval, NULL);

Given err is either 0 or -1, how about instead making err useful right
here without extra variable?

if (bpf_prog_test_run(...))
        err = errno;

> +       saved_errno = errno;
>         if (unpriv)
>                 set_admin(false);
>         if (err) {
> -               switch (errno) {
> +               switch (saved_errno) {
>                 case 524/*ENOTSUPP*/:

ENOTSUPP is defined in include/linux/errno.h, is there any problem
with using this in selftests?

>                         printf("Did not run the program (not supported) ");
>                         return 0;
> --
> 2.20.1
>
