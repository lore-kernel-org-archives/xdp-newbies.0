Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:44261 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdL2FTd (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 29 Dec 2017 00:19:33 -0500
Received: by mail-oi0-f47.google.com with SMTP id g6so12257592oib.11
        for <xdp-newbies@vger.kernel.org>; Thu, 28 Dec 2017 21:19:33 -0800 (PST)
Date: Thu, 28 Dec 2017 21:19:26 -0800
In-Reply-To: <cc903869-4a06-6038-d17d-42daf3362969@gmail.com>
References: <CAM7NYTiM2CtPPm4u3Rr9G0zRZrpmZq_3Rcb0H3dyS1xFZ+LzMA@mail.gmail.com> <cc903869-4a06-6038-d17d-42daf3362969@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: IP forwarding and eBPF
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <DE933F2D-F7BC-41E7-A297-FD006AA6E738@gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: David Ahern <dsahern@gmail.com>, "MD I. Islam" <tamim@csebuet.org>, xdp-newbies@vger.kernel.org

On December 28, 2017 8:34:24 PM PST, David Ahern <dsahern@gmail.com> wrote:
>On 12/28/17 9:37 PM, MD I. Islam wrote:
>> Hi
>> 
>> Is XDP designed for implementing packet forwarding? Is there an
>> example of ipv4 forwarding the kernel? I don't find any example in
>> samples/bpf/ directory.
>
>samples/bpf/xdp_router_ipv4_*.c
>
>I have a POC on using new helpers that allow BPF programs to leverage
>kernel FIB and neighbor tables:
>   https://github.com/dsahern/linux/commits/bpf/xdp-fwding-wip
>
>It shows a 400% increase in forwarding. A lot of issues need to be
>addressed, but it shows the intent.

Nice! What would be uber cool is a NATP fastpath implemented using XDP. Now that eBPF for ARM32 has landed it would enable a lot of platforms.

-- 
Florian
