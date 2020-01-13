Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728760AbgAMRJl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 13 Jan 2020 12:09:41 -0500
Received: by mail-lf1-f71.google.com with SMTP id x79so2094695lff.19
        for <xdp-newbies@vger.kernel.org>; Mon, 13 Jan 2020 09:09:38 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: zero-copy between interfaces
In-Reply-To: <20200113152530.GC68570@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu> <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com> <87k15vwsax.fsf@toke.dk> <20200113152530.GC68570@smtp.ads.isi.edu>
Date: Mon, 13 Jan 2020 18:09:34 +0100
Message-ID: <877e1vwaep.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Ryan Goodfellow <rgoodfel@isi.edu>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Ryan Goodfellow <rgoodfel@isi.edu> writes:

> On Mon, Jan 13, 2020 at 11:43:02AM +0100, Toke Høiland-Jørgensen wrote:
>>> Magnus Karlsson <magnus.karlsson@gmail.com> writes:
>>>> On Mon, Jan 13, 2020 at 1:28 AM Ryan Goodfellow <rgoodfel@isi.edu> wrote:
>>>>  The reason for wanting large memory maps is that our use case for XDP is network
>>>>  emulation - and sometimes that means introducing delay factors that can require
>>>>  a rather large in-memory packet buffers.
>>>> 
>>>>  If there is interest in including this program in the official BPF samples I'm happy to
>>>>  submit a patch. Any comments on the program are also much appreciated.
>>> 
>>>  More examples are always useful, but the question is if it should
>>>  reside in samples or outside the kernel in some other repo? Is there
>>>  some good place in xdp-project github that could be used for this
>>>  purpose?
>>
>> We could certainly create something; either a new xdp-samples
>> repository, or an example-programs/ subdir of the xdp-tutorial? Which of
>> those makes the most sense depends on the size of the program I think...
>> 
>> -Toke
>> 
>
> I'm happy to provide patches or pull-requests in either case. The userspace
> program is 1 file with 555 lines and the BPF program is 28 lines. I've 
> tested the userspace program with the 5.5 kernel. The BPF program requires 
> clang-9 to work properly (due to BTF features IIRC).
>
> - https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5-moa/samples/bpf/xdpsock_multidev.c
> - https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5-moa/samples/bpf/xdpsock_multidev_kern.c
>
> The primary usefulness of this program relative to what's out there is
> that it pushes packets between interfaces using a common memory map.

Hmm, yeah, this could live in either samples or as standalone. IDK,
Magnus what do you think?

-Toke
