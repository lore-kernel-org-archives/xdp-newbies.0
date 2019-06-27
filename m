Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from conssluserg-04.nifty.com ([210.131.2.83]:45788 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfF0DNP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 26 Jun 2019 23:13:15 -0400
MIME-Version: 1.0
References: <20190627014617.600-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190627014617.600-1-yamada.masahiro@socionext.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Thu, 27 Jun 2019 12:12:30 +0900
Message-ID: <CAK7LNARr7mDaDdh0NxUjYHJCz7Gd9-gFdryWtT224U8KpJ9p3w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Compile-test UAPI and kernel headers
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, linux-riscv@lists.infradead.org, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Palmer Dabbelt <palmer@sifive.com>, Matthias Brugger <matthias.bgg@gmail.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Michal Marek <michal.lkml@markovi.net>, Jesper Dangaard Brouer <hawk@kernel.org>, Martin KaFai Lau <kafai@fb.com>, "moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Albert Ou <aou@eecs.berkeley.edu>, Colin Cross <ccross@android.com>, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Networking <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org

On Thu, Jun 27, 2019 at 10:49 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
>
> 1/4: reworked v2.
>
> 2/4: fix a flaw I noticed when I was working on this series
>
> 3/4: maybe useful for 4/4 and in some other places
>
> 4/4: v2. compile as many headers as possible.
>


If you want to test this series,
please check:

git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
 header-test-v2


> Changes in v2:
>  - Add CONFIG_CPU_{BIG,LITTLE}_ENDIAN guard to avoid build error
>  - Use 'header-test-' instead of 'no-header-test'
>  - Avoid weird 'find' warning when cleaning
>   - New patch
>   - New patch
>   - Add everything to test coverage, and exclude broken ones
>   - Rename 'Makefile' to 'Kbuild'
>   - Add CONFIG_KERNEL_HEADER_TEST option
>
> Masahiro Yamada (4):
>   kbuild: compile-test UAPI headers to ensure they are self-contained
>   kbuild: do not create wrappers for header-test-y
>   kbuild: support header-test-pattern-y
>   kbuild: compile-test kernel headers to ensure they are self-contained
>
>  .gitignore                         |    1 -
>  Documentation/dontdiff             |    1 -
>  Documentation/kbuild/makefiles.txt |   13 +-
>  Makefile                           |    4 +-
>  include/Kbuild                     | 1134 ++++++++++++++++++++++++++++
>  init/Kconfig                       |   22 +
>  scripts/Makefile.build             |   10 +-
>  scripts/Makefile.lib               |   12 +-
>  scripts/cc-system-headers.sh       |    8 +
>  usr/.gitignore                     |    1 -
>  usr/Makefile                       |    2 +
>  usr/include/.gitignore             |    3 +
>  usr/include/Makefile               |  133 ++++
>  13 files changed, 1331 insertions(+), 13 deletions(-)
>  create mode 100644 include/Kbuild
>  create mode 100755 scripts/cc-system-headers.sh
>  create mode 100644 usr/include/.gitignore
>  create mode 100644 usr/include/Makefile
>
> --
> 2.17.1
>


-- 
Best Regards
Masahiro Yamada
