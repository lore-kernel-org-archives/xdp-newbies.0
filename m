Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f178.google.com ([209.85.214.178]:44208 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUS76 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Oct 2019 14:59:58 -0400
Received: by mail-pl1-f178.google.com with SMTP id q15so7065688pll.11
        for <xdp-newbies@vger.kernel.org>; Mon, 21 Oct 2019 11:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <CACCo2jk9rx3sf78RPFr39-JVZgaymsJVd6vg=WMKLmWfYZrNaA@mail.gmail.com>
 <CAADnVQ+X-Fz68XkLPDVBntkcboMoXGg_ArCKMzeeEqfQmvRx-g@mail.gmail.com>
In-Reply-To: <CAADnVQ+X-Fz68XkLPDVBntkcboMoXGg_ArCKMzeeEqfQmvRx-g@mail.gmail.com>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Mon, 21 Oct 2019 11:59:46 -0700
Message-ID: <CACCo2j=fFm+FRix4CW+wubZ8h+iLW6s4fNnjjpDK4hXRy2nK1w@mail.gmail.com>
Subject: Re: sharing a simple ebpf code sample
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, Mark Williams <mrw@enotuniq.org>

On Sat, Oct 19, 2019 at 9:12 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> snip.
>
> Thanks for sharing.
> I think we can create new bpf_examples_and_links.rst file in Documentation/bpf/
> with links for various repos, samples, examples, etc
> Like yours, cilium, cloudflare, Jesper's docs, etc.
> At least from kernel tree all the places will be reachable.

That's a great idea. I know there is
https://github.com/zoidbergwill/awesome-ebpf however having something
maintained in the kernel would preferable I think.
eBPF is interesting because it empowers some user-space developers to
work on code that "looks" kernel like, so I think there is opportunity
to expand on the documentation for that segment.

I will also be attending the LLVM developer conference this week in
San Jose -- if anyone from this mailing list is there I hope to meet
you.
