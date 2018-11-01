Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f173.google.com ([209.85.160.173]:39060 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbeKBDyH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Nov 2018 23:54:07 -0400
Received: by mail-qt1-f173.google.com with SMTP id g10-v6so22269161qtq.6
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Nov 2018 11:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <ad85176a72e82878a4073a4215aa5e3a@igalia.com>
In-Reply-To: <ad85176a72e82878a4073a4215aa5e3a@igalia.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Thu, 1 Nov 2018 19:49:42 +0100
Message-ID: <CAJ+HfNjfCNt+M+=bJe60JOPmTJ9q=cvf6DCC=FK0aNdY-6po5g@mail.gmail.com>
Subject: Re: AF_XDP socket (sock2) unable to read, after writing with another
 AF_XDP socket (sock1)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: kdjimeli@igalia.com
Cc: xdp-newbies@vger.kernel.org

Den tors 1 nov. 2018 kl 18:14 skrev Konrad Djimeli <kdjimeli@igalia.com>:
>
> Hello,
>
> I am working on developing a Snabb Switch app which uses Af_XDP sockets
> and so far I have not found any AF_XDP sample example online, except for
> the sample in the Linux Kernel source. I have tried modifying the
> example, to create two sockets (sock1 and sock2) sharing a UMEM with
> custom write_sock and read_sock functions. But when I do a write with
> "sock1" I am unable to read the data with "sock2". Here is the code
> https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_user.c ,
> and I am new to working with AF_XDP sockets and I wish I could get some
> pointers to what may be wrong with the program.
>

Hi Konrad,

Let's recap what your application does:

1. Create two AF_XDP sockets bound to ifindex and a shared UMEM.
2. The pass NUM_DESCS descriptors to the UMEM fill ring
3. In write_sock BATCH_SIZE packets are put on the Tx ring.
4. In read_sock up to BATCH_SIZE packets are picked from the Rx ring.
5. The application exits.

In terms of correctness:

In 3. you pass the same UMEM indicies to the Tx ring (ids=3D{0,
FRAME_SIZE, 2*FRAME_SIZE, ...}), as you have passed to the fill
ring. This is not correct. Userspace to track what ids are owned by
the user and by the kernel. Now, both the fill ring and Tx ring
contain the same id.

I'm not sure what the expected output of your program should be? Have
you verified that packets are being sent? Is the inferface/queue 0
receiving packets?

I think it would help if you explained what you are trying to do
first!

What XDP program are you running?


Cheers,
Bj=C3=B6rn



*

> Thanks,
> Konrad
> www.djimeli.me
