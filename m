Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgFDNBX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jun 2020 09:01:23 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410C7C08C5C0
        for <xdp-newbies@vger.kernel.org>; Thu,  4 Jun 2020 06:01:23 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id r11so3456710vsj.5
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Jun 2020 06:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <dd7946c400c544feac167dab0ff4f974@hm.edu> <CAJ8uoz2kCCmGC_+0uZiZnL4msWLYjoaW-fLB0arzK1FfMtPGDQ@mail.gmail.com>
 <8e61772f33674b54b1548198fb55bd4b@hm.edu>
In-Reply-To: <8e61772f33674b54b1548198fb55bd4b@hm.edu>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Thu, 4 Jun 2020 15:01:10 +0200
Message-ID: <CAJ8uoz0VC-DFuS6YM7gZ2fcSz1suf+LSsNSt-1Efpkeptv1W7Q@mail.gmail.com>
Subject: Re: Dynamically adding new multicast streams
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "Gaul, Maximilian" <maximilian.gaul@hm.edu>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Thu, Jun 4, 2020 at 1:59 PM Gaul, Maximilian <maximilian.gaul@hm.edu> wrote:
>
> > What NIC are you running on?
> >
> > /Magnus
>
> Hi Magnus,
>
> I am using a MT27800 Family [ConnectX-5].
>
> There probably is something wrong with my code I just wanted to know before going into heavy debugging whether this is something that shouldn't be done.

You should be able to do that. I do not know how the ConnectX-5 driver
is implemented, but might there be a time period in which it does not
serve packets because the NIC is being reconfigured for the added
queue?

/Magnus

> Max
>
