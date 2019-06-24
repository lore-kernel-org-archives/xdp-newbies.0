Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:46502 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbfFXTxi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 24 Jun 2019 15:53:38 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so92269iol.13
        for <xdp-newbies@vger.kernel.org>; Mon, 24 Jun 2019 12:53:38 -0700 (PDT)
Date: Mon, 24 Jun 2019 14:53:36 -0500
From: Dan Rue <dan.rue@linaro.org>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
Message-ID: <20190624195336.nubi7n2np5vfjutr@xps.therub.org>
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
 <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com>
 <20190621161752.d7d7n4m5q67uivys@xps.therub.org>
 <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>, Shuah Khan <shuah@kernel.org>

On Mon, Jun 24, 2019 at 11:32:25AM -0700, Andrii Nakryiko wrote:
> On Fri, Jun 21, 2019 at 9:17 AM Dan Rue <dan.rue@linaro.org> wrote:
> >
> > On Thu, Jun 20, 2019 at 10:17:04PM -0700, Andrii Nakryiko wrote:
> > > On Thu, Jun 20, 2019 at 1:08 AM Naresh Kamboju
> > > <naresh.kamboju@linaro.org> wrote:
> > > >
> > > > selftests: bpf test_libbpf.sh failed running Linux -next kernel
> > > > 20190618 and 20190619.
> > > >
> > > > Here is the log from x86_64,
> > > > # selftests bpf test_libbpf.sh
> > > > bpf: test_libbpf.sh_ #
> > > > # [0] libbpf BTF is required, but is missing or corrupted.
> > >
> > > You need at least clang-9.0.0 (not yet released) to run some of these
> > > tests successfully, as they rely on Clang's support for
> > > BTF_KIND_VAR/BTF_KIND_DATASEC.
> >
> > Can there be a runtime check for BTF that emits a skip instead of a fail
> > in such a case?
> 
> I'm not sure how to do this simply and minimally intrusively. The best
> I can come up with is setting some envvar from Makefile and checking
> for that in each inidividual test, which honestly sounds a bit gross.
> 
> How hard is it for you guys to upgrade compiler used to run these test?

We should be able to run kselftest with any compiler that Linux
supports, so that we can test with the toolchain that users actually run
with.

I would say if it's not possible to check at runtime, and it requires
clang 9.0, that this test should not be enabled by default.

Maybe something could be done in Makefile for that? Only add it to
TEST_GEN_PROGS if the toolchain feature exists, otherwise add it to
TEST_GEN_PROGS_EXTENDED. I don't know if this is a good idea.. but from
kselftest.rst:

   TEST_PROGS, TEST_GEN_PROGS mean it is the executable tested by
   default.
   ...
   TEST_PROGS_EXTENDED, TEST_GEN_PROGS_EXTENDED mean it is the
   executable which is not tested by default.

Dan

> 
> >
> > Thanks,
> > Dan
> >
> > >
> > > > libbpf: BTF_is #
> > > > # test_libbpf failed at file test_l4lb.o
> > > > failed: at_file #
> > > > # selftests test_libbpf [FAILED]
> > > > test_libbpf: [FAILED]_ #
> > > > [FAIL] 29 selftests bpf test_libbpf.sh
> > > > selftests: bpf_test_libbpf.sh [FAIL]
> > > >
> > > > Full test log,
> > > > https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log
> > > >
> > > > Test results comparison,
> > > > https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh
> > > >
> > > > Good linux -next tag: next-20190617
> > > > Bad linux -next tag: next-20190618
> > > > git branch     master
> > > > git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
> > > > git repo
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > > >
> > > > Best regards
> > > > Naresh Kamboju
> >
> > --
> > Linaro - Kernel Validation

-- 
Linaro - Kernel Validation
