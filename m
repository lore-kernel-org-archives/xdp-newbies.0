Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:39992 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388347AbfFJJzT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Jun 2019 05:55:19 -0400
Received: by mail-it1-f194.google.com with SMTP id q14so11111674itc.5
        for <xdp-newbies@vger.kernel.org>; Mon, 10 Jun 2019 02:55:18 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date: Mon, 10 Jun 2019 12:55:07 +0300
Message-ID: <CAK6Qs9=ig3-PWKtSk7UJfm1gcWz9cSGYU7uDxxUw=xju5TtP9w@mail.gmail.com>
Subject: ethtool isn't showing xdp statistics
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi.
I'm trying to do a xdp performance test on redhat based environment.
To do so, I compiled kernel 5.0.13 and iproute 4.6.0
Then I loaded compiled code to interface with below command.
#ip -force link set dev enp7s0f0 xdp object xdptest.o

After that packets dropped as expected but I can not see statistics
with ethtool command like below.
#ethtool -S enp7s0f0 | grep xdp

ethtool version is 4.8
I did my test with that NIC
Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)

I wonder why I can't see statistics. Did I miss something while
compiling kernel or iproute? Should I also compile ethtool too?

--
Ibrahim Ercan
