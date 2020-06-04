Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgFDUGl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jun 2020 16:06:41 -0400
Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FDFC08C5C0
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 13:06:40 -0700 (PDT)
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 49dGy74SxjzyWp
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 22:06:39 +0200 (CEST)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id VtJhQzV7H5ky for <xdp-newbies@vger.kernel.org>;
        Thu,  4 Jun 2020 22:06:39 +0200 (CEST)
Received: from BADWLRZ-SWMBB04.ads.mwn.de (BADWLRZ-SWMBB04.ads.mwn.de [IPv6:2001:4ca0:0:108::155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBB04", Issuer "BADWLRZ-SWMBB04" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 49dGy72nMJzyWd
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 22:06:39 +0200 (CEST)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: AW: Intel 10G 2P X520 Adapter doesn't receive anything with AF XDP
Date: Thu, 4 Jun 2020 20:06:38 +0000
Message-ID: <be214a8beb65491eb69333eb29eca537@hm.edu>
References: <7ec53b8f30524ffba36bb264c6d023fc@hm.edu>
In-Reply-To: <7ec53b8f30524ffba36bb264c6d023fc@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

> Best regards
>=20
> Max

A small update. I disabled the ethtool ntuple rule which steers the multica=
st packets to a specific RX-Queue and let the program run for 2 minutes.
After 2 minutes or so I looked at the BPF map again and saw this:

=09=09$ sudo bpftool map dump id 41
=09=09key: 00 00 00 00  value: eb 00 00 00 00 00 00 00
=09=09key: 01 00 00 00  value: 6b 00 00 00 00 00 00 00
=09=09key: 02 00 00 00  value: 18 00 00 00 00 00 00 00
=09=09key: 03 00 00 00  value: 01 00 00 00 00 00 00 00
=09=09key: 04 00 00 00  value: 17 00 00 00 00 00 00 00
=09=09key: 05 00 00 00  value: 3a 00 00 00 00 00 00 00
=09=09key: 06 00 00 00  value: 65 00 00 00 00 00 00 00
=09=09key: 07 00 00 00  value: 3c 7a 89 01 00 00 00 00
=09=09key: 08 00 00 00  value: 02 00 00 00 00 00 00 00
=09=09key: 09 00 00 00  value: 12 00 00 00 00 00 00 00
=09=09key: 0a 00 00 00  value: 55 00 00 00 00 00 00 00
=09=09key: 0b 00 00 00  value: 14 00 00 00 00 00 00 00
=09=09key: 0c 00 00 00  value: 2c 00 00 00 00 00 00 00
=09=09key: 0d 00 00 00  value: 00 00 00 00 00 00 00 00
=09=09key: 0e 00 00 00  value: 1b 00 00 00 00 00 00 00

As you can see, the multicast stream is probably landing on RX-Queue 7 (unf=
ortunately my XSK-Program is waiting for packets on RX-Queue 0) but somehow=
 delayed for 1 or 2 minutes.

In case I enable ntuple via

                 ethtool -K eth5 ntuple on

and add the ethtool ntuple rule back, wait for 2 minutes again, I get this:

=09=09$ sudo bpftool map dump id 46
=09=09key: 00 00 00 00  value: 6f 16 00 00 00 00 00 00
=09=09key: 01 00 00 00  value: 43 00 00 00 00 00 00 00
=09=09key: 02 00 00 00  value: 0d 00 00 00 00 00 00 00
=09=09key: 03 00 00 00  value: 00 00 00 00 00 00 00 00
=09=09key: 04 00 00 00  value: 0e 00 00 00 00 00 00 00
=09=09key: 05 00 00 00  value: 24 00 00 00 00 00 00 00
=09=09key: 06 00 00 00  value: 34 00 00 00 00 00 00 00
=09=09key: 07 00 00 00  value: 7d 05 00 00 00 00 00 00
=09=09key: 08 00 00 00  value: 01 00 00 00 00 00 00 00
=09=09key: 09 00 00 00  value: 0a 00 00 00 00 00 00 00
=09=09key: 0a 00 00 00  value: 30 00 00 00 00 00 00 00
=09=09key: 0b 00 00 00  value: 0e 00 00 00 00 00 00 00
=09=09key: 0c 00 00 00  value: 1b 00 00 00 00 00 00 00
=09=09key: 0d 00 00 00  value: 00 00 00 00 00 00 00 00
=09=09key: 0e 00 00 00  value: 0a 00 00 00 00 00 00 00

As you can see, no indicator for a multicast stream with lots of packets :(

Something is wrong here...

   =20
