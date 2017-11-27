Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:43074 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbdK0Xdc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Nov 2017 18:33:32 -0500
Received: by mail-pf0-f177.google.com with SMTP id r68so11936873pfe.10
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Nov 2017 15:33:31 -0800 (PST)
MIME-Version: 1.0
From: "MD I. Islam" <tamim@csebuet.org>
Date: Mon, 27 Nov 2017 18:33:10 -0500
Message-ID: <CAM7NYTgW1AnJ0C4H2YiXOegp0p3BHCtU5bB7WfbcDTvaYzHJmw@mail.gmail.com>
Subject: XDP on many-core NPU
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi

I was wondering if XDP can scale to many-core NPU (such as NPS-400
which has 256 cores)? I need to develop a XCP/RCP like application
that can achieve bare-metal performance on each core. The application
will run in a run-to-completion model. I see, DPDK can run userspace
application on each core. I'm wondering if XDP has anything like that?
Please let me know any suggestion.

Thanks
Tamim
