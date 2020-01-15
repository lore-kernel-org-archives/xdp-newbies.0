Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40901 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAOIUn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 03:20:43 -0500
Received: by mail-oi1-f196.google.com with SMTP id c77so14577874oib.7
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 00:20:42 -0800 (PST)
MIME-Version: 1.0
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu> <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <20200113151159.GB68570@smtp.ads.isi.edu> <CAJ8uoz1Ax5CAfO4wfo0Pj+jieeRN+gj0s2LpeeJ53uTorFP0ng@mail.gmail.com>
 <20200114205250.GA85903@smtp.ads.isi.edu> <20200115014137.GA105434@smtp.ads.isi.edu>
 <CAJ8uoz2VTXAT9ryF9Ls2JjacEw0Bc23t9w2jDEoMdA0dRc6Aaw@mail.gmail.com>
In-Reply-To: <CAJ8uoz2VTXAT9ryF9Ls2JjacEw0Bc23t9w2jDEoMdA0dRc6Aaw@mail.gmail.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Wed, 15 Jan 2020 09:20:30 +0100
Message-ID: <CAJ8uoz1Nf+Fsg40tfdnMenFiCjRBJN9maY9rVo--trt+Uwkqwg@mail.gmail.com>
Subject: Re: zero-copy between interfaces
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Ryan Goodfellow <rgoodfel@isi.edu>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Wed, Jan 15, 2020 at 8:40 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Jan 15, 2020 at 2:41 AM Ryan Goodfellow <rgoodfel@isi.edu> wrote:
> >
> > On Tue, Jan 14, 2020 at 03:52:50PM -0500, Ryan Goodfellow wrote:
> > > On Tue, Jan 14, 2020 at 10:59:19AM +0100, Magnus Karlsson wrote:
> > > >
> > > > Just sent out a patch on the mailing list. Would be great if you co=
uld
> > > > try it out.
> > >
> > > Thanks for the quick turnaround. I gave this patch a go, both in the =
bpf-next
> > > tree and manually applied to the 5.5.0-rc3 branch I've been working w=
ith up to
> > > this point. It does allow for allocating more memory, however packet
> > > forwarding no longer works. I did not see any complaints from dmesg, =
but here
> > > is an example iperf3 session from a client that worked before.
> > >
> > > ry@xd2:~$ iperf3 -c 10.1.0.2
> > > Connecting to host 10.1.0.2, port 5201
> > > [  5] local 10.1.0.1 port 53304 connected to 10.1.0.2 port 5201
> > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > [  5]   0.00-1.00   sec  5.91 MBytes  49.5 Mbits/sec    2   1.41 KByt=
es
> > > [  5]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> > > [  5]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> > > [  5]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> > > [  5]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> > > [  5]   5.00-6.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> > > [  5]   6.00-7.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KBytes
> > > [  5]   7.00-8.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> > > [  5]   8.00-9.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
> > > ^C[  5]  10.00-139.77 sec  0.00 Bytes  0.00 bits/sec    4   1.41 KByt=
es
> > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > [ ID] Interval           Transfer     Bitrate         Retr
> > > [  5]   0.00-139.77 sec  5.91 MBytes   355 Kbits/sec    9            =
 sender
> > > [  5]   0.00-139.77 sec  0.00 Bytes  0.00 bits/sec                  r=
eceiver
> > > iperf3: interrupt - the client has terminated
> > >
> > > I'll continue to investigate and report back with anything that I fin=
d.
> >
> > Interestingly I found this behavior to exist in the bpf-next tree indep=
endent
> > of the patch being present.
>
> Ryan,
>
> Could you please do a bisect on it? In the 12 commits after the merge
> commit below there are number of sensitive rewrites of the ring access
> functions. Maybe one of them breaks your code. When you say "packet
> forwarding no longer works", do you mean it works for a second or so,
> then no packets come through? What HW are you using?
>
> commit ce3cec27933c069d2015a81e59b93eb656fe7ee4
> Merge: 99cacdc 1d9cb1f
> Author: Alexei Starovoitov <ast@kernel.org>
> Date:   Fri Dec 20 16:00:10 2019 -0800
>
>     Merge branch 'xsk-cleanup'
>
>     Magnus Karlsson says:
>
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     This patch set cleans up the ring access functions of AF_XDP in hope
>     that it will now be easier to understand and maintain. I used to get =
a
>     headache every time I looked at this code in order to really understa=
nd it,
>     but now I do think it is a lot less painful.
>     <snip>
>
> /Magnus

I see that you have debug messages in your application. Could you
please run with those on and send me the output so I can see where it
stops. A bisect that pin-points what commit that breaks your program
plus the debug output should hopefully send us on the right path for a
fix.

Thanks: Magnus

> > I also gave the 5.5.0-rc6 branch a try (without the patch) and packets =
forward
> > OK.
> >
> > --
> > ~ ry
