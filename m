Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44026 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409617AbfJRHGT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 18 Oct 2019 03:06:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id j18so4965005wrq.10
        for <xdp-newbies@vger.kernel.org>; Fri, 18 Oct 2019 00:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAHApi-mbMMx5bhdyfoLuiw7V3qML3L8f+N-+ReQ9XmAKH_2q8A@mail.gmail.com>
 <CAHApi-mwp8ZjoC9MavMbzKSdEi9c2js-cD1+Qr8nzJF-P-Sz9g@mail.gmail.com> <10b8a1a6-5b59-7226-df49-ec902d6c3261@yandex.ru>
In-Reply-To: <10b8a1a6-5b59-7226-df49-ec902d6c3261@yandex.ru>
From: Kal Cutter Conley <kal.conley@dectris.com>
Date: Fri, 18 Oct 2019 09:06:06 +0200
Message-ID: <CAHApi-migoMstZZ5x2zE8b8P+SPkuD_+FVaXQq0HfU3N5Coudg@mail.gmail.com>
Subject: Re: i40e: Kernel freezes with XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ilya Goslhtein <ilejn@yandex.ru>
Cc: xdp-newbies@vger.kernel.org

Hello Ilya,
The processes are created in serial (parent waits for each child to
exit). I only use fork() to avoid clean-up code. Sorry for the
confusion!

Kal

On Fri, Oct 18, 2019 at 12:56 AM Ilya Goslhtein <ilejn@yandex.ru> wrote:
>
> Hello Kal,
>
> I've noticed that all created processes in your code snippet bound to
> the same queue without SHARED flag.
>
> Is it supposed to work?
>
> Thanks.
>
> On 17.10.2019 11:53, Kal Cutter Conley wrote:
> > Hello,
> > I have managed to extract a reproducer that crashes the kernel. We
> > observe the crash with all drivers that support XDP zerocopy (i40e,
> > ixgbe, mlx5_core). The program source is attached (C++). Compile with
> > a newer clang++ or g++ using flag -std=c++17. It must also be linked
> > with libbpf. Use libbpf v0.0.5 and make sure to revert
> > 5771dacd3dc2fdd041c51242819a9f212e04af55.
> >
> > The crash is a kernel NULL pointer dereference in xsk_umem_consume_tx.
> >
> > Hopefully this is useful,
> > Kal
> >
> > On Wed, Aug 7, 2019 at 10:48 PM Kal Cutter Conley
> > <kal.conley@dectris.com> wrote:
> >> Hello,
> >> I am trying to get AF_XDP working with the i40e driver (Ethernet
> >> Controller X710 for 10GbE SFP+). After bind() with XDP_ZEROCOPY the
> >> kernel (machine) freezes hard. I have reproduced this on varying
> >> kernel versions between 5.1 and 5.3-rc3 with 5.3 kernels freezing
> >> also, but at a later stage. I tried replacing my XDP program with a
> >> trivial one that simply returns XDP_PASS but it didn't help. On the
> >> same system, the xdpsock sample does appear to work with the -z flag,
> >> however. Are there any current known issues that could be causing
> >> this? I will try to extract a minimal example that exercises the
> >> freeze.
> >>
> >> Thanks,
> >> Kal
>
> --
> Best regards,
> Ilya Golshtein
>
