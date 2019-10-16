Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-il1-f193.google.com ([209.85.166.193]:42759 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389422AbfJPEVL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 16 Oct 2019 00:21:11 -0400
Received: by mail-il1-f193.google.com with SMTP id o18so1163564ilo.9
        for <xdp-newbies@vger.kernel.org>; Tue, 15 Oct 2019 21:21:10 -0700 (PDT)
Date: Tue, 15 Oct 2019 21:21:04 -0700
From: Eric Sage <eric@sage.org>
Subject: Re: [PATCH] samples/bpf: make xdp_monitor use raw_tracepoints
Message-ID: <20191016042104.GA27738@wizard.attlocal.net>
References: <20191007045726.21467-1-eric@sage.org>
 <20191007110020.6bf8dbc2@carbon>
 <CAEf4BzacEF0Ga921DCuYCVTxR4rFdOzmRt5o0T7HH-H38gEccg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzacEF0Ga921DCuYCVTxR4rFdOzmRt5o0T7HH-H38gEccg@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, brouer@redhat.org, Alexei Starovoitov <ast@kernel.org>, Jiri Olsa <jolsa@redhat.com>

I'm no longer able to build the samples with 'make M=samples/bpf'.

I get errors in task_fd_query_user.c like:

samples/bpf/task_fd_query_user.c:153:29: error: ‘PERF_EVENT_IOC_ENABLE’
undeclared.

Am I missing a dependancy?
