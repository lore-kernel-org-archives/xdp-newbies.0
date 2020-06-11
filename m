Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgFKQe5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jun 2020 12:34:57 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC2CC08C5C1
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jun 2020 09:34:57 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c14so6127352qka.11
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jun 2020 09:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
 <87imfy7hrx.fsf@toke.dk> <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
 <87a71a7gay.fsf@toke.dk> <CAMDScmnTYKfjMjiqLGduY4Pk3X0D7RQhjtY7DuPmh65VMNeCRw@mail.gmail.com>
 <20200611125952.3527dfdb@carbon>
In-Reply-To: <20200611125952.3527dfdb@carbon>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 11 Jun 2020 09:34:45 -0700
Message-ID: <CAEf4BzafLSnjjqdeH9-Wu7J69a=7_3gmqqDBV8ysTOTmnvmtyw@mail.gmail.com>
Subject: Re: Error loading xdp program that worked with bpf_load
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Elerion <elerion1000@gmail.com>, "iovisor-dev@lists.iovisor.org" <iovisor-dev@lists.iovisor.org>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, Xdp <xdp-newbies@vger.kernel.org>, Yonghong Song <ys114321@gmail.com>

On Thu, Jun 11, 2020 at 4:00 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> (Cross-posting to iovisor-dev)
>
> Seeking input from BPF-llvm developers. How come Clang/LLVM 10+ is
> generating incompatible BTF-info in ELF file, and downgrading to LLVM-9
> fixes the issue ?
>
>
> On Wed, 10 Jun 2020 14:50:27 -0700 Elerion <elerion1000@gmail.com> wrote:
>
> > Never mind, I fixed it by downgrading to Clang 9.
> >
> > It appears to be an issue with Clang/LLVM 10+
> >
> > https://github.com/cilium/ebpf/issues/43

This is newer Clang recording that function is global, not static.
libbpf is sanitizing BTF to remove this flag, if kernel doesn't
support this. But given this is re-implementation of libbpf, that's
probably not happening, right?

> >
> > On Wed, Jun 10, 2020 at 2:38 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > >
> > > Elerion <elerion1000@gmail.com> writes:
> > >
> > > > [69] FUNC xdp_program type_id=68 vlen != 0
> > >
> > > 'vlen != 0' is the error. Not sure why you hit that; what's the output
> > > of 'bpftool btf dump file yourprog.o' ?
> > >
> > > -Toke
> > >
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
