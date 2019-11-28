Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f178.google.com ([209.85.208.178]:42256 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfK1SSc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Nov 2019 13:18:32 -0500
MIME-Version: 1.0
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
In-Reply-To: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 28 Nov 2019 10:18:18 -0800
Message-ID: <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Eelco Chaudron <echaudro@redhat.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Thu, Nov 28, 2019 at 9:20 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Trying out the BPF trace to trace a BPF program, but I’m already
> getting stuck loading the object with the fexit  :(

I can take a look after holidays.

> libbpf: load bpf program failed: Argument list too long
> libbpf: failed to load program 'fexit/xdp_prog_simple'
> libbpf: failed to load object './xdp_sample_fentry_fexit_kern.o'
> ERROR: Failed to load object file: Operation not permitted

please add -vvv and share full output.
