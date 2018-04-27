Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36405 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932424AbeD0Nl5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 27 Apr 2018 09:41:57 -0400
Received: by mail-oi0-f41.google.com with SMTP id v2-v6so1607842oif.3
        for <xdp-newbies@vger.kernel.org>; Fri, 27 Apr 2018 06:41:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fd4bc543-a590-ab95-145e-0b3a76e6b892@solarflare.com>
References: <CAArOQ2UJDD-kA3O9h-MZTedhyRfXg4UC=QM-Hdw9tzPoe__ZvQ@mail.gmail.com>
 <fd4bc543-a590-ab95-145e-0b3a76e6b892@solarflare.com>
From: Bobby Powers <bobbypowers@gmail.com>
Date: Fri, 27 Apr 2018 09:41:55 -0400
Message-ID: <CAArOQ2X+VfNCejk8HwqfZ38Ed253EShshvXkL-=Ay_bd9ahPuQ@mail.gmail.com>
Subject: Re: egress packet filtering
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Edward Cree <ecree@solarflare.com>
Cc: xdp-newbies@vger.kernel.org

On Fri, Apr 27, 2018 at 9:36 AM, Edward Cree <ecree@solarflare.com> wrote:
> The higher performance of XDP is because the processing, being done in
>  the driver, happens earlier in the RX path (thus avoiding the bulk of
>  network stack processing for packets that e.g. are only going to be
>  dropped anyway).
> But on TX, the analogous driver code would be the _last_ thing in the
>  path, rather than the first, so in such a case the `tc` approach
>  should probably perform better than an XDP analogue.

Thanks, that is super useful for my mental model!

Does that mean it is possible (if slow) to use an XDP filter for TX?
I attached a simple one based on the DDOS filter from here:

https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf

that just debug logged IPs + ports, and I only seemed to see incoming
(and not outgoing) packets in the logs.  Is there a different/extra
flag to pass to have an XDP filter run on TX?


yours,
Bobby
