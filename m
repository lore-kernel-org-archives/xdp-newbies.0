Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731099AbgGaNEI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 Jul 2020 09:04:08 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1EEC061574
        for <xdp-newbies@vger.kernel.org>; Fri, 31 Jul 2020 06:04:08 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id y17so16177521ybm.12
        for <xdp-newbies@vger.kernel.org>; Fri, 31 Jul 2020 06:04:08 -0700 (PDT)
MIME-Version: 1.0
From: David Gohberg <gohberg@gmail.com>
Date: Fri, 31 Jul 2020 16:03:56 +0300
Message-ID: <CAE2Pf893-Y7svSxm68LPE3MbLrzxPqRDOuRuhJraYi564YWm6g@mail.gmail.com>
Subject: taking first steps with XDP
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: xdp-newbies@vger.kernel.org

Hello everyone,

My goal is to build a simple program that schedules sending an
heartbeat packet (sort of like an ICMP reply-response) to a list of IP
addresses (a few million of them) on regular intervals, and update
alive/dead software state for each address. I have a pcap
implementation but performance is subpar.

I understand that for the rx part, a simple xdp program that
intercepts the heartbeat reply and writes to some bpf map will be
sufficient. However, from what I read, in order to send packets in the
same path, I will need to use AF_XDP sockets and write a user-space
application that will have to deal with cpu cores, rings, queues,
umems and everything related. Since I don't really need to redirect
the heartbeat reply packet to user-space, just acknowledge that a
reply was received (that can happen in the XDP program) is there a
layer or library over AF_XDP that allows for a simpler tx API which
abstracts the underlying mechanisms I mentioned?
