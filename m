Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f53.google.com ([209.85.208.53]:39633 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbeKBDhm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Nov 2018 23:37:42 -0400
Received: by mail-ed1-f53.google.com with SMTP id e5-v6so17312580eds.6
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Nov 2018 11:33:34 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: AF_XDP socket (sock2)  unable to read, after writing with another
 AF_XDP socket (sock1)
From: Marius Gerling <mariusgerling@gmail.com>
In-Reply-To: <ad85176a72e82878a4073a4215aa5e3a@igalia.com>
Date: Thu, 1 Nov 2018 19:27:42 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <ABE87697-2B6F-4F4B-BE08-2CBD84A88408@gmail.com>
References: <ad85176a72e82878a4073a4215aa5e3a@igalia.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Konrad Djimeli <kdjimeli@igalia.com>
Cc: xdp-newbies@vger.kernel.org

Hello Konrad,

some things to think of while using AF_XDP.

 - Received data is forwarded to an AF_XDP socket with the =
bps_redirect_map call in the kernel part. You are sending the data to =
the first AF_XDP socket all the time.
 - With AF_XDP one bypasses all the TCP/IP stack of the Linux kernel. =
This means that one needs to set the Ethernet, IP, UDP (or TCP) headers =
by themselves at the beginning of the packet. (I don=E2=80=99t exactly =
know if this is needed for the loopback adapter you are using)

You might want to have a look at other AF_XDP implementations. One is in =
my repo: https://github.com/gerl1ng/afxdp-packet-processor (folder =
server_afxdp). Some more information is given in the PDF in that repo.

Marius

> On 1. Nov 2018, at 17:52, Konrad Djimeli <kdjimeli@igalia.com> wrote:
>=20
> Hello,
>=20
> I am working on developing a Snabb Switch app which uses Af_XDP =
sockets
> and so far I have not found any AF_XDP sample example online, except =
for
> the sample in the Linux Kernel source. I have tried modifying the
> example, to create two sockets (sock1 and sock2) sharing a UMEM with
> custom write_sock and read_sock functions. But when I do a write with
> "sock1" I am unable to read the data with "sock2". Here is the code
> https://github.com/djkonro/afxdp/blob/master/xdpsock/xdpsock_user.c ,
> and I am new to working with AF_XDP sockets and I wish I could get =
some
> pointers to what may be wrong with the program.=20
>=20
> Thanks,
> Konrad
> www.djimeli.me
