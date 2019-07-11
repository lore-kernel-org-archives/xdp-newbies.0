Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f42.google.com ([209.85.208.42]:38673 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfGKVnN (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 11 Jul 2019 17:43:13 -0400
Received: by mail-ed1-f42.google.com with SMTP id r12so7323484edo.5
        for <xdp-newbies@vger.kernel.org>; Thu, 11 Jul 2019 14:43:12 -0700 (PDT)
MIME-Version: 1.0
From: Cody Haas <chaas@riotgames.com>
Date: Thu, 11 Jul 2019 14:43:01 -0700
Message-ID: <CAH7f-UJUTUT0YKYVMCjNaQzwN3=sFh62Bx7sBO85XyjuNyy4Fg@mail.gmail.com>
Subject: x710 Checksum Offloading with XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hey,

Trying to utilize TX checksum offloading while running an XDP
application; We're running on Fedora 28, using Intel x710 Network
Adapters in unison with the Intel i40e drivers and we've verified that
the Fedora sees that TX checksum offloading is enabled. On the
receiving side of an XDP_TX we don't see a proper checksum in the
transmitted packet. Is this due to XDP bypassing the Linux network
stack? If so, is there a way to have XDP instruct the driver to
conduct the TX checksum? Or is this intended behavior?

Thanks,
Cody
