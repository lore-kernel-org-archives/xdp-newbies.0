Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726374AbgHRKK0 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 18 Aug 2020 06:10:26 -0400
Received: by mail-wm1-f71.google.com with SMTP id d22so7217561wmd.2
        for <xdp-newbies@vger.kernel.org>; Tue, 18 Aug 2020 03:10:23 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP and AF_XDP
In-Reply-To: <44904e04-b9f5-0e9e-9b67-8ccfeded852e@student.ethz.ch>
References: <44904e04-b9f5-0e9e-9b67-8ccfeded852e@student.ethz.ch>
Date: Tue, 18 Aug 2020 12:10:16 +0200
Message-ID: <87lficuuwn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?utf-8?Q?Michael_A=2E_Fl=C3=BCckiger?= <fmichael@student.ethz.ch>, xdp-newbies@vger.kernel.org

Michael A. Flückiger <fmichael@student.ethz.ch> writes:

> Hi all
>
> I've recently discovered XDP / AF_XDP, and I now familiarize myself with 
> the very interesting technology. Two questions came up, and I'm sure 
> that the XDP community will be able to answer them a lot faster than if 
> I search for documents in the www jungle.. :)
>
> - An user land application is able to read and process incoming data 
> directly from the AF_XDP socket. I'm wondering what happens when an 
> application writes data into the AF_XDP socket? Are these frames 
> directly sent out on the respective network interface?

You can send packets from AF_XDP as well, but it's not a regular socket.
Please see the documentation here:
https://www.kernel.org/doc/html/latest/networking/af_xdp.html

> - Whats the current status on XDP support on TX? Is it possible to 
> intercept the TX queue (outgoing packets) or is still "just" the 
> processing of incoming packets possible? Where could I find documents 
> covering such updates?

There's no 'XDP TX' hook, but there are a few other options: When
redirecting packets via the bpf_redirect_map() helper, you can attach a
second XDP program to the map entries, which gives you a "post-redirect"
hook that is tied to the destination. This is analogous to an XDP hook
on TX, but only for packets that were redirected from XDP.

For packets coming from the regular networking stack, you can use the TC
eBPF hook to modify traffic instead; it is possible to write eBPF
programs that can be reused across the XDP and TC hooks (basically, by
putting the logic in a function that you call from a small wrapper
function in each hook type).

-Toke
