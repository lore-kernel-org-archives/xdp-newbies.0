Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgFEM0B (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jun 2020 08:26:01 -0400
Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEE4C08C5C3
        for <xdp-newbies@vger.kernel.org>; Fri,  5 Jun 2020 05:26:00 -0700 (PDT)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Intel X520 looses ethtool flow-type rule the moment a BPF / XDP
 program is loaded
Date: Fri, 5 Jun 2020 12:25:56 +0000
Message-ID: <bf2f8889ebd343edaf44a43f0d1f4c8b@hm.edu>
References: <a5741e0f3b90422f8c53a8bd54f06d8a@hm.edu>
 <CAJ8uoz3V1F4MB9yprixAReFqPCW9bE4SbV58Gs-D7qdSXtz6sg@mail.gmail.com>
 <0d6aad4ae9f9484cb158845d73c37f5d@hm.edu>,<CAJ8uoz3d3u0MxVAFxpRjZzVTR41aHBu879FPFA0Z4uUL=6sQqg@mail.gmail.com>
In-Reply-To: <CAJ8uoz3d3u0MxVAFxpRjZzVTR41aHBu879FPFA0Z4uUL=6sQqg@mail.gmail.com>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Magnus Karlsson <magnus.karlsson@gmail.com>, "Raczynski, Piotr" <piotr.raczynski@intel.com>, "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>, "lihong.yang@intel.com" <lihong.yang@intel.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

> I do not use this card in my AF_XDP lab setup, so unforuately I do not
> know. I have included some persons from the networking division at
> Intel. They might know of a "known issues" page or somewhere where you
> can bug report this.
>=20
> /Magnus

Thank you so much!

One more question: Does the 82599ES 10Gbit/s NIC have similiar issues with =
XDP and ethtool?

Best regards

Max
