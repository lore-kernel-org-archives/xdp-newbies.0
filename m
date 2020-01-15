Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42423 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgAOVDk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 16:03:40 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id F3B4721EAE
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 16:03:39 -0500 (EST)
Mime-Version: 1.0
Message-Id: <ee5e4155-f060-4836-bc00-58979c004421@www.fastmail.com>
Date: Wed, 15 Jan 2020 22:03:19 +0100
From: "Gilberto Bertin" <me@jibi.io>
Subject: Transmitting packets with AF_XDP on lo iface
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

Hi all,

I'm playing with AF_XDP with a program based on the sample one in the
xdp-tutorial repo.

The program is a simple UDP echo server, and works fine on any interface
_but_ the loopback one!

When I run it on lo, I can:

* receive packets
* send the responses
* see the UDP packets I'm sending from AF_xDP in tcpdump

but the actual application does not receive any traffic.

I also tried the original example in xdp-tutorial (which replies to ICMP
echo requests rather than UDP packets) and I can observe the same
behaviour.

I'm using:

* xdp-tutorial from master
* Ubuntu 19.10
* kernel 5.3.0

Is this a known issue? Does lo require any special configuration to work
with AF_XDP?

Cheers,
Gilberto
