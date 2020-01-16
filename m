Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-io1-f54.google.com ([209.85.166.54]:45966 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729661AbgAPEWq (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 23:22:46 -0500
Received: by mail-io1-f54.google.com with SMTP id i11so20270414ioi.12
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 20:22:46 -0800 (PST)
Subject: Re: XDP invalid memory access
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
 <87ftggtl7t.fsf@toke.dk>
 <CAK86TEcyRqVrB-OOiCxtM6WLMp-Sr_+eO9G70+T=OMpF2KBrgQ@mail.gmail.com>
 <99fe90fe-cbb4-1ff1-156b-bd8053293aca@gmail.com>
 <CAK86TEcGAkmPLeYACWGtLT0CJPZqGYCqZDpZSO=0x4_ph0qcUA@mail.gmail.com>
 <CAK86TEe8Je6NjLWzRHoMhDgqKyhqYd7pX2awmAUTQ7V3GCcKAA@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <ae0f349a-67a7-9c52-e48c-9c713e484af9@gmail.com>
Date: Wed, 15 Jan 2020 21:22:44 -0700
MIME-Version: 1.0
In-Reply-To: <CAK86TEe8Je6NjLWzRHoMhDgqKyhqYd7pX2awmAUTQ7V3GCcKAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Vincent Li <mchun.li@gmail.com>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, xdp-newbies@vger.kernel.org

On 1/15/20 8:19 PM, Vincent Li wrote:
> 
>  59         if (tcphdr->syn) {
> 
>  60                 if (((void *)(tcphdr + 1) + tcphdr->doff*4) > data_end)
> 
>  61                         return 0;
> 
>  62                 optlen = tcphdr->doff*4 - sizeof(*tcphdr);
> 
>  63                 for (i = 0; i < optlen; ) {

A variable length loop counter. Change this to just look at i = 0 (no
loop) and see if it loads.
