Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbfJPNee (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 16 Oct 2019 09:34:34 -0400
Date: Wed, 16 Oct 2019 15:34:26 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] samples/bpf: make xdp_monitor use raw_tracepoints
Message-ID: <20191016153426.1d976f17@carbon>
In-Reply-To: <20191016042104.GA27738@wizard.attlocal.net>
References: <20191007045726.21467-1-eric@sage.org>
        <20191007110020.6bf8dbc2@carbon>
        <CAEf4BzacEF0Ga921DCuYCVTxR4rFdOzmRt5o0T7HH-H38gEccg@mail.gmail.com>
        <20191016042104.GA27738@wizard.attlocal.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Sage <eric@sage.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, brouer@redhat.org, Alexei Starovoitov <ast@kernel.org>, Jiri Olsa <jolsa@redhat.com>, brouer@redhat.com

On Tue, 15 Oct 2019 21:21:04 -0700
Eric Sage <eric@sage.org> wrote:

> I'm no longer able to build the samples with 'make M=samples/bpf'.
> 
> I get errors in task_fd_query_user.c like:
> 
> samples/bpf/task_fd_query_user.c:153:29: error: ‘PERF_EVENT_IOC_ENABLE’
> undeclared.
> 
> Am I missing a dependancy?

Have you remembered to run:

 make headers_install

(As described in samples/bpf/README)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
