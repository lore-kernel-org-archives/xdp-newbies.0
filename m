Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38964 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfJPEFb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 16 Oct 2019 00:05:31 -0400
MIME-Version: 1.0
References: <20191007045726.21467-1-eric@sage.org> <20191007110020.6bf8dbc2@carbon>
In-Reply-To: <20191007110020.6bf8dbc2@carbon>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 15 Oct 2019 21:05:18 -0700
Message-ID: <CAEf4BzacEF0Ga921DCuYCVTxR4rFdOzmRt5o0T7HH-H38gEccg@mail.gmail.com>
Subject: Re: [PATCH] samples/bpf: make xdp_monitor use raw_tracepoints
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Eric Sage <eric@sage.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, brouer@redhat.org, Alexei Starovoitov <ast@kernel.org>, Jiri Olsa <jolsa@redhat.com>

On Mon, Oct 7, 2019 at 2:00 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>
> On Mon,  7 Oct 2019 04:57:26 +0000 Eric Sage <eric@sage.org> wrote:
>
> > raw_tracepoints are an eBPF alternative to standard tracepoints which
> > attach to a tracepoint without the perf layer being executed, making
> > them faster.
> >
> > Since xdp_monitor is supposed to have as little impact on the system as
> > possible it is switched to using them by append raw_ to the SEC names.
> >
> > There was also a small issues with 'samples/bpf/bpf_load' - it was
> > loading the raw_tracepoints with the tracing subsystem name still
> > attached, which the bpf syscall rejects with a No such file or directory
> > error. This is now fixed.
> >
> > Signed-off-by: Eric Sage <eric@sage.org>
> > ---
> >  samples/bpf/bpf_load.c         |  5 +++--
> >  samples/bpf/xdp_monitor_kern.c | 26 +++++++++++++-------------
> >  2 files changed, 16 insertions(+), 15 deletions(-)
>
> If there is an issue in the loader 'samples/bpf/bpf_load.c' then we
> should of-cause fix it, but you should be aware that we are in general
> trying to deprecate this loader, and we want to convert users over to
> libbpf.
>
> This patch seems like a good first step forward.  Longer term, I would
> like to see this converted into using libbpf.  The library are missing
> attach helpers for regular tracepoints, but for raw_tracepoints it does
> contain bpf_raw_tracepoint_open().

libbpf has both bpf_program__attach_tracepoint() and
bpf_program__attach_raw_tracepoint(), please use them, not lower-level
bpf_raw_tracepoint_open(). See selftests/bpf/prog_tests/attach_probe.c
for examples.

>
> You can see an example of how xdp_monitor have been converted into
> using libbpf and raw_tracepoints here (by Jiri Olsa):
>
>  https://github.com/xdp-project/xdp-tutorial/blob/master/tracing02-xdp-monitor/trace_prog_kern.c
>
>

[...]
