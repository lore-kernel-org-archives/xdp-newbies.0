Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f46.google.com ([209.85.167.46]:43603 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfG3VVI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 30 Jul 2019 17:21:08 -0400
Received: by mail-lf1-f46.google.com with SMTP id c19so45790020lfm.10
        for <xdp-newbies@vger.kernel.org>; Tue, 30 Jul 2019 14:21:06 -0700 (PDT)
MIME-Version: 1.0
From: Rafael Vargas <vargas@khomp.com>
Date: Tue, 30 Jul 2019 18:20:53 -0300
Message-ID: <CAEaYocbC=x=fzXVJoKpHRXmK74-buEoqpSAvyuODRm3CH4k+Sw@mail.gmail.com>
Subject: Ajusting XSKMAP max_entries value
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi,

I'm using AF_XDP sockets to bulk read from the network device and it
seems to work fine.

Now I'm fine tuning my code in order to compatible in a broader range
of scenarios.

How should I set the size of my XSKMAP? As I'm creating one AF_XDP
socket for each RX queue, and using this as the map size, is this
correct?

As I'm using programs compiled using clang-bpf, is there a way to
change this value without having to recompile the program?

What would be the recommended way to setting this value correctly for
each interface?

Thanks!

Rafael Vargas
