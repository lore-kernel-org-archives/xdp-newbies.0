Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f42.google.com ([209.85.208.42]:40927 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfG2X1O (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 29 Jul 2019 19:27:14 -0400
Received: by mail-ed1-f42.google.com with SMTP id k8so60852001eds.7
        for <xdp-newbies@vger.kernel.org>; Mon, 29 Jul 2019 16:27:13 -0700 (PDT)
MIME-Version: 1.0
From: Zvi Effron <zeffron@riotgames.com>
Date: Mon, 29 Jul 2019 16:27:01 -0700
Message-ID: <CAC1LvL3xoHQo_oNJEVa4DeZ3G9R6Z61ukScRuMq5UrnRCHWo1g@mail.gmail.com>
Subject: Intel 800 series 100Gbe NIC with XDP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Hello all,

I was wondering if anyone knew if the upcoming 800 series Intel NICs
with 100gbe support XDP? I don't yet see a new driver for them, but
they may be reusing the i40e driver, or I may have missed it? If they
do support it, do they maybe also support hardware mode (as opposed to
driver mode)?

Thanks!
--Zvi
