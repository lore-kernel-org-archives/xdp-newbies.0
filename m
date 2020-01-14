Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34201 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbgANHsG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Jan 2020 02:48:06 -0500
Received: by mail-oi1-f194.google.com with SMTP id l136so10972431oig.1
        for <xdp-newbies@vger.kernel.org>; Mon, 13 Jan 2020 23:48:06 -0800 (PST)
MIME-Version: 1.0
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu> <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <87k15vwsax.fsf@toke.dk> <20200113152530.GC68570@smtp.ads.isi.edu> <877e1vwaep.fsf@toke.dk>
In-Reply-To: <877e1vwaep.fsf@toke.dk>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 14 Jan 2020 08:47:54 +0100
Message-ID: <CAJ8uoz2o0gQJOFjSsw3NEJ4vdyKfoLgj=vF3ZTj0v3bbA993qw@mail.gmail.com>
Subject: Re: zero-copy between interfaces
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: Ryan Goodfellow <rgoodfel@isi.edu>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Mon, Jan 13, 2020 at 6:09 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
> Ryan Goodfellow <rgoodfel@isi.edu> writes:
>
> > On Mon, Jan 13, 2020 at 11:43:02AM +0100, Toke Høiland-Jørgensen wrote:
> >>> Magnus Karlsson <magnus.karlsson@gmail.com> writes:
> >>>> On Mon, Jan 13, 2020 at 1:28 AM Ryan Goodfellow <rgoodfel@isi.edu> wrote:
> >>>>  The reason for wanting large memory maps is that our use case for XDP is network
> >>>>  emulation - and sometimes that means introducing delay factors that can require
> >>>>  a rather large in-memory packet buffers.
> >>>>
> >>>>  If there is interest in including this program in the official BPF samples I'm happy to
> >>>>  submit a patch. Any comments on the program are also much appreciated.
> >>>
> >>>  More examples are always useful, but the question is if it should
> >>>  reside in samples or outside the kernel in some other repo? Is there
> >>>  some good place in xdp-project github that could be used for this
> >>>  purpose?
> >>
> >> We could certainly create something; either a new xdp-samples
> >> repository, or an example-programs/ subdir of the xdp-tutorial? Which of
> >> those makes the most sense depends on the size of the program I think...
> >>
> >> -Toke
> >>
> >
> > I'm happy to provide patches or pull-requests in either case. The userspace
> > program is 1 file with 555 lines and the BPF program is 28 lines. I've
> > tested the userspace program with the 5.5 kernel. The BPF program requires
> > clang-9 to work properly (due to BTF features IIRC).
> >
> > - https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5-moa/samples/bpf/xdpsock_multidev.c
> > - https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5-moa/samples/bpf/xdpsock_multidev_kern.c
> >
> > The primary usefulness of this program relative to what's out there is
> > that it pushes packets between interfaces using a common memory map.
>
> Hmm, yeah, this could live in either samples or as standalone. IDK,
> Magnus what do you think?

Let us try the kernel samples first. Then and if the folks on the
mailing list do not want more samples in there, we fall back on the
xdp-tutorial repo.

/Magnus

> -Toke
>
