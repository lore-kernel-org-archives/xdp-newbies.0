Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:36546 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdEaJ3D (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 31 May 2017 05:29:03 -0400
Received: by mail-pg0-f42.google.com with SMTP id x64so5407638pgd.3
        for <xdp-newbies@vger.kernel.org>; Wed, 31 May 2017 02:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABWTmTqGtb5bH_vDz986AUNTrygdEubQskvoJ2oh1S=m8VwNbg@mail.gmail.com>
References: <CABWTmTqGtb5bH_vDz986AUNTrygdEubQskvoJ2oh1S=m8VwNbg@mail.gmail.com>
From: Jeffrey Panneman <jeffrey.panneman@student.uva.nl>
Date: Wed, 31 May 2017 11:29:02 +0200
Message-ID: <CABWTmTqaQh_YqMgt=Vh0SPqzdtLmVc=fSY2kJVYNFAA_h=1jkg@mail.gmail.com>
Subject: Fwd: Empty ethernet fram after XDP_TX
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I have recently started experimenting with XDP in regards to my master
thesis project. I have been playing around with some examples and had
a question regarding the following sample file from the linux kernel:
https://github.com/torvalds/linux/blob/master/samples/bpf/xdp2_kern.c

I have setup a test environment on which I can monitor both my source
and destination port using Wireshark. I observe that when I run the
example, always returning XDP_PASS, packets go on normal but the MAC
swapping does not occur. When using the XDP_TX return code after
swapping I observe that I see Ethernet frames appear in wireshark with
a source and destination 00:00:00:00:00:00. The IP related headers are
gone and this is the only thing I am seeing.

For some context, I am running on: 4.11.0-041100-generic x86_64 x86_64
x86_64 GNU/Linux using ConnectX-4 Lx cards with the mlx5_core driver
(from lspci -v output). From "systool -vm" output I see my mlx5_core
version is "4.0-2.0.0"

I was wondering if this behaviour was normal, and if anyone knows what
is going wrong here. I am happy to provide some more diagnostic
information if needed.

Kind regards,

Jeffrey
