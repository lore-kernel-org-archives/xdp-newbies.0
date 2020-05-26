Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:29591
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388683AbgEZLKC (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 26 May 2020 07:10:02 -0400
From: Denis Salopek <Denis.Salopek@fer.hr>
Subject: Re: XDP_REDIRECT forwarding speed
Date: Tue, 26 May 2020 11:09:58 +0000
Message-ID: <VI1PR08MB33600F67AF097A722317F7228BB00@VI1PR08MB3360.eurprd08.prod.outlook.com>
References: <AM0PR08MB3345DF6A3FABBCF262B39E968BB00@AM0PR08MB3345.eurprd08.prod.outlook.com>,<20200526100443.2c927057@carbon>
In-Reply-To: <20200526100443.2c927057@carbon>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>

> From: Jesper Dangaard Brouer <jbrouer@redhat.com>=0A> Sent: Tuesday, May =
26, 2020 10:04 AM=0A> To: Denis Salopek=0A> Cc: xdp-newbies@vger.kernel.org=
; Alexander Duyck=0A> Subject: Re: XDP_REDIRECT forwarding speed=0A>=20=0A>=
 On Tue, 26 May 2020 07:00:30 +0000=0A> Denis Salopek <Denis.Salopek@fer.hr=
> wrote:=0A>=20=0A> > I want to make sure I did everything right to make my=
 XDP program=0A> > (simple forwarding with bpf_redirect_map) as fast as pos=
sible. Is following=0A> > advices and gotchas from this:=0A> > https://www.=
mail-archive.com/netdev@vger.kernel.org/msg184139.html=0A>=20=0A> I prefer =
links to lore.kernel.org:=0A>  [1] https://lore.kernel.org/netdev/201708212=
12506.1cb0d5d6@redhat.com/=0A>=20=0A> Do notice that my results in [1] is f=
or a single queue and single CPU.=0A> In production I assume that you can l=
ikely scale this across more CPUs ;-)=0A>=20=0A> > enough or are there some=
 additional/newer recommendations? I managed=0A> > to get near line-rate on=
 my Intel X520s (on Ryzen 3700X and one=0A> > queue/CPU), but not quite 14.=
88 Mpps so I was wondering is there=0A> > something else to speed things up=
 even more.=0A>=20=0A> In [1] I mention the need to tune the TX-queue to ke=
ep up via either=0A> adjusting the TX-DMA completion interrupt interval:=0A=
>=20=0A>  Tuned with rx-usecs 25:=0A>   ethtool -C ixgbe1 rx-usecs 25 ;\=0A=
>   ethtool -C ixgbe2 rx-usecs 25=0A>=20=0A> Or increasing the size of the =
TX-queue, so it doesn't overrun:=0A>=20=0A>  Tuned with adjusting ring-queu=
e sizes:=0A>   ethtool -G ixgbe1 rx 1024 tx 1024 ;\=0A>   ethtool -G ixgbe2=
 rx 1024 tx 1024=0A>=20=0A> This might not be needed any longer, as I think=
 it was Alexander, that=0A> implemented an improved interrupt adjustment sc=
heme for ixgbe.=0A=0AThank you for the info.=0A=0A> > Also, are there any r=
ecommended settings/tweaks for bidirectional=0A> > forwarding? I suppose th=
ere would be a drop in performance compared to=0A> > single direction, but =
has anyone done any benchmarks?=0A>=20=0A> As this was 1-CPU you can just r=
un the other direction on another CPU.=0A> That said, it can still be an ad=
vantage to run the bidirectional=0A> traffic on the same CPU and RX-TX-queu=
e pair, as above issue with=0A> TX-queue DMA cleanups/completions goes away=
.  Because, the ixgbe driver=0A> will do TX-cleanups as part (before) the R=
X-processing.=0A=0AYeah, you are right, bidirectional yields 10-15% more pp=
s.=0A=0A> What is your use-case?=0A> e.g. building an IPv4 router?=0A=0AJus=
t exploring the performance potential of userspace vs XDP for=0ADDoS-scrubb=
ing type middlebox (i.e. forwarding) tasks.=0A=0A>=20=0A> --=0A> Best regar=
ds,=0A>   Jesper Dangaard Brouer=0A>   MSc.CS, Principal Kernel Engineer at=
 Red Hat=0A>   LinkedIn: http://www.linkedin.com/in/brouer=0A>=20=0A>=20=0A=
=0ADenis
