Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f47.google.com ([209.85.167.47]:46999 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfJSQMI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 19 Oct 2019 12:12:08 -0400
Received: by mail-lf1-f47.google.com with SMTP id t8so6897811lfc.13
        for <xdp-newbies@vger.kernel.org>; Sat, 19 Oct 2019 09:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <CACCo2jk9rx3sf78RPFr39-JVZgaymsJVd6vg=WMKLmWfYZrNaA@mail.gmail.com>
In-Reply-To: <CACCo2jk9rx3sf78RPFr39-JVZgaymsJVd6vg=WMKLmWfYZrNaA@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sat, 19 Oct 2019 09:11:54 -0700
Message-ID: <CAADnVQ+X-Fz68XkLPDVBntkcboMoXGg_ArCKMzeeEqfQmvRx-g@mail.gmail.com>
Subject: Re: sharing a simple ebpf code sample
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Sat, Oct 19, 2019 at 2:37 AM Farid Zakaria <farid.m.zakaria@gmail.com> wrote:
>
> Hi,
>
> I just wanted to share a code sample I put together which does
> MPLSinIP encap/decap via clasct (not xdp).
>
> https://github.com/fzakaria/ebpf-mpls-encap-decap
>
> I know there's quite a few samples in the Linux source tree but I
> found them lacking in terms of comments for someone new to the new
> space.
> (They were more geared at demonstrating a particular feature
> specifically rather than simply instructional)
>
> Learning & using ebpf for a project at work in a similar capacity
> (encap/decap) has been a joy/fun to work with.

Thanks for sharing.
I think we can create new bpf_examples_and_links.rst file in Documentation/bpf/
with links for various repos, samples, examples, etc
Like yours, cilium, cloudflare, Jesper's docs, etc.
At least from kernel tree all the places will be reachable.
