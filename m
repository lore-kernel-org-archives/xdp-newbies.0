Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgFDLk3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jun 2020 07:40:29 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38F6C03E96D
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 04:40:28 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id k13so3292557vsm.13
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Jun 2020 04:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <dd7946c400c544feac167dab0ff4f974@hm.edu>
In-Reply-To: <dd7946c400c544feac167dab0ff4f974@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Thu, 4 Jun 2020 13:40:17 +0200
Message-ID: <CAJ8uoz2kCCmGC_+0uZiZnL4msWLYjoaW-fLB0arzK1FfMtPGDQ@mail.gmail.com>
Subject: Re: Dynamically adding new multicast streams
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Thu, Jun 4, 2020 at 1:19 PM Gaul, Maximilian <maximilian.gaul@hm.edu> wrote:
>
> Hello everyone,
>
> I try to dynamically add new multicast streams by creating a new AF-XDP socket bound to a RX-Queue.
> I also create a new ethtool-rule to steer the flow of the multicast stream towards that RX-Queue.
>
> My BPF program has a Hash-Map which maps a struct consisting of { src-ip, dst-ip, dst-port } to an index in the XSKMap (which is then used to redirect an incoming packet).
> So adding a new AF-XDP socket also means adding a new entry to that Hash-Map (and to the XSKMap).
>
> Now what I am experiencing is that the moment I add a new XSK, other already running sockets are loosing some packets (around 10ms worth of packets).
> I don't experience any packet loss afterwards.
>
> My question is: Is there something happening inside the XSK- or HashMap which could cause other packet streams to drop packets?

What NIC are you running on?

/Magnus

> I am not using Shared Umem, just launching a new process which starts that XSK.
>
> Best regards
>
> Max
