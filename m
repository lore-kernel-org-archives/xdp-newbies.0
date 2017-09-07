Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33822 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755840AbdIGVho (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Sep 2017 17:37:44 -0400
Received: by mail-oi0-f49.google.com with SMTP id l74so1180702oih.1
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 14:37:44 -0700 (PDT)
MIME-Version: 1.0
From: Kiran T <kiran.lkml@gmail.com>
Date: Thu, 7 Sep 2017 14:37:42 -0700
Message-ID: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
Subject: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,
The samples and test cases have examples showing how user space
programs can pin maps and get pinned maps as FDs.  However, how would
one access a user-space created pinned map from kernel space, without
having to statically have a 'maps' section defined (and depend on the
elf loader)?

Thanks,
Kiran
