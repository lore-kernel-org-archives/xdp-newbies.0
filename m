Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f48.google.com ([209.85.210.48]:45688 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUUsv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Nov 2019 15:48:51 -0500
Received: by mail-ot1-f48.google.com with SMTP id r24so4181584otk.12
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Nov 2019 12:48:51 -0800 (PST)
MIME-Version: 1.0
From: Joubert Berger <joubert@berger-family.org>
Date: Thu, 21 Nov 2019 15:48:40 -0500
Message-ID: <CA+ZpPewq9hEEgcYcoUk05E0PxGXf=ppvB8wM+z3WVy5OkqTHzA@mail.gmail.com>
Subject: XDP - Bridge - not redirecting all UDP
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

I have been playing around with Ilya's xdpbridge sample.  In my case,
what I am interested in is pushing all UDP traffic to userspace.  All
other traffic can flow through my box.  So, I setup something like this:

eth0 --> br0 --> eth1

I capture all packets on eth0/eth1 and return XDP_PASS for all but UDP
packets.  These I redirect it to the user space application. There
I set the UDP checksum to zero, that way I know it hit my code and
then send it to "other" interface.

The problem is that not *all* my UDP traffic has the checksum set to
zero.  Anyone have any ideas why that might be the case?  Why is only
some of the UDP traffic being pushed to user space?

--joubert
