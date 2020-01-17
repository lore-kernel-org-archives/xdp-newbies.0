Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45014 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQRlF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 17 Jan 2020 12:41:05 -0500
Received: by mail-qt1-f196.google.com with SMTP id w8so7959247qts.11
        for <xdp-newbies@vger.kernel.org>; Fri, 17 Jan 2020 09:41:04 -0800 (PST)
MIME-Version: 1.0
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu> <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <20200113151159.GB68570@smtp.ads.isi.edu> <CAJ8uoz1Ax5CAfO4wfo0Pj+jieeRN+gj0s2LpeeJ53uTorFP0ng@mail.gmail.com>
 <20200114205250.GA85903@smtp.ads.isi.edu>
In-Reply-To: <20200114205250.GA85903@smtp.ads.isi.edu>
From: William Tu <u9012063@gmail.com>
Date: Fri, 17 Jan 2020 09:40:27 -0800
Message-ID: <CALDO+SZZdA+te293-kjF_dSUo79D_Wn3Lv2ureB4SKUYVPFF+g@mail.gmail.com>
Subject: Re: zero-copy between interfaces
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Ryan Goodfellow <rgoodfel@isi.edu>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Tue, Jan 14, 2020 at 12:53 PM Ryan Goodfellow <rgoodfel@isi.edu> wrote:
>
> On Tue, Jan 14, 2020 at 10:59:19AM +0100, Magnus Karlsson wrote:
> >
> > Just sent out a patch on the mailing list. Would be great if you could
> > try it out.
>
> Thanks for the quick turnaround. I gave this patch a go, both in the bpf-=
next
> tree and manually applied to the 5.5.0-rc3 branch I've been working with =
up to
> this point. It does allow for allocating more memory, however packet
> forwarding no longer works. I did not see any complaints from dmesg, but =
here
> is an example iperf3 session from a client that worked before.
>
> ry@xd2:~$ iperf3 -c 10.1.0.2
> Connecting to host 10.1.0.2, port 5201
> [  5] local 10.1.0.1 port 53304 connected to 10.1.0.2 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  5.91 MBytes  49.5 Mbits/sec    2   1.41 KBytes
> [  5]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> [  5]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  5]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> [  5]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  5]   5.00-6.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  5]   6.00-7.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> [  5]   7.00-8.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> [  5]   8.00-9.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> ^C[  5]  10.00-139.77 sec  0.00 Bytes  0.00 bits/sec    4   1.41 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-139.77 sec  5.91 MBytes   355 Kbits/sec    9             sen=
der
> [  5]   0.00-139.77 sec  0.00 Bytes  0.00 bits/sec                  recei=
ver
> iperf3: interrupt - the client has terminated
>
> I'll continue to investigate and report back with anything that I find.
>
Hi Ryan,

Not sure if this is the same, but we hit something similar in OVS
AF_XDP's implementation.
In our case, it happens when using native-mode, not the driver
zero-copy mode, and
iperf works a couple seconds then down to zero. FYI:
https://mail.openvswitch.org/pipermail/ovs-dev/2019-November/365076.html
and fixes
https://github.com/openvswitch/ovs/commit/161773c72a33a86a23d4892e3c7448cee=
9946317

Regards,
William
