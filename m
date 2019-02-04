Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f176.google.com ([209.85.166.176]:56244 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbfBDLMF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 4 Feb 2019 06:12:05 -0500
Received: by mail-it1-f176.google.com with SMTP id m62so20095054ith.5
        for <xdp-newbies@vger.kernel.org>; Mon, 04 Feb 2019 03:12:04 -0800 (PST)
MIME-Version: 1.0
From: Pavel Popa <pashinho1990@gmail.com>
Date: Mon, 4 Feb 2019 12:11:52 +0100
Message-ID: <CAHOxX0xSKGaEHiPy8xC=Rxs-juFn7tGwv1QrwgLj5b2DOJmQfw@mail.gmail.com>
Subject: AF_XDP fib lookup
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

Is there any way to perform routing in user-space with AF_XDP without
too much hassle? The only way I see at the moment is to replicate in
user-space the kernel's FIB state via RTNL events, and performing
afterwards the IP routing lookup using some LPM algorithm
implementation. Is there an "easier" way for doing this?

Thank you
