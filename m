Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:38791 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbeFFWWS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 6 Jun 2018 18:22:18 -0400
Received: by mail-pg0-f47.google.com with SMTP id c9-v6so3681879pgf.5
        for <xdp-newbies@vger.kernel.org>; Wed, 06 Jun 2018 15:22:18 -0700 (PDT)
MIME-Version: 1.0
From: Zvi Effron <zeffron@riotgames.com>
Date: Wed, 6 Jun 2018 15:22:16 -0700
Message-ID: <CAC1LvL21L=Zo2_5NQhyDVr8ciPwyExMhuAO2-7MQ97OPuV5y9A@mail.gmail.com>
Subject: Is it possible to read from a dynamic offset in a packet?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Hi XDPeople!

I've been having great success with reading data from fixed offsets in
a packet/ethernet frame. But every time I try to read from a dynamic
offset (e.g. read the last byte in the packet by using the packet
length in the IP/UDP headers). It looks like once I add a register to
a packet pointer, the range is reset to 0, and no amount of
comparisons will restore a range.

Looking through the verifier code, I believe I found where the range
is getting set to 0
(https://elixir.bootlin.com/linux/latest/source/kernel/bpf/verifier.c#L2695),
and it looks like the risk of overflow
(https://elixir.bootlin.com/linux/latest/source/kernel/bpf/verifier.c#L3267)
is why the range doesn't get updated by later comparisons.

Is there a way to do a read from a packet at a dynamic offset? If not,
is that something that could potentially be added to the verifier? It
feels like `if (packet_start <= packet_start + offset && packet_end >
packet_start + offset)` is something that should be verifiable as
safe, even with potential overflow in `packet_start + offset`?

Thank you!
--Zvi
