Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43021 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728530AbfGKMHh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jul 2019 08:07:37 -0400
Received: by mail-lj1-f194.google.com with SMTP id 16so5491751ljv.10
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jul 2019 05:07:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-5-krzesimir@kinvolk.io>
 <CAEf4BzZoOw=1B8vV53iAxz8LDULOPVF-he4C_usoUQSdXU+oSg@mail.gmail.com>
In-Reply-To: <CAEf4BzZoOw=1B8vV53iAxz8LDULOPVF-he4C_usoUQSdXU+oSg@mail.gmail.com>
From: Krzesimir Nowak <krzesimir@kinvolk.io>
Date: Thu, 11 Jul 2019 14:07:24 +0200
Message-ID: <CAGGp+cGUYbdEeHJxVCk0VZvOMSoR6Fz5aUJD0Ye71w5dxETXMA@mail.gmail.com>
Subject: Re: [bpf-next v3 04/12] selftests/bpf: Use bpf_prog_test_run_xattr
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, Alban Crequy <alban@kinvolk.io>, =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Stanislav Fomichev <sdf@google.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org

On Thu, Jul 11, 2019 at 2:03 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 8, 2019 at 3:43 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
> >
> > The bpf_prog_test_run_xattr function gives more options to set up a
> > test run of a BPF program than the bpf_prog_test_run function.
> >
> > We will need this extra flexibility to pass ctx data later.
> >
> > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > ---
>
> lgtm, with some nits below
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  tools/testing/selftests/bpf/test_verifier.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index c7541f572932..1640ba9f12c1 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -822,14 +822,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
> >  {
> >         __u8 tmp[TEST_DATA_LEN << 2];
> >         __u32 size_tmp = sizeof(tmp);
>
> nit: this is now is not needed as a separate local variable, inline?

I think I'm using this variable in a followup commit, but I'll look closely.

>
> > -       uint32_t retval;
> >         int saved_errno;
> >         int err;
> > +       struct bpf_prog_test_run_attr attr = {
> > +               .prog_fd = fd_prog,
> > +               .repeat = 1,
> > +               .data_in = data,
> > +               .data_size_in = size_data,
> > +               .data_out = tmp,
> > +               .data_size_out = size_tmp,
> > +       };
> >
> >         if (unpriv)
> >                 set_admin(true);
> > -       err = bpf_prog_test_run(fd_prog, 1, data, size_data,
> > -                               tmp, &size_tmp, &retval, NULL);
> > +       err = bpf_prog_test_run_xattr(&attr);
> >         saved_errno = errno;
> >         if (unpriv)
> >                 set_admin(false);
> > @@ -846,9 +852,9 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
> >                         return err;
> >                 }
> >         }
> > -       if (retval != expected_val &&
> > +       if (attr.retval != expected_val &&
> >             expected_val != POINTER_VALUE) {
>
> this if condition now fits one line, can you please combine? thanks!

Sure.

>
> > -               printf("FAIL retval %d != %d ", retval, expected_val);
> > +               printf("FAIL retval %d != %d ", attr.retval, expected_val);
> >                 return 1;
> >         }
> >
> > --
> > 2.20.1
> >



-- 
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Geschäftsführer/Directors: Alban Crequy, Chris Kühl, Iago López Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
