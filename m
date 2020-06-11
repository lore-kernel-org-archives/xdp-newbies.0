Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgFKVLe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jun 2020 17:11:34 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C22CC08C5C1
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jun 2020 14:11:34 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id q2so4189256vsr.1
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jun 2020 14:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
 <87imfy7hrx.fsf@toke.dk> <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
 <87a71a7gay.fsf@toke.dk> <CAMDScmnTYKfjMjiqLGduY4Pk3X0D7RQhjtY7DuPmh65VMNeCRw@mail.gmail.com>
 <20200611125952.3527dfdb@carbon> <CAEf4BzafLSnjjqdeH9-Wu7J69a=7_3gmqqDBV8ysTOTmnvmtyw@mail.gmail.com>
 <CAMDScmk+vXCwOYkWhwUcdg95EsCsJNBnM0Jj=nHQLcGPJxiAgw@mail.gmail.com> <CAEf4BzZRd6HU8XWAdTkGggQtcKY+f_Ha2Oe4oeNGCpESGkpq4g@mail.gmail.com>
In-Reply-To: <CAEf4BzZRd6HU8XWAdTkGggQtcKY+f_Ha2Oe4oeNGCpESGkpq4g@mail.gmail.com>
From: Elerion <elerion1000@gmail.com>
Date: Thu, 11 Jun 2020 14:11:21 -0700
Message-ID: <CAMDScm=+UWLw-o1QJj5q2D0EFtdF4hRDzmCgmnzzho_ppJ7cjg@mail.gmail.com>
Subject: Re: Error loading xdp program that worked with bpf_load
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, "iovisor-dev@lists.iovisor.org" <iovisor-dev@lists.iovisor.org>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, Xdp <xdp-newbies@vger.kernel.org>, Yonghong Song <ys114321@gmail.com>

Hello here's some of the basic information, I don't have a minimum
code sample to reproduce the error and I don't really feel inclined to
spend the time to make one since I have already found a solution. I'm
not able to release the production code we are using.

5.3.0-53-generic #47~18.04.1-Ubuntu SMP Thu May 7 13:10:50 UTC 2020
x86_64 x86_64 x86_64 GNU/Linux
Ubuntu clang version
10.0.1-++20200529024103+a634a80615b-1~exp1~20200529124721.169
Target: x86_64-pc-linux-gnu

You can find the discussion here:

https://www.spinics.net/lists/xdp-newbies/msg01730.html

On Thu, Jun 11, 2020 at 1:46 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 11, 2020 at 1:41 PM Elerion <elerion1000@gmail.com> wrote:
> >
> > I am using libbpf from here https://github.com/libbpf/libbpf I'm not
> > using ebpf. I just linked to the ebpf issue because it seems like the
> > only thing related to this problem when I googled it.
>
> Ok, that I can help with, then.
>
> What's the kernel version? Where I can find repro? Steps, etc.
> Basically, a bit more context would help, as I wasn't part of initial
> discussion.
>
>
> >
> > On Thu, Jun 11, 2020 at 9:34 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Jun 11, 2020 at 4:00 AM Jesper Dangaard Brouer
> > > <brouer@redhat.com> wrote:
> > > >
> > > > (Cross-posting to iovisor-dev)
> > > >
> > > > Seeking input from BPF-llvm developers. How come Clang/LLVM 10+ is
> > > > generating incompatible BTF-info in ELF file, and downgrading to LLVM-9
> > > > fixes the issue ?
> > > >
> > > >
> > > > On Wed, 10 Jun 2020 14:50:27 -0700 Elerion <elerion1000@gmail.com> wrote:
> > > >
> > > > > Never mind, I fixed it by downgrading to Clang 9.
> > > > >
> > > > > It appears to be an issue with Clang/LLVM 10+
> > > > >
> > > > > https://github.com/cilium/ebpf/issues/43
> > >
> > > This is newer Clang recording that function is global, not static.
> > > libbpf is sanitizing BTF to remove this flag, if kernel doesn't
> > > support this. But given this is re-implementation of libbpf, that's
> > > probably not happening, right?
> > >
> > > > >
> > > > > On Wed, Jun 10, 2020 at 2:38 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > > > > >
> > > > > > Elerion <elerion1000@gmail.com> writes:
> > > > > >
> > > > > > > [69] FUNC xdp_program type_id=68 vlen != 0
> > > > > >
> > > > > > 'vlen != 0' is the error. Not sure why you hit that; what's the output
> > > > > > of 'bpftool btf dump file yourprog.o' ?
> > > > > >
> > > > > > -Toke
> > > > > >
> > > >
> > > >
> > > > --
> > > > Best regards,
> > > >   Jesper Dangaard Brouer
> > > >   MSc.CS, Principal Kernel Engineer at Red Hat
> > > >   LinkedIn: http://www.linkedin.com/in/brouer
> > > >
