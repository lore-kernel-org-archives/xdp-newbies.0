Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgHRHEM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 18 Aug 2020 03:04:12 -0400
Received: from mailg210.ethz.ch (mailg210.ethz.ch [IPv6:2001:67c:10ec:5606::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AF7C061389
        for <xdp-newbies@vger.kernel.org>; Tue, 18 Aug 2020 00:04:10 -0700 (PDT)
From: =?UTF-8?Q?Michael_A=2e_Fl=c3=bcckiger?= <fmichael@student.ethz.ch>
Subject: XDP and AF_XDP
Message-ID: <44904e04-b9f5-0e9e-9b67-8ccfeded852e@student.ethz.ch>
Date: Tue, 18 Aug 2020 08:49:03 +0200
MIME-Version: 1.0
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: xdp-newbies@vger.kernel.org

Hi all

I've recently discovered XDP / AF_XDP, and I now familiarize myself with 
the very interesting technology. Two questions came up, and I'm sure 
that the XDP community will be able to answer them a lot faster than if 
I search for documents in the www jungle.. :)

- An user land application is able to read and process incoming data 
directly from the AF_XDP socket. I'm wondering what happens when an 
application writes data into the AF_XDP socket? Are these frames 
directly sent out on the respective network interface?

- Whats the current status on XDP support on TX? Is it possible to 
intercept the TX queue (outgoing packets) or is still "just" the 
processing of incoming packets possible? Where could I find documents 
covering such updates?

Thanks for your effort!

Best,

Michi
