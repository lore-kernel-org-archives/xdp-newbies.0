Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f170.google.com ([209.85.166.170]:38298 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbeLSQve (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 19 Dec 2018 11:51:34 -0500
Received: by mail-it1-f170.google.com with SMTP id h65so10272577ith.3
        for <xdp-newbies@vger.kernel.org>; Wed, 19 Dec 2018 08:51:33 -0800 (PST)
MIME-Version: 1.0
From: Pavel Popa <pashinho1990@gmail.com>
Date: Wed, 19 Dec 2018 17:51:21 +0100
Message-ID: <CAHOxX0w+K0u2vQbrAJ0kHG+XQjAqCSZY6SRTZCwWVXyzWQ_D0A@mail.gmail.com>
Subject: Debugging cpumap_kthread drops
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,

I'm encountering the following log line "xdp_cpumap_kthread: kthread
cpu=0 map_id=155 action=REDIRECT processed=1 drops=1 sched=1", and as
you can see the "drops" counter is =1, thus not good. Is there any way
to know the reason of such error? This is triggered when the IP dst
address of a to be forwarded packet doesn't have a corresponding ARP
entry, so what the XDP program does is basically redirecting the
packet to a different CPU core for the net stack processing which will
perform ARP, at least that's the intent. I should say that it
perfectly worked some days ago, but now I'm encountering this. So, is
there any possible way to debug deeper in a "xdp_cpumap_kthread
drops"?

Thank you
