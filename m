Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f171.google.com ([209.85.222.171]:46969 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgAQMcT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 17 Jan 2020 07:32:19 -0500
Received: by mail-qk1-f171.google.com with SMTP id r14so22436636qke.13
        for <xdp-newbies@vger.kernel.org>; Fri, 17 Jan 2020 04:32:19 -0800 (PST)
MIME-Version: 1.0
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
In-Reply-To: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Fri, 17 Jan 2020 13:32:07 +0100
Message-ID: <CAJ+HfNhdPEe34DVUAj4eHxLkBUSTo2CXbLHoWu+dwFCp753oMg@mail.gmail.com>
Subject: Re: zero-copy between interfaces
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Ryan Goodfellow <rgoodfel@isi.edu>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, intel-wired-lan <intel-wired-lan@lists.osuosl.org>, Magnus Karlsson <magnus.karlsson@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>

On Mon, 13 Jan 2020 at 01:28, Ryan Goodfellow <rgoodfel@isi.edu> wrote:
>
[...]
>
> I could not get zero-copy to work with the i40e driver as it would crash.=
 I've
> attached the corresponding traces from dmesg.

Thanks Ryan! I had a look at the crash, and it's in the XDP setup:

i40e_xdp_setup:
...
 for (i =3D 0; i < vsi->num_queue_pairs; i++)
     WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);

and the vsi->rx_ring[0] is NULL. This is clearly broken.

It would help with more lines from your dmesg: the cut i40e log hints
that something is really broken:

[  328.579154] i40e 0000:b7:00.2: failed to get tracking for 256
queues for VSI 0 err -12
[  328.579280] i40e 0000:b7:00.2: setup of MAIN VSI failed
[  328.579367] i40e 0000:b7:00.2: can't remove VEB 162 with 0 VSIs left

Is it possible to dig out the complete log?

Thanks!
Bj=C3=B6rn
