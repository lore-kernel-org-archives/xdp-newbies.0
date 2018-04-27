Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:35420 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932998AbeD0OAe (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 27 Apr 2018 10:00:34 -0400
Received: by mail-ot0-f171.google.com with SMTP id h8-v6so2128019otb.2
        for <xdp-newbies@vger.kernel.org>; Fri, 27 Apr 2018 07:00:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a0a2300a-44cb-6056-ef41-6bde47aa893e@solarflare.com>
References: <CAArOQ2UJDD-kA3O9h-MZTedhyRfXg4UC=QM-Hdw9tzPoe__ZvQ@mail.gmail.com>
 <fd4bc543-a590-ab95-145e-0b3a76e6b892@solarflare.com> <CAArOQ2X+VfNCejk8HwqfZ38Ed253EShshvXkL-=Ay_bd9ahPuQ@mail.gmail.com>
 <a0a2300a-44cb-6056-ef41-6bde47aa893e@solarflare.com>
From: Bobby Powers <bobbypowers@gmail.com>
Date: Fri, 27 Apr 2018 10:00:32 -0400
Message-ID: <CAArOQ2WRXS_Q=Zk7kkUw+p_=2b2hoau9KXyUK1Z8QsnPrcgx3A@mail.gmail.com>
Subject: Re: egress packet filtering
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Edward Cree <ecree@solarflare.com>
Cc: xdp-newbies@vger.kernel.org

On Fri, Apr 27, 2018 at 9:55 AM, Edward Cree <ecree@solarflare.com> wrote:
> No, there is no current support for running XDP on TX.  My previous
>  email was an attempt to explain why.

Got it, thanks!  Was attempting to discern between "it isn't a good
idea" vs. "it isn't currently possible".

yours,
Bobby
