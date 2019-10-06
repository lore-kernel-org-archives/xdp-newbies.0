Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33362 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfJFGtu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sun, 6 Oct 2019 02:49:50 -0400
MIME-Version: 1.0
References: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
 <20191005192040.20308-1-eric@sage.org>
In-Reply-To: <20191005192040.20308-1-eric@sage.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Sat, 5 Oct 2019 23:49:36 -0700
Message-ID: <CAEf4BzYER-Fzu3=RZFfWJqq83Jx-HYg6nuGYUiszfROLKuje7A@mail.gmail.com>
Subject: Re: samples/bpf not working?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Eric Sage <eric@sage.org>
Cc: Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>

On Sat, Oct 5, 2019 at 12:24 PM Eric Sage <eric@sage.org> wrote:
>
> 394053f4a4b3 ("kbuild: make single targets work more correctly")
> changed the way single target builds work. For example,
> 'make samples/bpf/' in the previous commit matched:
>
> Makefile:1787
> %/: prepare FORCE
>   $(Q)$(MAKE) KBUILD_MODULES=1 $(build)=$(build-dir) need-modorder=1
>
> So that 'samples/bpf/Makefile' was processed directly.
> Commit 394053f4a4b3 removed this rule and now requires that
> 'CONFIG_SAMPLES=y' and that 'bpf/' be added to 'samples/Makefile'
> so it is added to the list of targets processed by the new
> 'ifdef single-build' section of 'scripts/Makefile.build'.
>
> This commit adds a new 'CONFIG_SAMPLE_BPF' under 'CONFIG_SAMPLES' to
> match what the other sample subdirs have done.
>
> Signed-off-by: Eric Sage <eric@sage.org>
> ---

See [0], Björn already attempted this.

  [0] https://lore.kernel.org/bpf/20191001101429.24965-1-bjorn.topel@gmail.com/

>  samples/Kconfig  | 6 ++++++
>  samples/Makefile | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/samples/Kconfig b/samples/Kconfig
> index c8dacb4dda80..396e87ba97e0 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -6,6 +6,12 @@ menuconfig SAMPLES
>
>  if SAMPLES
>
> +config SAMPLE_BPF
> +       tristate "Build bpf examples"
> +       depends on EVENT_TRACING && m
> +       help
> +         This builds the bpf example modules.
> +
>  config SAMPLE_TRACE_EVENTS
>         tristate "Build trace_events examples -- loadable modules only"
>         depends on EVENT_TRACING && m
> diff --git a/samples/Makefile b/samples/Makefile
> index 7d6e4ca28d69..e133a78f3fb8 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -2,6 +2,7 @@
>  # Makefile for Linux samples code
>
>  obj-$(CONFIG_SAMPLE_ANDROID_BINDERFS)  += binderfs/
> +obj-$(CONFIG_SAMPLE_BPF) += bpf/
>  obj-$(CONFIG_SAMPLE_CONFIGFS)          += configfs/
>  obj-$(CONFIG_SAMPLE_CONNECTOR)         += connector/
>  subdir-$(CONFIG_SAMPLE_HIDRAW)         += hidraw
> --
> 2.18.1
>
