Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f54.google.com ([209.85.167.54]:39810 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFTIIF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 20 Jun 2019 04:08:05 -0400
Received: by mail-lf1-f54.google.com with SMTP id p24so1739951lfo.6
        for <xdp-newbies@vger.kernel.org>; Thu, 20 Jun 2019 01:08:04 -0700 (PDT)
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Jun 2019 13:37:52 +0530
Message-ID: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
Subject: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, bpf@vger.kernel.org, Netdev <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, xdp-newbies@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, kafai@fb.com, Yonghong Song <yhs@fb.com>, john.fastabend@gmail.com, hawk@kernel.org, jakub.kicinski@netronome.com, Shuah Khan <shuah@kernel.org>

selftests: bpf test_libbpf.sh failed running Linux -next kernel
20190618 and 20190619.

Here is the log from x86_64,
# selftests bpf test_libbpf.sh
bpf: test_libbpf.sh_ #
# [0] libbpf BTF is required, but is missing or corrupted.
libbpf: BTF_is #
# test_libbpf failed at file test_l4lb.o
failed: at_file #
# selftests test_libbpf [FAILED]
test_libbpf: [FAILED]_ #
[FAIL] 29 selftests bpf test_libbpf.sh
selftests: bpf_test_libbpf.sh [FAIL]

Full test log,
https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log

Test results comparison,
https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh

Good linux -next tag: next-20190617
Bad linux -next tag: next-20190618
git branch     master
git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
git repo
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Best regards
Naresh Kamboju
