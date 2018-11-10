Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f178.google.com ([209.85.222.178]:33023 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbeKKAQe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 10 Nov 2018 19:16:34 -0500
Received: by mail-qk1-f178.google.com with SMTP id o89so6586962qko.0
        for <xdp-newbies@vger.kernel.org>; Sat, 10 Nov 2018 06:31:21 -0800 (PST)
MIME-Version: 1.0
References: <ad85176a72e82878a4073a4215aa5e3a@igalia.com> <CAJ+HfNjfCNt+M+=bJe60JOPmTJ9q=cvf6DCC=FK0aNdY-6po5g@mail.gmail.com>
 <a0c74144c8f15c10991f9cc15e8f7343@igalia.com>
In-Reply-To: <a0c74144c8f15c10991f9cc15e8f7343@igalia.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Sat, 10 Nov 2018 15:31:08 +0100
Message-ID: <CAJ+HfNhdtpqQHPq8=DTtwduL-g6SQT01JZsEWmCQQeLUhXRh8w@mail.gmail.com>
Subject: Re: AF_XDP socket (sock2) unable to read, after writing with another
 AF_XDP socket (sock1)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: kdjimeli@igalia.com
Cc: xdp-newbies@vger.kernel.org

Den tors 8 nov. 2018 kl 16:15 skrev Konrad Djimeli <kdjimeli@igalia.com>:
>
[...]
> > In terms of correctness:
> >
> > In 3. you pass the same UMEM indicies to the Tx ring (ids=3D{0,
> > FRAME_SIZE, 2*FRAME_SIZE, ...}), as you have passed to the fill
> > ring. This is not correct. Userspace to track what ids are owned by
> > the user and by the kernel. Now, both the fill ring and Tx ring
> > contain the same id.
> Please I have been looking into this for some days now, but I have not
> been able to understand what you where referring to and how to fix it.
>

Ok, let's talk about the basics, and hopefully it will clear up. The
indicies/ids into the UMEM are used to point out packet buffers.

The Rx/Tx/Completion/Fill rings are used to pass ownership between the
kernel and the user application. E.g. if fill id X with data and pass
that to the kernel for transmission, the application has passed
ownership of buffer X to the kernel. The application cannot (well,
shouldn't) touch the buffer pointed out by X until the kernel is done
with the buffer -- in other words, when the buffer is passed back to
the application via the completion ring. Analogous, when you pass id Y
to the fill ring, Y is owned by the kernel. The application cannot
(again, shouldn't) touch the data pointed out by Y until ownership is
passed back to the application via the Rx ring.

What you did in your old code (I haven't looked at your updates!) is
that you passed X, Y and Z to the fill ring. And then, prior obtaining
ownership of the buffers, you passed X, Y and Z to the Tx ring.

> I also updated the xdp program bpf_redirect_map index to write to the
> second socket (sock2) but I can not observe the reading working when I
> use any other networking interface except for the 'lo' interface. I
> would like to inquire if it may have something to do with the code.
> - https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_kern.c
> - https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_user.c
>

If you rely on that all sent packets out to a certain interface should
be hairpinned back to same interface, you need to set that up in your
switching plane. Or continue to use the loopback interface as you
do(?).


Bj=C3=B6rn


> Thanks
> Konrad
>
> >
> > I'm not sure what the expected output of your program should be? Have
> > you verified that packets are being sent? Is the inferface/queue 0
> > receiving packets?
> >
> > I think it would help if you explained what you are trying to do
> > first!
> >
> > What XDP program are you running?
> >
> >
> > Cheers,
> > Bj=C3=B6rn
> >
> >
> >
> > *
> >
> >> Thanks,
> >> Konrad
> >> www.djimeli.me
