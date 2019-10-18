Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44173 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392487AbfJRL7n (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 18 Oct 2019 07:59:43 -0400
Received: by mail-ot1-f68.google.com with SMTP id 21so4692197otj.11
        for <xdp-newbies@vger.kernel.org>; Fri, 18 Oct 2019 04:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAHApi-mbMMx5bhdyfoLuiw7V3qML3L8f+N-+ReQ9XmAKH_2q8A@mail.gmail.com>
 <CAHApi-mwp8ZjoC9MavMbzKSdEi9c2js-cD1+Qr8nzJF-P-Sz9g@mail.gmail.com> <CAJ8uoz2HYH3rWLX2zEOgZRyLioO7+JmXpH8wW6DFfi=VjTvCoA@mail.gmail.com>
In-Reply-To: <CAJ8uoz2HYH3rWLX2zEOgZRyLioO7+JmXpH8wW6DFfi=VjTvCoA@mail.gmail.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Fri, 18 Oct 2019 13:59:31 +0200
Message-ID: <CAJ8uoz1T_xs3+wuLQOB3vAeui4coxd0Etqto2ZUCEjONTo9X+A@mail.gmail.com>
Subject: Re: i40e: Kernel freezes with XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kal Cutter Conley <kal.conley@dectris.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

I have managed to reproduce and root cause it. Will produce a patch.
Thanks for finding this issue.

/Magnus

On Fri, Oct 18, 2019 at 1:23 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> Thanks Kal. Will take a look at it and get back.
>
> /Magnus
>
> On Fri, Oct 18, 2019 at 12:18 PM Kal Cutter Conley
> <kal.conley@dectris.com> wrote:
> >
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
> > >
> > > Hello,
> > > I am trying to get AF_XDP working with the i40e driver (Ethernet
> > > Controller X710 for 10GbE SFP+). After bind() with XDP_ZEROCOPY the
> > > kernel (machine) freezes hard. I have reproduced this on varying
> > > kernel versions between 5.1 and 5.3-rc3 with 5.3 kernels freezing
> > > also, but at a later stage. I tried replacing my XDP program with a
> > > trivial one that simply returns XDP_PASS but it didn't help. On the
> > > same system, the xdpsock sample does appear to work with the -z flag,
> > > however. Are there any current known issues that could be causing
> > > this? I will try to extract a minimal example that exercises the
> > > freeze.
> > >
> > > Thanks,
> > > Kal
