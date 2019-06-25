Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f175.google.com ([209.85.208.175]:35732 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfFYU14 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 16:27:56 -0400
MIME-Version: 1.0
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
 <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com>
 <20190621161752.d7d7n4m5q67uivys@xps.therub.org> <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
 <20190624195336.nubi7n2np5vfjutr@xps.therub.org> <CAADnVQKZycXgSw6C0qa7g0y=W3xRhM_4Rqcj7ZzL=rGh_n4mgA@mail.gmail.com>
 <20190625153159.5utnn36dgku5545n@xps.therub.org>
In-Reply-To: <20190625153159.5utnn36dgku5545n@xps.therub.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 25 Jun 2019 13:27:41 -0700
Message-ID: <CAADnVQLoSc=PsKj=KdCsqMLfHO-sP_Bijgy63zROos6Cy=k+dw@mail.gmail.com>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Dan Rue <dan.rue@linaro.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Naresh Kamboju <naresh.kamboju@linaro.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Shuah Khan <shuah@kernel.org>

On Tue, Jun 25, 2019 at 8:32 AM Dan Rue <dan.rue@linaro.org> wrote:
>
> On Mon, Jun 24, 2019 at 12:58:15PM -0700, Alexei Starovoitov wrote:
> > On Mon, Jun 24, 2019 at 12:53 PM Dan Rue <dan.rue@linaro.org> wrote:
> > >
> > > I would say if it's not possible to check at runtime, and it requires
> > > clang 9.0, that this test should not be enabled by default.
> >
> > The latest clang is the requirement.
> > If environment has old clang or no clang at all these tests will be failing.
>
> Hi Alexei!
>
> I'm not certain if I'm interpreting you as you intended, but it sounds
> like you're telling me that if the test build environment does not use
> 'latest clang' (i guess latest as of today?), that these tests will
> fail, and that is how it is going to be. If I have that wrong, please
> correct me and disregard the rest of my message.
>
> Please understand where we are coming from. We (and many others) run
> thousands of tests from a lot of test frameworks, and so our environment
> often has mutually exclusive requirements when it comes to things like
> toolchain selection.
>
> We believe, strongly, that a test should not emit a "fail" for a missing
> requirement. Fail is a serious thing, and should be reserved for an
> actual issue that needs to be investigated, reported, and fixed.
>
> This is how we treat test failures - we investigate, report, and fix
> them when possible. When they're not real failures, we waste our time
> (and yours, in this case).
>
> By adding the tests to TEST_GEN_PROGS, you're adding them to the general
> test set that those of us running test farms try to run continuously
> across a wide range of hardware environments and kernel branches.

you run the latest selftests/bpf on the latest kernel, right?
If not than selftests/bpf is not for your setup.

In the past people argued that selftests/bpf should check
features of the kernel and skip when features are not found.
My answer to that was always the same: such changes to selftests
for older kernels need to live out of tree.
selftests/bpf are one to one to the latest kernel.
Often kernel commit X will break selftests and they're fixed
in the commit X+1.
clang, pahole, bpftool, iproute2 provide those features for the kernel.
In other words new kernel features rely on new clang and
other tools and selftests are testing those latest kernel features.
Without new clang many new features cannot be tested exhaustively.
datasec and btf are just few examples.
Hence if your test farm cannot install the latest clang, pahole, etc then
I recommend not to run selftest/bpf.
