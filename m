Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:46491 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753732AbdL2Dha (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Dec 2017 22:37:30 -0500
Received: by mail-pg0-f42.google.com with SMTP id r2so5194857pgq.13
        for <xdp-newbies@vger.kernel.org>; Thu, 28 Dec 2017 19:37:30 -0800 (PST)
MIME-Version: 1.0
From: "MD I. Islam" <tamim@csebuet.org>
Date: Thu, 28 Dec 2017 22:37:09 -0500
Message-ID: <CAM7NYTiM2CtPPm4u3Rr9G0zRZrpmZq_3Rcb0H3dyS1xFZ+LzMA@mail.gmail.com>
Subject: IP forwarding and eBPF
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi

Is XDP designed for implementing packet forwarding? Is there an
example of ipv4 forwarding the kernel? I don't find any example in
samples/bpf/ directory.

I'm also looking at XDP implementation in i40e driver. Is there a
reason we need to use eBPF program for packet forwarding? Is it
possible to use percpu kernel thread  instead of an eBPF program? DPDK
creates user thread for each CPU core. Each user thread processes
packet independently in a lockless manner. I'm wondering if XDP can do
something like that inside kernel (possibly using workqueue). Looking
forward to your suggestions.

Many thanks
Tamim
PhD Candidate,
Kent State University
