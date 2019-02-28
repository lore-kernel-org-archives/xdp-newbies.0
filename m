Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f180.google.com ([209.85.167.180]:41453 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfB1Nuz (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Feb 2019 08:50:55 -0500
Received: by mail-oi1-f180.google.com with SMTP id e7so16505461oia.8
        for <xdp-newbies@vger.kernel.org>; Thu, 28 Feb 2019 05:50:54 -0800 (PST)
MIME-Version: 1.0
References: <CAM2iwTj2bymRNj9jpX817VEPGWt-Vw79mzE15s2j9fZ=H2KEqw@mail.gmail.com>
 <20190225121043.2437c7fd@cakuba.netronome.com> <CAM2iwTgu9C-MmiE55U95eckMWNBq8awuhAWqr_fYqacdTJPnjw@mail.gmail.com>
 <AFED4FBCE79F3548A8F74434195ACE3958A97BCF@IRSMSX107.ger.corp.intel.com>
In-Reply-To: <AFED4FBCE79F3548A8F74434195ACE3958A97BCF@IRSMSX107.ger.corp.intel.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Thu, 28 Feb 2019 14:50:42 +0100
Message-ID: <CAJ8uoz2EOrxV=3QkTZFcddTgysaM-6Sn_HqjsSRBuNHoyD-JDQ@mail.gmail.com>
Subject: Re: FW: AF_XDP xdp_umem_reg.headroom XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: papito.favaro@gmail.com
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, xdp-newbies@vger.kernel.org, Magnus <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, =?UTF-8?Q?Maciej_Fija=C5=82kowski?= <maciejromanfijalkowski@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>

> -----Original Message-----
> From: papito favaro [mailto:papito.favaro@gmail.com]
> Sent: Monday, February 25, 2019 10:11 PM
> To: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: xdp-newbies@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.=
com>; Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>; Maciej Fija=C5=82kowsk=
i <maciejromanfijalkowski@gmail.com>; Jesper Dangaard Brouer <brouer@redhat=
.com>
> Subject: Re: AF_XDP xdp_umem_reg.headroom XDP_ZEROCOPY
>
> Yes, would be nice that the documentation would mention this facts (like =
copy vs zerocopy differences) I also had an issue with the rx-path. In zero=
copy is required that the fill ring be "initialized" (with indexes) before =
the setup of rx ring.
> In copy mode this can be done afterwards but in zerocopy must be done bef=
ore. also not sure minimum (valid) sizes for the rings.
> sorry don't have a ixgbe to test this right now.

You are supposed to be able to insert entries into the fill ring at
any point in time independent on copy mode or zero-copy mode. That it
did not work was a bug in both the i40e and ixgbe drivers. Links to
patches below. As for documentation, yes it needs to be improved :-).
Anything else you would like to see in there?

i40e: https://lore.kernel.org/netdev/1548770597-16141-1-git-send-email-magn=
us.karlsson@intel.com/.
ixgbe: https://lore.kernel.org/netdev/1548770630-16189-1-git-send-email-mag=
nus.karlsson@intel.com/

Thanks: Magnus

> anyway thanks for your time
>
> Il giorno lun 25 feb 2019 alle ore 21:10 Jakub Kicinski <jakub.kicinski@n=
etronome.com> ha scritto:
> >
> > On Mon, 25 Feb 2019 10:16:15 +0100, papito favaro wrote:
> > > Hi all,
> > > I woulld like to understand if the behaviour i'm getting is correct.
> > >
> > > When I configure the XDP_UMEM_REG in zerocopy mode with a headroom
> > > =3D=3D
> > > 0 on a i40e,
> > > the driver (i guess) actually sets a headroom of 256.
> > > if i set a headroom =3D=3D 256 the driver sets a headroom of 512.
> > >
> > > If this behaviour is correct, would be nice that the xdp_umem_reg
> > > struct after the setsockopt call would contain the actual configured
> > > headroom.
> >
> > Kernel's XDP may require up to 256B (XDP_PACKET_HEADROOM) of headroom
> > this is for calls to xdp_adjust_head() which may want to prepend data.
> > The AF_XDP headroom is extra, beyond that.
> >
> > Perhaps we should document that as expected behaviour?  (Does it hold
> > for ixgbe?)
