Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726407AbgFKLAK (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jun 2020 07:00:10 -0400
Date: Thu, 11 Jun 2020 12:59:52 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Error loading xdp program that worked with bpf_load
Message-ID: <20200611125952.3527dfdb@carbon>
In-Reply-To: <CAMDScmnTYKfjMjiqLGduY4Pk3X0D7RQhjtY7DuPmh65VMNeCRw@mail.gmail.com>
References: <CAMDScmnpbPgs+mB_aMY16aXLMMWBgfu0sqna06MH8RPoGpw7_Q@mail.gmail.com>
        <87imfy7hrx.fsf@toke.dk>
        <CAMDScmm5nCzeffaeEuSFHATunsH36XW2VzbsFCuWhU5OYr_naA@mail.gmail.com>
        <87a71a7gay.fsf@toke.dk>
        <CAMDScmnTYKfjMjiqLGduY4Pk3X0D7RQhjtY7DuPmh65VMNeCRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Elerion <elerion1000@gmail.com>, "iovisor-dev@lists.iovisor.org" <iovisor-dev@lists.iovisor.org>
Cc: brouer@redhat.com, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>, xdp-newbies@vger.kernel.org, Andrii Nakryiko <andrii.nakryiko@gmail.com>, Yonghong Song <ys114321@gmail.com>

(Cross-posting to iovisor-dev)

Seeking input from BPF-llvm developers. How come Clang/LLVM 10+ is
generating incompatible BTF-info in ELF file, and downgrading to LLVM-9
fixes the issue ?


On Wed, 10 Jun 2020 14:50:27 -0700 Elerion <elerion1000@gmail.com> wrote:

> Never mind, I fixed it by downgrading to Clang 9.
> 
> It appears to be an issue with Clang/LLVM 10+
> 
> https://github.com/cilium/ebpf/issues/43
> 
> On Wed, Jun 10, 2020 at 2:38 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >
> > Elerion <elerion1000@gmail.com> writes:
> >  
> > > [69] FUNC xdp_program type_id=68 vlen != 0  
> >
> > 'vlen != 0' is the error. Not sure why you hit that; what's the output
> > of 'bpftool btf dump file yourprog.o' ?
> >
> > -Toke
> >  


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
