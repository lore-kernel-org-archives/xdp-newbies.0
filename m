Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-c.ads.isi.edu ([128.9.180.198]:31124 "EHLO
        mail-c.ads.isi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgAROJB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 18 Jan 2020 09:09:01 -0500
Date: Sat, 18 Jan 2020 09:08:58 -0500
From: Ryan Goodfellow <rgoodfel@isi.edu>
Subject: Re: zero-copy between interfaces
Message-ID: <20200118140857.GA9363@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
 <20200113124134.3974cbed@carbon>
 <20200113152759.GD68570@smtp.ads.isi.edu>
 <20200113180411.24d8bd40@carbon>
 <20200117175409.GC69024@smtp.ads.isi.edu>
 <20200118111405.28fd1c75@carbon>
MIME-Version: 1.0
In-Reply-To: <20200118111405.28fd1c75@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Sat, Jan 18, 2020 at 11:14:05AM +0100, Jesper Dangaard Brouer wrote:
> On Fri, 17 Jan 2020 12:54:09 -0500
> Ryan Goodfellow <rgoodfel@isi.edu> wrote:
> > I tried to use this program, however it does not seem to work for bidir=
ectional
> > traffic across the two interfaces?
>=20
> It does work bidirectional if you start more of these xdp_redirect_map
> programs.  Do notice this is an example program.  Look at xdp_fwd_*.c
> if you want a program that is functional and uses the existing IP route
> table for XDP acceleration.
>=20
> My point is that there are alternatives for doing zero-copy between
> interfaces... A xdp_redirect_map inside the kernel out another
> interface is already zero-copy.
>=20
> I'm wondering why did you choose/need AF_XDP technology for doing forward=
ing?

This is just a sample program used to demonstrate moving packets between
different interfaces efficiently using AF_XDP.

Our actual use case is performing network emulation in userspace. For examp=
le,
representing impaired links or entire networks with link-by-link shaping
specifications. We are using AF_XDP to get packets to/from our network emul=
ation
software as quickly as possible without having to go through the entire net=
work
stack, as the emulation host's network configuration does not influence the
networks it's emulating.

Traditionally we've used DPDK for this, but are porting to AF_XDP for the=
=20
relative simplicity and flexibility it provides. Some specific benefits for=
 us
are:

- Can attach to VTEPs which allows us to hook into some EVPN/VXLAN based
  networks we have easily. Alternatively with the BPF program flexibility, =
we
  also have the option to split out BGP control plane traffic from overlay
  traffic when attaching to the physical interface and pass it through to t=
he=20
  kernel. Both of these approaches let the kernel manage the FDB for VTEPs =
as=20
  well as taking care of encap/decap (potentially offloaded to the NIC itse=
lf)=20
  and let our software focus on emulation.

- Using XDP in virtual machines in our testing environment is straightforwa=
rd,
  while this is possible with DPDK and virtio, the setup was rather convolu=
ted.

--=20
~ ry
