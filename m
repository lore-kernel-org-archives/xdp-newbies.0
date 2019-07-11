Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36807 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbfGKMEa (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jul 2019 08:04:30 -0400
Received: by mail-lf1-f67.google.com with SMTP id q26so3884143lfc.3
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jul 2019 05:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-3-krzesimir@kinvolk.io>
 <CAEf4BzYra9njHOB8t6kxRu6n5NJdjjAG541OLt8ci=0zbbcUSg@mail.gmail.com>
In-Reply-To: <CAEf4BzYra9njHOB8t6kxRu6n5NJdjjAG541OLt8ci=0zbbcUSg@mail.gmail.com>
From: Krzesimir Nowak <krzesimir@kinvolk.io>
Date: Thu, 11 Jul 2019 14:04:17 +0200
Message-ID: <CAGGp+cGnEBFoPAuhTPa_JFCW6Vbjp2NN0ZPqC3qGfWEXwTyVOQ@mail.gmail.com>
Subject: Re: [bpf-next v3 02/12] selftests/bpf: Avoid a clobbering of errno
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Thu, Jul 11, 2019 at 1:52 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
> >
> > Save errno right after bpf_prog_test_run returns, so we later check
> > the error code actually set by bpf_prog_test_run, not by some libcap
> > function.
> >
> > Changes since v1:
> > - Fix the "Fixes:" tag to mention actual commit that introduced the
> >   bug
> >
> > Changes since v2:
> > - Move the declaration so it fits the reverse christmas tree style.
> >
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Fixes: 832c6f2c29ec ("bpf: test make sure to run unpriv test cases in test_verifier")
> > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index b8d065623ead..3fe126e0083b 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -823,16 +823,18 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
> >         __u8 tmp[TEST_DATA_LEN << 2];
> >         __u32 size_tmp = sizeof(tmp);
> >         uint32_t retval;
> > +       int saved_errno;
> >         int err;
> >
> >         if (unpriv)
> >                 set_admin(true);
> >         err = bpf_prog_test_run(fd_prog, 1, data, size_data,
> >                                 tmp, &size_tmp, &retval, NULL);
>
> Given err is either 0 or -1, how about instead making err useful right
> here without extra variable?
>
> if (bpf_prog_test_run(...))
>         err = errno;

I change it later to bpf_prog_test_run_xattr, which can also return
-EINVAL and then errno is not set. But this one probably should not be
triggered by the test code. So not sure, probably would be better to
keep it as is for consistency?

>
> > +       saved_errno = errno;
> >         if (unpriv)
> >                 set_admin(false);
> >         if (err) {
> > -               switch (errno) {
> > +               switch (saved_errno) {
> >                 case 524/*ENOTSUPP*/:
>
> ENOTSUPP is defined in include/linux/errno.h, is there any problem
> with using this in selftests?

I just used whatever there was earlier. Seems like <linux/errno.h> is
not copied to tools include directory.

>
> >                         printf("Did not run the program (not supported) ");
> >                         return 0;
> > --
> > 2.20.1
> >



-- 
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Geschäftsführer/Directors: Alban Crequy, Chris Kühl, Iago López Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
