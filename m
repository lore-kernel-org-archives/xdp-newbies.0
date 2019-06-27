Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from conssluserg-06.nifty.com ([210.131.2.91]:22715 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfF0Qm5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 27 Jun 2019 12:42:57 -0400
MIME-Version: 1.0
References: <20190627014617.600-1-yamada.masahiro@socionext.com> <87y31np89f.fsf@intel.com>
In-Reply-To: <87y31np89f.fsf@intel.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 28 Jun 2019 01:42:00 +0900
Message-ID: <CAK7LNAS=Uhyq9AitSqRR2aKOg18aae8Ce9FXTufgJq3KNhmsUg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Compile-test UAPI and kernel headers
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Tony Luck <tony.luck@intel.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, linux-riscv@lists.infradead.org, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Palmer Dabbelt <palmer@sifive.com>, Matthias Brugger <matthias.bgg@gmail.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Michal Marek <michal.lkml@markovi.net>, Jesper Dangaard Brouer <hawk@kernel.org>, Martin KaFai Lau <kafai@fb.com>, "moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Albert Ou <aou@eecs.berkeley.edu>, Colin Cross <ccross@android.com>, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Networking <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org

On Thu, Jun 27, 2019 at 8:36 PM Jani Nikula <jani.nikula@linux.intel.com> wrote:
>
> On Thu, 27 Jun 2019, Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
> > 1/4: reworked v2.
> >
> > 2/4: fix a flaw I noticed when I was working on this series
> >
> > 3/4: maybe useful for 4/4 and in some other places
> >
> > 4/4: v2. compile as many headers as possible.
> >
> >
> > Changes in v2:
> >  - Add CONFIG_CPU_{BIG,LITTLE}_ENDIAN guard to avoid build error
> >  - Use 'header-test-' instead of 'no-header-test'
> >  - Avoid weird 'find' warning when cleaning
> >   - New patch
> >   - New patch
> >   - Add everything to test coverage, and exclude broken ones
> >   - Rename 'Makefile' to 'Kbuild'
> >   - Add CONFIG_KERNEL_HEADER_TEST option
> >
> > Masahiro Yamada (4):
> >   kbuild: compile-test UAPI headers to ensure they are self-contained
> >   kbuild: do not create wrappers for header-test-y
> >   kbuild: support header-test-pattern-y
> >   kbuild: compile-test kernel headers to ensure they are self-contained
>
> [responding here because I didn't receive the actual patch]
>
> This looks like it's doing what it's supposed to, but I ran into a bunch
> of build fails with CONFIG_OF=n. Sent a fix to one [1], but stopped at
> the next. Looks like you'll have to exclude more. And I'm pretty sure
> we'll uncover more configurations where this will fail.

Thanks for testing.

I did more compile-tests, and excluded more headers in v3.

Thanks.



-- 
Best Regards
Masahiro Yamada
