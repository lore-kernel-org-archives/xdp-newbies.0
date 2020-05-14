Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:38729 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgENMEE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 14 May 2020 08:04:04 -0400
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 49N9Dt3p7FzyWF
        for <xdp-newbies@vger.kernel.org>; Thu, 14 May 2020 14:03:58 +0200 (CEST)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id PA99BqxOz5QE for <xdp-newbies@vger.kernel.org>;
        Thu, 14 May 2020 14:03:58 +0200 (CEST)
Received: from BADWLRZ-SWMBB04.ads.mwn.de (BADWLRZ-SWMBB04.ads.mwn.de [IPv6:2001:4ca0:0:108::155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBB04", Issuer "BADWLRZ-SWMBB04" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 49N9Dt2GgTzyRs
        for <xdp-newbies@vger.kernel.org>; Thu, 14 May 2020 14:03:58 +0200 (CEST)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Under which circumstances does `xsk_ring_prod__reserve` return 0?
Date: Thu, 14 May 2020 12:03:57 +0000
Message-ID: <ca3de1dca95241dda545c032a42b0152@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

Hello,

I have this system which handles multiple multicast-streams at once where t=
he user can choose the amount of RX-Queues of the NIC he wants to utilize.

I am testing the scenario where only one RX-Queue is used. Thus, shared ume=
m is used.

At the time a user decides to receive the first multicast-stream, a program=
 ("AF-XDP") is launched by another program ("handler") which handles the us=
er inputs.
This AF-XDP program receives information about a Linux System V message que=
ue through command line arguments.
The first thing the AF-XDP program does is to map a shared memory segment a=
nd configuring a umem with it.
After the program launched successfully, the handler sends a message to sai=
d queue telling the AF-XDP program to create a new XSK and place its file d=
escriptor into a certain index in the XDP map.
The XSK runs in a separate thread checking every millisecond for packets an=
d sending information about those packet addresses in umem to the handler-p=
rogram.

To this point, everything works fine. But as soon as the user decides to re=
ceive another multicast-stream on the same RX-Queue, `xsk_ring_prod__reserv=
e` suddenly starts to return 0 (e.g. it wasn't able to reserve any packets)=
 even if I call this function a hundred times.
So of course to create another XSK, I have to call `xsk_socket__create` whi=
ch also takes the umem as an argument.
As this system is running in parallel I was wondering if this problem can o=
ccur because suddenly another XSK is registered at the same time as the fir=
st XSK tries to register umem frames for its packets?

Best regards

Max
