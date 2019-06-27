Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:32844 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfF0Lgp (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 27 Jun 2019 07:36:45 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH v2 0/4] Compile-test UAPI and kernel headers
In-Reply-To: <20190627014617.600-1-yamada.masahiro@socionext.com>
References: <20190627014617.600-1-yamada.masahiro@socionext.com>
Date: Thu, 27 Jun 2019 14:39:24 +0300
Message-ID: <87y31np89f.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>, linux-doc@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, linux-riscv@lists.infradead.org, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Palmer Dabbelt <palmer@sifive.com>, Matthias Brugger <matthias.bgg@gmail.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Michal Marek <michal.lkml@markovi.net>, Jesper Dangaard Brouer <hawk@kernel.org>, Martin KaFai Lau <kafai@fb.com>, linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, Albert Ou <aou@eecs.berkeley.edu>, Colin Cross <ccross@android.com>, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

On Thu, 27 Jun 2019, Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
> 1/4: reworked v2.
>
> 2/4: fix a flaw I noticed when I was working on this series
>
> 3/4: maybe useful for 4/4 and in some other places
>
> 4/4: v2. compile as many headers as possible.
>
>
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

[responding here because I didn't receive the actual patch]

This looks like it's doing what it's supposed to, but I ran into a bunch
of build fails with CONFIG_OF=n. Sent a fix to one [1], but stopped at
the next. Looks like you'll have to exclude more. And I'm pretty sure
we'll uncover more configurations where this will fail.

But I do applaud the goal, and I'm committed to making all include/drm
headers self-contained. I wouldn't block this based on the issues, it's
pretty much the only way to expose them and get them fixed/excluded, and
it's behind a config knob after all.

With the caveat that I didn't finish the build, but OTOH tested the
rainy day scenario and had the patch find issues it's meant to find:

Tested-by: Jani Nikula <jani.nikula@intel.com>


[1] http://patchwork.freedesktop.org/patch/msgid/20190627110103.7539-1-jani.nikula@intel.com

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

-- 
Jani Nikula, Intel Open Source Graphics Center
