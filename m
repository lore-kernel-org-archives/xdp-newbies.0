Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f173.google.com ([209.85.167.173]:45435 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbeJSM3K (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 19 Oct 2018 08:29:10 -0400
Received: by mail-oi1-f173.google.com with SMTP id e17-v6so25816634oig.12
        for <xdp-newbies@vger.kernel.org>; Thu, 18 Oct 2018 21:24:52 -0700 (PDT)
MIME-Version: 1.0
From: Latta Kia <lattakia2018@gmail.com>
Date: Thu, 18 Oct 2018 21:24:41 -0700
Message-ID: <CAHP=hQPDZSLbd3CZ4qhvv54ZAMZzxTUrYGvD3ZtSkqu-TheFSA@mail.gmail.com>
Subject: Unable to install a test XDP program on virtio_net device
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

I am on a 4.18.13 kernel. Debian Stretch. The XDP samples and
selftests compiled fine.

When I tried to install my XDP prog like so:

$ sudo /sbin/ip link set eth0 xdpdrv obj helloworld_xdp.o sec prog
XDP expects header/data in single page, any_header_sg required
...snipped...

This is the if condition that caused it to fail.
https://elixir.bootlin.com/linux/v4.18.13/source/drivers/net/virtio_net.c#L2265

Is this fixable? i.e. some configuration on the virtio_net part ? Thanks

L
