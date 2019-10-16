Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39053 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388005AbfJPP5H (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 16 Oct 2019 11:57:07 -0400
Received: by mail-oi1-f193.google.com with SMTP id w144so20476821oia.6
        for <xdp-newbies@vger.kernel.org>; Wed, 16 Oct 2019 08:57:07 -0700 (PDT)
Date: Wed, 16 Oct 2019 08:57:01 -0700
From: Eric Sage <eric@sage.org>
Subject: Re: [PATCH] samples/bpf: make xdp_monitor use raw_tracepoints
Message-ID: <20191016155701.GA18708@wizard.attlocal.net>
References: <20191007045726.21467-1-eric@sage.org>
 <20191007110020.6bf8dbc2@carbon>
 <CAEf4BzacEF0Ga921DCuYCVTxR4rFdOzmRt5o0T7HH-H38gEccg@mail.gmail.com>
 <20191016042104.GA27738@wizard.attlocal.net>
 <20191016153426.1d976f17@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191016153426.1d976f17@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Jiri Olsa <jolsa@redhat.com>

On Wed, Oct 16, 2019 at 03:34:26PM +0200, Jesper Dangaard Brouer wrote:
> On Tue, 15 Oct 2019 21:21:04 -0700
> Eric Sage <eric@sage.org> wrote:
> 
> > I'm no longer able to build the samples with 'make M=samples/bpf'.
> > 
> > I get errors in task_fd_query_user.c like:
> > 
> > samples/bpf/task_fd_query_user.c:153:29: error: ‘PERF_EVENT_IOC_ENABLE’
> > undeclared.
> > 
> > Am I missing a dependancy?
> 
> Have you remembered to run:
> 
>  make headers_install
> 
> (As described in samples/bpf/README)

Yes, I've done that. I've tried:

  make mrproper
  cp /boot/config-5.2.18-200.fc30.x86_64 .config
  make olddefconfig
  make headers_install
  make M=samples/bpf

which ends with the errors I described.
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
