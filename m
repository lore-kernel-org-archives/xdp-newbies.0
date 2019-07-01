Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from conuserg-12.nifty.com ([210.131.2.79]:64182 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGABCZ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 30 Jun 2019 21:02:25 -0400
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 0/7] Compile-test UAPI and kernel headers
Date: Mon,  1 Jul 2019 09:58:38 +0900
Message-Id: <20190701005845.12475-1-yamada.masahiro@socionext.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Joel Fernandes <joel@joelfernandes.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Tony Luck <tony.luck@intel.com>, linux-doc@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, linux-riscv@lists.infradead.org, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Palmer Dabbelt <palmer@sifive.com>, Matthias Brugger <matthias.bgg@gmail.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Michal Marek <michal.lkml@markovi.net>, Jesper Dangaard Brouer <hawk@kernel.org>, Martin KaFai Lau <kafai@fb.com>, linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, Albert Ou <aou@eecs.berkeley.edu>, Colin Cross <ccross@android.com>, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org


1/7: add CONFIG_CC_CAN_LINK to use it in 2/7

2/7: Compile-test exported headers

3/7: Do not generate intermediate wrappers.
     This will avoid header search path issue.

4/7: maybe useful for 7/7 and in some other places.
     Add header-test-pattern-y syntax.

5/7: Minor cleanup of gen_kheaders.sh

6/7: Exclude all files without ".h" extension
     from the kheaders_data.tar.xz
     This will be needed by 7/7 because we need to
     exclude "*.h.s" from the archive

7/7: Compile-test kernel-space headers in include/.


Masahiro Yamada (7):
  init/Kconfig: add CONFIG_CC_CAN_LINK
  kbuild: compile-test exported headers to ensure they are
    self-contained
  kbuild: do not create wrappers for header-test-y
  kbuild: support header-test-pattern-y
  kheaders: remove meaningless -R option of 'ls'
  kheaders: include only headers into kheaders_data.tar.xz
  kbuild: compile-test kernel headers to ensure they are self-contained

 .gitignore                         |    1 -
 Documentation/dontdiff             |    1 -
 Documentation/kbuild/makefiles.txt |   13 +-
 Makefile                           |    4 +-
 include/Kbuild                     | 1253 ++++++++++++++++++++++++++++
 init/Kconfig                       |   24 +
 kernel/gen_kheaders.sh             |   51 +-
 net/bpfilter/Kconfig               |    2 +-
 scripts/Makefile.build             |   10 +-
 scripts/Makefile.lib               |   13 +-
 usr/.gitignore                     |    1 -
 usr/Makefile                       |    2 +
 usr/include/.gitignore             |    3 +
 usr/include/Makefile               |  131 +++
 14 files changed, 1462 insertions(+), 47 deletions(-)
 create mode 100644 include/Kbuild
 create mode 100644 usr/include/.gitignore
 create mode 100644 usr/include/Makefile

-- 
2.17.1
