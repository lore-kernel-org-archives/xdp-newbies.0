Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43876 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeKKAoj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 10 Nov 2018 19:44:39 -0500
Received: by mail-qk1-f194.google.com with SMTP id r71so6646664qkr.10
        for <xdp-newbies@vger.kernel.org>; Sat, 10 Nov 2018 06:59:21 -0800 (PST)
MIME-Version: 1.0
References: <ad85176a72e82878a4073a4215aa5e3a@igalia.com> <CAJ+HfNjfCNt+M+=bJe60JOPmTJ9q=cvf6DCC=FK0aNdY-6po5g@mail.gmail.com>
 <a0c74144c8f15c10991f9cc15e8f7343@igalia.com> <CAJ+HfNhdtpqQHPq8=DTtwduL-g6SQT01JZsEWmCQQeLUhXRh8w@mail.gmail.com>
In-Reply-To: <CAJ+HfNhdtpqQHPq8=DTtwduL-g6SQT01JZsEWmCQQeLUhXRh8w@mail.gmail.com>
From: William Tu <u9012063@gmail.com>
Date: Sat, 10 Nov 2018 06:58:41 -0800
Message-ID: <CALDO+SbRNLSYpwOG4TS_72E81rnsmYwmYfBKC8nTsJxHjQrLyg@mail.gmail.com>
Subject: Re: AF_XDP socket (sock2) unable to read, after writing with another
 AF_XDP socket (sock1)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc: kdjimeli@igalia.com, Xdp <xdp-newbies@vger.kernel.org>

On Sat, Nov 10, 2018 at 6:31 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> Den tors 8 nov. 2018 kl 16:15 skrev Konrad Djimeli <kdjimeli@igalia.com>:
> >
> [...]
> > > In terms of correctness:
> > >
> > > In 3. you pass the same UMEM indicies to the Tx ring (ids=3D{0,
> > > FRAME_SIZE, 2*FRAME_SIZE, ...}), as you have passed to the fill
> > > ring. This is not correct. Userspace to track what ids are owned by
> > > the user and by the kernel. Now, both the fill ring and Tx ring
> > > contain the same id.
> > Please I have been looking into this for some days now, but I have not
> > been able to understand what you where referring to and how to fix it.
> >
>
> Ok, let's talk about the basics, and hopefully it will clear up. The
> indicies/ids into the UMEM are used to point out packet buffers.
>
> The Rx/Tx/Completion/Fill rings are used to pass ownership between the
> kernel and the user application. E.g. if fill id X with data and pass
> that to the kernel for transmission, the application has passed
> ownership of buffer X to the kernel. The application cannot (well,
> shouldn't) touch the buffer pointed out by X until the kernel is done
> with the buffer -- in other words, when the buffer is passed back to
> the application via the completion ring. Analogous, when you pass id Y
> to the fill ring, Y is owned by the kernel. The application cannot
> (again, shouldn't) touch the data pointed out by Y until ownership is
> passed back to the application via the Rx ring.
>

Hi Konrad,

I made a slide about using how the rx/tx/completion/fill ring works for OVS=
.
Hope this is helpful for you.
https://drive.google.com/open?id=3D1gM3lndS6WeS16QNk74L22UNx5D5wlS2o

Another thing for debugging is first to add a print in the XDP code,
so making sure the packet is there at the XDP layer.
https://github.com/williamtu/ovs-ebpf/blob/afxdp-array/bpf/xdp.h#L71

Then I usually prints the xsk stats
https://github.com/williamtu/ovs-ebpf/blob/afxdp-array/lib/netdev-linux.c#L=
656
So making sure I'm not mess up with these rings.

Regards,
William
