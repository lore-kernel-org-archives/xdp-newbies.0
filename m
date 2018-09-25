Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f41.google.com ([209.85.221.41]:44826 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbeIYWvc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Sep 2018 18:51:32 -0400
Received: by mail-wr1-f41.google.com with SMTP id v16-v6so24065320wro.11
        for <xdp-newbies@vger.kernel.org>; Tue, 25 Sep 2018 09:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
 <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
In-Reply-To: <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
From: Alex Forster <aforster@cloudflare.com>
Date: Tue, 25 Sep 2018 11:43:01 -0500
Message-ID: <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: justin.azoff@gmail.com
Cc: xdp-newbies@vger.kernel.org

> On my test box running 4.18 if XDP is in use the MTU can not be set higher than 3050.

Ah, that answers a few questions for me. Thanks!

Alex Forster
