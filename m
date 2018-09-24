Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f52.google.com ([209.85.128.52]:53443 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbeIYD51 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 24 Sep 2018 23:57:27 -0400
Received: by mail-wm1-f52.google.com with SMTP id b19-v6so11262773wme.3
        for <xdp-newbies@vger.kernel.org>; Mon, 24 Sep 2018 14:53:09 -0700 (PDT)
MIME-Version: 1.0
From: Alex Forster <aforster@cloudflare.com>
Date: Mon, 24 Sep 2018 16:52:57 -0500
Message-ID: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
Subject: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

What happens in the case where umem's chunk size is smaller than the
NIC frame size, like when jumbo frames are enabled? I.e, a NIC using
MTU ~9000 on an x86-64 machine with a page size of 4096.

Alex Forster
