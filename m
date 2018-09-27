Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f50.google.com ([209.85.210.50]:46023 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbeI0HLL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 27 Sep 2018 03:11:11 -0400
Received: by mail-ot1-f50.google.com with SMTP id c13-v6so850656otf.12
        for <xdp-newbies@vger.kernel.org>; Wed, 26 Sep 2018 17:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
 <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com> <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
In-Reply-To: <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
From: Rob Sherwood <rob.sherwood@gmail.com>
Date: Wed, 26 Sep 2018 17:55:24 -0700
Message-ID: <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: aforster@cloudflare.com
Cc: justin.azoff@gmail.com, xdp-newbies@vger.kernel.org

Thanks for the reference and the page-per-packet point makes sense.
At the same time, not supporting jumbo frames seems like a non-trivial
limitation.  Are there a subset of drivers that do support jumbo
frames (or LRO or the other features that require multiple pages per
packet)?

Thanks in advance,

- Rob
.
On Tue, Sep 25, 2018 at 9:44 AM Alex Forster <aforster@cloudflare.com> wrote:
>
> > On my test box running 4.18 if XDP is in use the MTU can not be set higher than 3050.
>
> Ah, that answers a few questions for me. Thanks!
>
> Alex Forster
