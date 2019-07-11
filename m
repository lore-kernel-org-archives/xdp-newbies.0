Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36654 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbfGKMFZ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jul 2019 08:05:25 -0400
Received: by mail-lj1-f194.google.com with SMTP id i21so5508917ljj.3
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jul 2019 05:05:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-4-krzesimir@kinvolk.io>
 <CAEf4BzbM6EiCkN5mwK1YP-NC2bavkkHV7nFR-PXCWGOvVt7nTg@mail.gmail.com>
In-Reply-To: <CAEf4BzbM6EiCkN5mwK1YP-NC2bavkkHV7nFR-PXCWGOvVt7nTg@mail.gmail.com>
From: Krzesimir Nowak <krzesimir@kinvolk.io>
Date: Thu, 11 Jul 2019 14:05:11 +0200
Message-ID: <CAGGp+cHi0siwc1+q--JM_+a0QOO6tWgJiOkqsdbjGxjMP3G1Zw@mail.gmail.com>
Subject: Re: [bpf-next v3 03/12] selftests/bpf: Avoid another case of errno clobbering
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Thu, Jul 11, 2019 at 1:57 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 8, 2019 at 3:43 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
> >
> > Commit 8184d44c9a57 ("selftests/bpf: skip verifier tests for
> > unsupported program types") added a check for an unsupported program
> > type. The function doing it changes errno, so test_verifier should
> > save it before calling it if test_verifier wants to print a reason why
> > verifying a BPF program of a supported type failed.
> >
> > Changes since v2:
> > - Move the declaration to fit the reverse christmas tree style.
> >
> > Fixes: 8184d44c9a57 ("selftests/bpf: skip verifier tests for unsupported program types")
> > Cc: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > ---
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index 3fe126e0083b..c7541f572932 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -864,6 +864,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >         int run_errs, run_successes;
> >         int map_fds[MAX_NR_MAPS];
> >         const char *expected_err;
> > +       int saved_errno;
> >         int fixup_skips;
>
> nit: combine those ints? or even with i and err below as well?

Will do.

>
> >         __u32 pflags;
> >         int i, err;
> > @@ -894,6 +895,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >                 pflags |= BPF_F_ANY_ALIGNMENT;
> >         fd_prog = bpf_verify_program(prog_type, prog, prog_len, pflags,
> >                                      "GPL", 0, bpf_vlog, sizeof(bpf_vlog), 4);
> > +       saved_errno = errno;
> >         if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
> >                 printf("SKIP (unsupported program type %d)\n", prog_type);
> >                 skips++;
> > @@ -910,7 +912,7 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >         if (expected_ret == ACCEPT) {
> >                 if (fd_prog < 0) {
> >                         printf("FAIL\nFailed to load prog '%s'!\n",
> > -                              strerror(errno));
> > +                              strerror(saved_errno));
> >                         goto fail_log;
> >                 }
> >  #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > --
> > 2.20.1
> >



-- 
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Geschäftsführer/Directors: Alban Crequy, Chris Kühl, Iago López Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
