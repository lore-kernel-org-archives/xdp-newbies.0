Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:34175 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754395AbeFRBHD (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 17 Jun 2018 21:07:03 -0400
Received: by mail-pl0-f46.google.com with SMTP id g20-v6so8094926plq.1
        for <xdp-newbies@vger.kernel.org>; Sun, 17 Jun 2018 18:07:03 -0700 (PDT)
MIME-Version: 1.0
From: Zvi Effron <zeffron@riotgames.com>
Date: Sun, 17 Jun 2018 18:07:02 -0700
Message-ID: <CAC1LvL2x3=LRdMOmipEr-LZ5XwXVjirr1_oQcP305t0pfbPn1Q@mail.gmail.com>
Subject: Packet access from bpf_perf_event_output
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Hi XDPeople!

In /include/uapi/linux/bpf.h, (in 4.18-rc1) the comment describing
bpf_perf_event_output says:

/*
 * Note that this helper is not restricted to tracing use cases
 * and can be used with programs attached to TC or XDP as well,
 * where it allows for passing data to user space listeners. Data
 * can be:
 *
 * * Only custom structs,
 * * Only the packet payload, or
 * * A combination of both.
 */

This seems to imply that for both TC and XDP, the packet can be used
for passing data. When I try this, the verifier rejects the program
with "helper access to the packet is not allowed". Looking through the
kernel it doesn't look like bpf_perf_output_event has been tagged with
the appropriate metadata to allow it to access the packet structure,
either for TC or for XDP. Neither bpf_skb_event_output_proto nor
bpf_xdp_event_output_proto have pkt_acess set to true. Is the
documentation incorrect, should that metadata be updated to allow
packet access, or is there something I'm missing?

Thank you!
--Zvi
