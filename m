Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgFAHue (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 1 Jun 2020 03:50:34 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A292C061A0E
        for <xdp-newbies@vger.kernel.org>; Mon,  1 Jun 2020 00:50:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id z5so8357760ejb.3
        for <xdp-newbies@vger.kernel.org>; Mon, 01 Jun 2020 00:50:34 -0700 (PDT)
MIME-Version: 1.0
From: maharishi bhargava <bhargavamaharishi@gmail.com>
Date: Mon, 1 Jun 2020 13:20:20 +0530
Message-ID: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com>
Subject: XDP_REDIRECT with xsks_map and dev_map
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: xdp-newbies@vger.kernel.org

Hi, in my XDP program, I want to redirect some packets using AF_XDP
and redirect other packets directly from driver space.
Redirection through AF_XDP works fine, but redirection through dev map
stops after some packets are processed.
What can be the possible issues and solutions?

Thanks,
Maharishi Bhargava
