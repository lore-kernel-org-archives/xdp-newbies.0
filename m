Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:43087 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfBYVKr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 16:10:47 -0500
Received: by mail-wr1-f48.google.com with SMTP id d17so11508189wre.10
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 13:10:47 -0800 (PST)
MIME-Version: 1.0
References: <CAM2iwTj2bymRNj9jpX817VEPGWt-Vw79mzE15s2j9fZ=H2KEqw@mail.gmail.com>
 <20190225121043.2437c7fd@cakuba.netronome.com>
In-Reply-To: <20190225121043.2437c7fd@cakuba.netronome.com>
From: papito favaro <papito.favaro@gmail.com>
Date: Mon, 25 Feb 2019 22:10:35 +0100
Message-ID: <CAM2iwTgu9C-MmiE55U95eckMWNBq8awuhAWqr_fYqacdTJPnjw@mail.gmail.com>
Subject: Re: AF_XDP xdp_umem_reg.headroom XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: xdp-newbies@vger.kernel.org, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, =?UTF-8?Q?Maciej_Fija=C5=82kowski?= <maciejromanfijalkowski@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>

Yes, would be nice that the documentation would mention this facts
(like copy vs zerocopy differences)
I also had an issue with the rx-path. In zerocopy is required that the
fill ring be "initialized" (with indexes) before the setup of rx ring.
In copy mode this can be done afterwards but in zerocopy must be done
before. also not sure minimum (valid) sizes for the rings.
sorry don't have a ixgbe to test this right now.

anyway thanks for your time

Il giorno lun 25 feb 2019 alle ore 21:10 Jakub Kicinski
<jakub.kicinski@netronome.com> ha scritto:
>
> On Mon, 25 Feb 2019 10:16:15 +0100, papito favaro wrote:
> > Hi all,
> > I woulld like to understand if the behaviour i'm getting is correct.
> >
> > When I configure the XDP_UMEM_REG in zerocopy mode with a headroom ==
> > 0 on a i40e,
> > the driver (i guess) actually sets a headroom of 256.
> > if i set a headroom == 256 the driver sets a headroom of 512.
> >
> > If this behaviour is correct, would be nice that the xdp_umem_reg
> > struct after the setsockopt call would contain the actual configured
> > headroom.
>
> Kernel's XDP may require up to 256B (XDP_PACKET_HEADROOM) of headroom
> this is for calls to xdp_adjust_head() which may want to prepend data.
> The AF_XDP headroom is extra, beyond that.
>
> Perhaps we should document that as expected behaviour?  (Does it hold
> for ixgbe?)
