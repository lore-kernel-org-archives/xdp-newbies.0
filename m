Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from postout1.mail.lrz.de ([129.187.255.137]:59695 "EHLO
        postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgFDLRO (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jun 2020 07:17:14 -0400
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 49d3CC758vzyWL
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 13:17:11 +0200 (CEST)
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id IXU_sW5OOy-F for <xdp-newbies@vger.kernel.org>;
        Thu,  4 Jun 2020 13:17:11 +0200 (CEST)
Received: from BADWLRZ-SWMBX06.ads.mwn.de (BADWLRZ-SWMBX06.ads.mwn.de [IPv6:2001:4ca0:0:108::162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client CN "BADWLRZ-SWMBX06", Issuer "BADWLRZ-SWMBX06" (not verified))
        by postout1.mail.lrz.de (Postfix) with ESMTPS id 49d3CC5YvPzySZ
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 13:17:11 +0200 (CEST)
From: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Subject: Dynamically adding new multicast streams
Date: Thu, 4 Jun 2020 11:17:11 +0000
Message-ID: <dd7946c400c544feac167dab0ff4f974@hm.edu>
Content-Language: de-DE
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Xdp <xdp-newbies@vger.kernel.org>

Hello everyone,

I try to dynamically add new multicast streams by creating a new AF-XDP soc=
ket bound to a RX-Queue.
I also create a new ethtool-rule to steer the flow of the multicast stream =
towards that RX-Queue.

My BPF program has a Hash-Map which maps a struct consisting of { src-ip, d=
st-ip, dst-port } to an index in the XSKMap (which is then used to redirect=
 an incoming packet).
So adding a new AF-XDP socket also means adding a new entry to that Hash-Ma=
p (and to the XSKMap).

Now what I am experiencing is that the moment I add a new XSK, other alread=
y running sockets are loosing some packets (around 10ms worth of packets).
I don't experience any packet loss afterwards.

My question is: Is there something happening inside the XSK- or HashMap whi=
ch could cause other packet streams to drop packets?

I am not using Shared Umem, just launching a new process which starts that =
XSK.

Best regards

Max
