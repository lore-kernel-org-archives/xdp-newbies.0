Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:49789 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERIhV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 May 2020 04:37:21 -0400
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 49QXSZ4PD2zyTf
        for <xdp-newbies@vger.kernel.org>; Mon, 18 May 2020 10:37:18 +0200 (CEST)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id gWp__88ZGvYm for <xdp-newbies@vger.kernel.org>;
        Mon, 18 May 2020 10:37:18 +0200 (CEST)
Received: from BADWLRZ-SWMBX05.ads.mwn.de (BADWLRZ-SWMBX05.ads.mwn.de [IPv6:2001:4ca0:0:108::161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX05", Issuer "BADWLRZ-SWMBX05" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 49QXSZ2PrdzyS5
        for <xdp-newbies@vger.kernel.org>; Mon, 18 May 2020 10:37:18 +0200 (CEST)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: How does the Kernel decide which Umem frame to choose for the next
 packet?
Date: Mon, 18 May 2020 08:37:09 +0000
Message-ID: <ba88e0ff11b940fe8855a0dd43c947ae@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

Hello,

I read through the paper "The Path to DPDK Speeds for AF XDP" but I couldn'=
t find information about how the Kernel choses the Umem frame for the next =
packet? Or in case of zero-copy, how the driver decides which Umem frame to=
 chose.
But maybe I just overlooked it.

So how does this work?

Best regards

Max
