Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f180.google.com ([209.85.222.180]:33582 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbeKCRsr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 3 Nov 2018 13:48:47 -0400
MIME-Version: 1.0
References: <ad85176a72e82878a4073a4215aa5e3a@igalia.com> <CAJ+HfNjfCNt+M+=bJe60JOPmTJ9q=cvf6DCC=FK0aNdY-6po5g@mail.gmail.com>
 <8426e910a7d4900c1530ece07600eb8c@igalia.com>
In-Reply-To: <8426e910a7d4900c1530ece07600eb8c@igalia.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Sat, 3 Nov 2018 09:38:00 +0100
Message-ID: <CAJ+HfNjftkB9uSA8+jzNgT1KO9tGPMZJ2COcugCtFmv1ziCZgQ@mail.gmail.com>
Subject: Re: AF_XDP socket (sock2) unable to read, after writing with another
 AF_XDP socket (sock1)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: kdjimeli@igalia.com
Cc: xdp-newbies@vger.kernel.org, xdp-newbies-owner@vger.kernel.org

Den fre 2 nov. 2018 kl 17:08 skrev Konrad Djimeli <kdjimeli@igalia.com>:
>
> On 2018-11-01 19:49, Bj=C3=B6rn T=C3=B6pel wrote:
> > Den tors 1 nov. 2018 kl 18:14 skrev Konrad Djimeli <kdjimeli@igalia.com=
>:
> >>
> >> Hello,
> >>
> >> I am working on developing a Snabb Switch app which uses Af_XDP socket=
s
> >> and so far I have not found any AF_XDP sample example online, except f=
or
> >> the sample in the Linux Kernel source. I have tried modifying the
> >> example, to create two sockets (sock1 and sock2) sharing a UMEM with
> >> custom write_sock and read_sock functions. But when I do a write with
> >> "sock1" I am unable to read the data with "sock2". Here is the code
> >> https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_user.c ,
> >> and I am new to working with AF_XDP sockets and I wish I could get som=
e
> >> pointers to what may be wrong with the program.
> >>
> >
> > Hi Konrad,
> >
> > Let's recap what your application does:
> >
> > 1. Create two AF_XDP sockets bound to ifindex and a shared UMEM.
> > 2. The pass NUM_DESCS descriptors to the UMEM fill ring
> > 3. In write_sock BATCH_SIZE packets are put on the Tx ring.
> > 4. In read_sock up to BATCH_SIZE packets are picked from the Rx ring.
> > 5. The application exits.
> >
> > In terms of correctness:
> >
> > In 3. you pass the same UMEM indicies to the Tx ring (ids=3D{0,
> > FRAME_SIZE, 2*FRAME_SIZE, ...}), as you have passed to the fill
> > ring. This is not correct. Userspace to track what ids are owned by
> > the user and by the kernel. Now, both the fill ring and Tx ring
> > contain the same id.
>
> Hello Bj=C3=B6rn,
>
> Thanks for taking time to go through the program in detail and providing
> feedback.
>
> >
> > I'm not sure what the expected output of your program should be? Have
> > you verified that packets are being sent? Is the inferface/queue 0
> > receiving packets?
>
> Since I am calling the hex_dump(...) function within the write_sock and
> read_sock function, I expect to see a printout of the packet that is
> written and read when I call the functions.
>
> I think the packet is actually sent because when I call the read with
> the same socket that I used for the write "write_sock(sock1, data,
> len);read_sock(sock1);", I get the example output below.
>

How is you networking set up? Everything you send out, is ping-ponged
back to the same interface? Then yes. :-)

"
> Writing =3D 1485946880
> length =3D 42
> addr=3D0 | 01 01 01 01 01 01 04 01 03 02 12 5D 08 06 00 01 08 00 06 04 00
> 01 36 15 FD 2A EE A3 C0 A8 08 64  | ...........]..........6.=EF=BF=BD*=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD.d
> addr=3D0 | 00 00 00 00 00 00 D8 3A D4 64 __ __ __ __ __ __ __ __ __ __ __
> __ __ __ __ __ __ __ __ __ __ __  | ......=EF=BF=BD:=EF=BF=BDd
>
> Reading =3D 1485946880
> length =3D 42
> addr=3D0 | 01 01 01 01 01 01 04 01 03 02 12 5D 08 06 00 01 08 00 06 04 00
> 01 36 15 FD 2A EE A3 C0 A8 08 64  | ...........]..........6.=EF=BF=BD*=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD.d
> addr=3D0 | 00 00 00 00 00 00 D8 3A D4 64 __ __ __ __ __ __ __ __ __ __ __
> __ __ __ __ __ __ __ __ __ __ __  | ......=EF=BF=BD:=EF=BF=BDd
> "
>
> But when I use one socket for the write and the other socket for the
> read "write_sock(sock1, data, len);read_sock(sock2);", I don't get any
> output for the read call as seen in the example output below.
> "
> Writing =3D 1417486336
> length =3D 42
> addr=3D0 | 01 01 01 01 01 01 04 01 03 02 12 5D 08 06 00 01 08 00 06 04 00
> 01 36 15 FD 2A EE A3 C0 A8 08 64  | ...........]..........6.=EF=BF=BD*=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD.d
> addr=3D0 | 00 00 00 00 00 00 D8 3A D4 64 __ __ __ __ __ __ __ __ __ __ __
> __ __ __ __ __ __ __ __ __ __ __  | ......=EF=BF=BD:=EF=BF=BDd
> "
>

Your XDP program only redirects packets to the first AF_XDP socket,
according to:
     https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_kern.c#L3=
3
and onward, so this would be excepted.

> >
> > I think it would help if you explained what you are trying to do
> > first!
>
> I am just trying to test and understand how to send packets using an
> AF_XDP socket and to receive the packets using an another AF_XDP socket.
>

OK!

Cheers,
Bj=C3=B6rn

> >
> > What XDP program are you running?
> >
>
> The XDP program can be found
> https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_kern.c
>
>
> Thanks
> Konrad
>
>
> >
> > Cheers,
> > Bj=C3=B6rn
> >
>
