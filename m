Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46117 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfGJXpI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jul 2019 19:45:08 -0400
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-2-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-2-krzesimir@kinvolk.io>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 10 Jul 2019 16:44:55 -0700
Message-ID: <CAEf4BzYDOyU52wdCinm9cxxvNijpTJgQbCg9UxcO1QKk6vWhNA@mail.gmail.com>
Subject: Re: [bpf-next v3 01/12] selftests/bpf: Print a message when tester
 could not run a program
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Krzesimir Nowak <krzesimir@kinvolk.io>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> This prints a message when the error is about program type being not
> supported by the test runner or because of permissions problem. This
> is to see if the program we expected to run was actually executed.
>
> The messages are open-coded because strerror(ENOTSUPP) returns
> "Unknown error 524".
>
> Changes since v2:
> - Also print "FAIL" on an unexpected bpf_prog_test_run error, so there
>   is a corresponding "FAIL" message for each failed test.
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index c5514daf8865..b8d065623ead 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -831,11 +831,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>                                 tmp, &size_tmp, &retval, NULL);
>         if (unpriv)
>                 set_admin(false);
> -       if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
> -               printf("Unexpected bpf_prog_test_run error ");
> -               return err;
> +       if (err) {
> +               switch (errno) {
> +               case 524/*ENOTSUPP*/:
> +                       printf("Did not run the program (not supported) ");
> +                       return 0;
> +               case EPERM:
> +                       printf("Did not run the program (no permission) ");

Let's add "SKIP: " prefix to these?

> +                       return 0;
> +               default:
> +                       printf("FAIL: Unexpected bpf_prog_test_run error (%s) ", strerror(saved_errno));
> +                       return err;
> +               }
>         }
> -       if (!err && retval != expected_val &&
> +       if (retval != expected_val &&
>             expected_val != POINTER_VALUE) {
>                 printf("FAIL retval %d != %d ", retval, expected_val);
>                 return 1;
> --
> 2.20.1
>
