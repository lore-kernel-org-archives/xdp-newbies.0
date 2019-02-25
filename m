Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f41.google.com ([209.85.128.41]:33185 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfBYJQ2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 04:16:28 -0500
Received: by mail-wm1-f41.google.com with SMTP id c13so1062924wmb.0
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 01:16:27 -0800 (PST)
MIME-Version: 1.0
From: papito favaro <papito.favaro@gmail.com>
Date: Mon, 25 Feb 2019 10:16:15 +0100
Message-ID: <CAM2iwTj2bymRNj9jpX817VEPGWt-Vw79mzE15s2j9fZ=H2KEqw@mail.gmail.com>
Subject: AF_XDP xdp_umem_reg.headroom XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi all,
I woulld like to understand if the behaviour i'm getting is correct.

When I configure the XDP_UMEM_REG in zerocopy mode with a headroom ==
0 on a i40e,
the driver (i guess) actually sets a headroom of 256.
if i set a headroom == 256 the driver sets a headroom of 512.

If this behaviour is correct, would be nice that the xdp_umem_reg
struct after the setsockopt call would contain the actual configured
headroom.

Thank you for your time
