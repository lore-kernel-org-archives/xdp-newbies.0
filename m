Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f51.google.com ([209.85.128.51]:51316 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfHGUsy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 7 Aug 2019 16:48:54 -0400
Received: by mail-wm1-f51.google.com with SMTP id 207so216320wma.1
        for <xdp-newbies@vger.kernel.org>; Wed, 07 Aug 2019 13:48:53 -0700 (PDT)
MIME-Version: 1.0
From: Kal Cutter Conley <kal.conley@dectris.com>
Date: Wed, 7 Aug 2019 22:48:40 +0200
Message-ID: <CAHApi-mbMMx5bhdyfoLuiw7V3qML3L8f+N-+ReQ9XmAKH_2q8A@mail.gmail.com>
Subject: i40e: Kernel freezes with XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,
I am trying to get AF_XDP working with the i40e driver (Ethernet
Controller X710 for 10GbE SFP+). After bind() with XDP_ZEROCOPY the
kernel (machine) freezes hard. I have reproduced this on varying
kernel versions between 5.1 and 5.3-rc3 with 5.3 kernels freezing
also, but at a later stage. I tried replacing my XDP program with a
trivial one that simply returns XDP_PASS but it didn't help. On the
same system, the xdpsock sample does appear to work with the -z flag,
however. Are there any current known issues that could be causing
this? I will try to extract a minimal example that exercises the
freeze.

Thanks,
Kal
