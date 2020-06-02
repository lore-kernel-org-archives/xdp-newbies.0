Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgFBPPi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 2 Jun 2020 11:15:38 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53635C08C5C0
        for <xdp-newbies@vger.kernel.org>; Tue,  2 Jun 2020 08:15:38 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g1so9500341edv.6
        for <xdp-newbies@vger.kernel.org>; Tue, 02 Jun 2020 08:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com>
 <87d06hzvr8.fsf@toke.dk>
In-Reply-To: <87d06hzvr8.fsf@toke.dk>
From: maharishi bhargava <bhargavamaharishi@gmail.com>
Date: Tue, 2 Jun 2020 20:45:25 +0530
Message-ID: <CA+Jwd2z4_tGfh9wS_CJQL36O_vYyv5knXkm6=A+UvNNtojEcrw@mail.gmail.com>
Subject: Re: XDP_REDIRECT with xsks_map and dev_map
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: xdp-newbies@vger.kernel.org

On Tue 2 Jun, 2020, 14:31 Toke Høiland-Jørgensen, <toke@redhat.com> wrote:
>
> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>
> > Hi, in my XDP program, I want to redirect some packets using AF_XDP
> > and redirect other packets directly from driver space.
> > Redirection through AF_XDP works fine, but redirection through dev map
> > stops after some packets are processed.
>
> Do you mean it stops even if you are *only* redirecting to a devmap, or
> if you are first redirecting a few packets to AF_XDP, then to devmap?
>
> Also, which driver(s) are the physical NICs you're redirecting to/from
> using, and which kernel version are you on?
>
> -Toke



Currently, I'm trying to redirect packets only using devmap. But also
have code for redirection using AF_XDP(only when a given condition is
satisfied). A DPDK program is running in userspace which will receive
packets from AF_XDP.

Drivers: ixgbe (2x10GbE Intel NIC)
Kernel version 5.3

- Maharishi Bhargava
