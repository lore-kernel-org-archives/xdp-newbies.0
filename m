Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:46420 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeABXoM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 2 Jan 2018 18:44:12 -0500
Received: by mail-pf0-f181.google.com with SMTP id c204so13092pfc.13
        for <xdp-newbies@vger.kernel.org>; Tue, 02 Jan 2018 15:44:12 -0800 (PST)
MIME-Version: 1.0
From: "MD I. Islam" <tamim@csebuet.org>
Date: Tue, 2 Jan 2018 18:43:50 -0500
Message-ID: <CAM7NYTiEcKY-ARx-H2Lz43=QFHEqC1Ou2Qedxz+mxb1Lzosu-w@mail.gmail.com>
Subject: Getting __sk_buff from NAPI poll
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi

Is it possible to get a batch of xdp_md or __sk_buff from NAPI poll
(instead of sk_buff)?

Thanks
Tamim
