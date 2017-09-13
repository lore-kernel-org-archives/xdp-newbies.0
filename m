Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:48978 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdIMM4j (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Sep 2017 08:56:39 -0400
Received: by mail-it0-f48.google.com with SMTP id c195so2267476itb.1
        for <xdp-newbies@vger.kernel.org>; Wed, 13 Sep 2017 05:56:38 -0700 (PDT)
MIME-Version: 1.0
From: Tomaz Buh <hubber.iskratel@gmail.com>
Date: Wed, 13 Sep 2017 14:56:38 +0200
Message-ID: <CAHALiH5E4N+1m_E=AVnVi5esew7jC7U4mRcfg4YyoooyJdg4ow@mail.gmail.com>
Subject: MAC addresses and XDP_TX
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello.
I'm trying to modify packets within the BPF program and send them to
another IP address through the same NIC with the XDP_TX call
(ultimately I'm trying to do a RTP proxy sample).
What I'm missing is the MAC address for the IP, which can be normally
obtained from the ARP table.
I can see two solutions for dynamic sending:
-search the kernel tables for ARP entries,
-produce ARP reqests and have own ARP table.

Is any of the solutions possible with the current implementation?
Is there any better solution?

Kind regards,
Tomaz
