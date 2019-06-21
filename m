Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43617 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFUFRQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Jun 2019 01:17:16 -0400
MIME-Version: 1.0
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
In-Reply-To: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 20 Jun 2019 22:17:04 -0700
Message-ID: <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, hawk@kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>, Shuah Khan <shuah@kernel.org>

On Thu, Jun 20, 2019 at 1:08 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> selftests: bpf test_libbpf.sh failed running Linux -next kernel
> 20190618 and 20190619.
>
> Here is the log from x86_64,
> # selftests bpf test_libbpf.sh
> bpf: test_libbpf.sh_ #
> # [0] libbpf BTF is required, but is missing or corrupted.

You need at least clang-9.0.0 (not yet released) to run some of these
tests successfully, as they rely on Clang's support for
BTF_KIND_VAR/BTF_KIND_DATASEC.

> libbpf: BTF_is #
> # test_libbpf failed at file test_l4lb.o
> failed: at_file #
> # selftests test_libbpf [FAILED]
> test_libbpf: [FAILED]_ #
> [FAIL] 29 selftests bpf test_libbpf.sh
> selftests: bpf_test_libbpf.sh [FAIL]
>
> Full test log,
> https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log
>
> Test results comparison,
> https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh
>
> Good linux -next tag: next-20190617
> Bad linux -next tag: next-20190618
> git branch     master
> git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
> git repo
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>
> Best regards
> Naresh Kamboju
