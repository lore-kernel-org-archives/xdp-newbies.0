Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36468 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbeIYFUa (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Sep 2018 01:20:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id y13-v6so6895775wmi.1
        for <xdp-newbies@vger.kernel.org>; Mon, 24 Sep 2018 16:15:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
In-Reply-To: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
From: Justin Azoff <justin.azoff@gmail.com>
Date: Mon, 24 Sep 2018 18:15:42 -0500
Message-ID: <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
Subject: Re: AF_XDP umem and jumbo frames?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: aforster@cloudflare.com
Cc: xdp-newbies@vger.kernel.org

I don't know if this affects AF_XDP as well, but XDP does not support
jumbo frames at all:

https://prototype-kernel.readthedocs.io/en/latest/networking/XDP/design/requirements.html#page-per-packet

On my test box running 4.18 if XDP is in use the MTU can not be set
higher than 3050.

On Mon, Sep 24, 2018 at 4:53 PM Alex Forster <aforster@cloudflare.com> wrote:
>
> What happens in the case where umem's chunk size is smaller than the
> NIC frame size, like when jumbo frames are enabled? I.e, a NIC using
> MTU ~9000 on an x86-64 machine with a page size of 4096.
>
> Alex Forster



-- 
- Justin
