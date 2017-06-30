Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34938 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbdF3UGh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 30 Jun 2017 16:06:37 -0400
Received: by mail-pf0-f174.google.com with SMTP id c73so72019093pfk.2
        for <xdp-newbies@vger.kernel.org>; Fri, 30 Jun 2017 13:06:37 -0700 (PDT)
MIME-Version: 1.0
From: "MD I. Islam" <tamim@csebuet.org>
Date: Fri, 30 Jun 2017 16:06:16 -0400
Message-ID: <CAM7NYTgSGO4oOnN0-BOtUfgHEUowqk5q3jwtbuOtWz8Q+2FaXA@mail.gmail.com>
Subject: Queue length and active flows meta data
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi

I need to implement XCP[1] like protocol on data plane. To do this, I
need to know the queue length and the number of active flows. Is there
a way XDP or tc_cls exposes those information to eBPF program?

Thanks
Tamim

1. http://conferences.sigcomm.org/sigcomm/2002/papers/xcp.pdf
