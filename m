Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f45.google.com ([209.85.208.45]:35739 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAOWbw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 17:31:52 -0500
Received: by mail-ed1-f45.google.com with SMTP id f8so17074838edv.2
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 14:31:51 -0800 (PST)
MIME-Version: 1.0
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
 <87ftggtl7t.fsf@toke.dk>
In-Reply-To: <87ftggtl7t.fsf@toke.dk>
From: Vincent Li <mchun.li@gmail.com>
Date: Wed, 15 Jan 2020 14:31:39 -0800
Message-ID: <CAK86TEcyRqVrB-OOiCxtM6WLMp-Sr_+eO9G70+T=OMpF2KBrgQ@mail.gmail.com>
Subject: Re: XDP invalid memory access
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc: xdp-newbies@vger.kernel.org

On Wed, Jan 15, 2020 at 2:21 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> You have to check that you're not reading out of bounds before
> dereferencing the bytes in the TCP header...
>

I have below before the optlen

   47 /* sanity check needed by the eBPF verifier */

    48 if ((void *)(tcphdr + 1) > data_end)

    49 return 0;

this is not enough, how do I check the out of bounds properly?

Regards,

Vincent
