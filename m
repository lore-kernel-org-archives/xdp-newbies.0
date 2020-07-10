Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJDEM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 9 Jul 2020 23:04:12 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106D5C08C5CE
        for <xdp-newbies@vger.kernel.org>; Thu,  9 Jul 2020 20:04:12 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id q15so4279770wmj.2
        for <xdp-newbies@vger.kernel.org>; Thu, 09 Jul 2020 20:04:11 -0700 (PDT)
Received: from ?IPv6:2a01:4c8:53:b80f:cec:6ee:dab9:67b9? ([2a01:4c8:53:b80f:cec:6ee:dab9:67b9])
        by smtp.gmail.com with ESMTPSA id p25sm6757408wmg.39.2020.07.09.20.04.09
        for <xdp-newbies@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 20:04:09 -0700 (PDT)
From: Cameron Boness <xdevps3@gmail.com>
Mime-Version: 1.0 (1.0)
Date: Fri, 10 Jul 2020 04:04:08 +0100
Subject: TCP Payload
Message-Id: <449BEAB8-F4ED-489D-BF59-8993637268DB@gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
To: xdp-newbies@vger.kernel.org

Hi,

I want to be able to read the data being sent in TCP payloads using XDP (in=
 c), but so far all I can read is a number of headers (eth->iph->tcp->dns).=
 Is it possible to get the TCP payload (i.e. client sent data) from xdp_md =
at all? Been looking online for hours, doesn't seem like anyone who's done =
XDP that's posted about it has ever parsed such data, hoping it's possible =
:(

Thanks
