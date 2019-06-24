Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45608 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfFXSch (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 24 Jun 2019 14:32:37 -0400
MIME-Version: 1.0
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
 <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com> <20190621161752.d7d7n4m5q67uivys@xps.therub.org>
In-Reply-To: <20190621161752.d7d7n4m5q67uivys@xps.therub.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 24 Jun 2019 11:32:25 -0700
Message-ID: <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Dan Rue <dan.rue@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>, Shuah Khan <shuah@kernel.org>

On Fri, Jun 21, 2019 at 9:17 AM Dan Rue <dan.rue@linaro.org> wrote:
>
> On Thu, Jun 20, 2019 at 10:17:04PM -0700, Andrii Nakryiko wrote:
> > On Thu, Jun 20, 2019 at 1:08 AM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > > selftests: bpf test_libbpf.sh failed running Linux -next kernel
> > > 20190618 and 20190619.
> > >
> > > Here is the log from x86_64,
> > > # selftests bpf test_libbpf.sh
> > > bpf: test_libbpf.sh_ #
> > > # [0] libbpf BTF is required, but is missing or corrupted.
> >
> > You need at least clang-9.0.0 (not yet released) to run some of these
> > tests successfully, as they rely on Clang's support for
> > BTF_KIND_VAR/BTF_KIND_DATASEC.
>
> Can there be a runtime check for BTF that emits a skip instead of a fail
> in such a case?

I'm not sure how to do this simply and minimally intrusively. The best
I can come up with is setting some envvar from Makefile and checking
for that in each inidividual test, which honestly sounds a bit gross.

How hard is it for you guys to upgrade compiler used to run these test?

>
> Thanks,
> Dan
>
> >
> > > libbpf: BTF_is #
> > > # test_libbpf failed at file test_l4lb.o
> > > failed: at_file #
> > > # selftests test_libbpf [FAILED]
> > > test_libbpf: [FAILED]_ #
> > > [FAIL] 29 selftests bpf test_libbpf.sh
> > > selftests: bpf_test_libbpf.sh [FAIL]
> > >
> > > Full test log,
> > > https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log
> > >
> > > Test results comparison,
> > > https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh
> > >
> > > Good linux -next tag: next-20190617
> > > Bad linux -next tag: next-20190618
> > > git branch     master
> > > git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
> > > git repo
> > > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > >
> > > Best regards
> > > Naresh Kamboju
>
> --
> Linaro - Kernel Validation
