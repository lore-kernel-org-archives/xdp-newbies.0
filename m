Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-c.ads.isi.edu ([128.9.180.198]:54271 "EHLO
        mail-c.ads.isi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730643AbgAPCER (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 21:04:17 -0500
Date: Wed, 15 Jan 2020 21:04:14 -0500
From: Ryan Goodfellow <rgoodfel@isi.edu>
Subject: Re: zero-copy between interfaces
Message-ID: <20200116020414.GA46831@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
 <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <20200113151159.GB68570@smtp.ads.isi.edu>
 <CAJ8uoz1Ax5CAfO4wfo0Pj+jieeRN+gj0s2LpeeJ53uTorFP0ng@mail.gmail.com>
 <20200114205250.GA85903@smtp.ads.isi.edu>
 <20200115014137.GA105434@smtp.ads.isi.edu>
 <CAJ8uoz2VTXAT9ryF9Ls2JjacEw0Bc23t9w2jDEoMdA0dRc6Aaw@mail.gmail.com>
 <CAJ8uoz1Nf+Fsg40tfdnMenFiCjRBJN9maY9rVo--trt+Uwkqwg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz1Nf+Fsg40tfdnMenFiCjRBJN9maY9rVo--trt+Uwkqwg@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Wed, Jan 15, 2020 at 09:20:30AM +0100, Magnus Karlsson wrote:
> On Wed, Jan 15, 2020 at 8:40 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Wed, Jan 15, 2020 at 2:41 AM Ryan Goodfellow <rgoodfel@isi.edu> wrot=
e:
> > >
> > > On Tue, Jan 14, 2020 at 03:52:50PM -0500, Ryan Goodfellow wrote:
> > > > On Tue, Jan 14, 2020 at 10:59:19AM +0100, Magnus Karlsson wrote:
> > > > >
> > > > > Just sent out a patch on the mailing list. Would be great if you =
could
> > > > > try it out.
> > > >
> > > > Thanks for the quick turnaround. I gave this patch a go, both in th=
e bpf-next
> > > > tree and manually applied to the 5.5.0-rc3 branch I've been working=
 with up to
> > > > this point. It does allow for allocating more memory, however packe=
t
> > > > forwarding no longer works. I did not see any complaints from dmesg=
, but here
> > > > is an example iperf3 session from a client that worked before.
> > > >
> > > > ry@xd2:~$ iperf3 -c 10.1.0.2
> > > > Connecting to host 10.1.0.2, port 5201
> > > > [  5] local 10.1.0.1 port 53304 connected to 10.1.0.2 port 5201
> > > > [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> > > > [  5]   0.00-1.00   sec  5.91 MBytes  49.5 Mbits/sec    2   1.41 KB=
ytes
> > > > [  5]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KByt=
es
> > > > [  5]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KByt=
es
> > > > [  5]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KByt=
es
> > > > [  5]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KByt=
es
> > > > [  5]   5.00-6.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KByt=
es
> > > > [  5]   6.00-7.00   sec  0.00 Bytes  0.00 bits/sec    1   1.41 KByt=
es
> > > > [  5]   7.00-8.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KByt=
es
> > > > [  5]   8.00-9.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KByt=
es
> > > > ^C[  5]  10.00-139.77 sec  0.00 Bytes  0.00 bits/sec    4   1.41 KB=
ytes
> > > > - - - - - - - - - - - - - - - - - - - - - - - - -
> > > > [ ID] Interval           Transfer     Bitrate         Retr
> > > > [  5]   0.00-139.77 sec  5.91 MBytes   355 Kbits/sec    9          =
   sender
> > > > [  5]   0.00-139.77 sec  0.00 Bytes  0.00 bits/sec                 =
 receiver
> > > > iperf3: interrupt - the client has terminated
> > > >
> > > > I'll continue to investigate and report back with anything that I f=
ind.
> > >
> > > Interestingly I found this behavior to exist in the bpf-next tree ind=
ependent
> > > of the patch being present.
> >
> > Ryan,
> >
> > Could you please do a bisect on it? In the 12 commits after the merge
> > commit below there are number of sensitive rewrites of the ring access
> > functions. Maybe one of them breaks your code. When you say "packet
> > forwarding no longer works", do you mean it works for a second or so,
> > then no packets come through? What HW are you using?
> >
> > commit ce3cec27933c069d2015a81e59b93eb656fe7ee4
> > Merge: 99cacdc 1d9cb1f
> > Author: Alexei Starovoitov <ast@kernel.org>
> > Date:   Fri Dec 20 16:00:10 2019 -0800
> >
> >     Merge branch 'xsk-cleanup'
> >
> >     Magnus Karlsson says:
> >
> >     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >     This patch set cleans up the ring access functions of AF_XDP in hop=
e
> >     that it will now be easier to understand and maintain. I used to ge=
t a
> >     headache every time I looked at this code in order to really unders=
tand it,
> >     but now I do think it is a lot less painful.
> >     <snip>
> >
> > /Magnus
>=20
> I see that you have debug messages in your application. Could you
> please run with those on and send me the output so I can see where it
> stops. A bisect that pin-points what commit that breaks your program
> plus the debug output should hopefully send us on the right path for a
> fix.
>=20
> Thanks: Magnus
>=20

Hi Magnus,

I did a bisect starting from the head of the bpf-next tree (990bca1) down t=
o=20
the first commit before the patch series you identified (df034c9). The resu=
lt
was identifying df0ae6f as the commit that causes the issue I am seeing.

I've posted output from the program in debugging mode here

- https://gitlab.com/mergetb/tech/network-emulation/kernel/snippets/1930375

Yes, you are correct in that forwarding works for a brief period and then s=
tops.
I've noticed that the number of packets that are forwarded is equal to the =
size
of the producer/consumer descriptor rings. I've posted two ping traces from=
 a
client ping that shows this.

- https://gitlab.com/mergetb/tech/network-emulation/kernel/snippets/1930376
- https://gitlab.com/mergetb/tech/network-emulation/kernel/snippets/1930377

I've also noticed that when the forwarding stops, the CPU usage for the pro=
c
running the program is pegged, which is not the norm for this program as it=
 uses
a poll call with a timeout on the xsk fd.

The hardware I am using is a Mellanox ConnectX4 2x100G card (MCX416A-CCAT)
running the mlx5 driver. The program is running in zero copy mode. I also t=
ested
this code out in a virtual machine with virtio NICs in SKB mode which uses
xdpgeneric - there were no issues in that setting.

--=20
~ ry
