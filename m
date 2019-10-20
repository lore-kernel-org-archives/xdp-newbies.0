Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f53.google.com ([209.85.208.53]:38450 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJTVH1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 20 Oct 2019 17:07:27 -0400
Received: by mail-ed1-f53.google.com with SMTP id l21so8454212edr.5
        for <xdp-newbies@vger.kernel.org>; Sun, 20 Oct 2019 14:07:25 -0700 (PDT)
MIME-Version: 1.0
From: Zvi Effron <zeffron@riotgames.com>
Date: Sun, 20 Oct 2019 16:07:13 -0500
Message-ID: <CAC1LvL3efhuf8dc-aQKepMND24drwVAHAzVs-4Np4CUTV8qOgQ@mail.gmail.com>
Subject: How to debug XDP_REDIRECT errors
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Hello,

I'm trying to get some additional performance out of XDP on the i40e
driver (under kernel 5.0.7, Fedora 28) by adjusting the queues to be
one per desired core. I have several cores isolated for network
traffic, so I'm adjusting the queues to be one per isolated core (with
IRQ adjustments to match) as opposed to the default of one per online
core. I've noticed that when I adjust the number of queues down, I see
packet loss proportional to the number of queues missing. For example,
if I drop the queues from the default of 36 down to 34, I see ~6%
packet loss.

Using the trace_pipe, I've managed to confirm that my program is
successfully calling bpf_redirect_map() for all of the packet (no
losst). I found the xdp_monitor tutorial[1] and ran it, and it shows
the loss showing up as XDP_REDIRECT errors (which I believe means the
raw_tracepoint xdp:xdp_redirect_map_err).

At this point, I'm a bit stuck on how to proceed further to determine
what is causing the redirect error and where the packet is being
dropped.

Any help in pointing me in the right direction for debugging
techniques would be greatly appreciated.

Thanks!
--Zvi

[1]: https://github.com/xdp-project/xdp-tutorial/blob/master/tracing02-xdp-monitor
