Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgGTIPL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 Jul 2020 04:15:11 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA903C061794
        for <xdp-newbies@vger.kernel.org>; Mon, 20 Jul 2020 01:15:11 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id v8so16668083iox.2
        for <xdp-newbies@vger.kernel.org>; Mon, 20 Jul 2020 01:15:11 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Petrovsky <askjuise@gmail.com>
Date: Mon, 20 Jul 2020 11:15:52 +0300
Message-ID: <CAH57y_Rxm9_eB5jyjJ2OryLd6HB6mXSG8s-MR3BWs-99PVNG0g@mail.gmail.com>
Subject: IP fragmentation
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: xdp-newbies@vger.kernel.org

Hello!

I have the eBPF/XDP based balancing router, it looks like facebook
katran, but a little bit smarter, we use random based balancing
algorithm, so also we have to learn how to sync connections between
nodes.

But, the main problem for us it's fragmented IP packets. Some times
ago I tried to use for such packets AF_XDP, fast pass them into the
user space, accumulate and after that pass back to the network, it was
a PoC. So, I wonder, is some chance that IP de-fragmentation functions
will be added into XDP?

Also, I have a strange idea, I could store such fragmented packets in
the LRU map, the original fragmented IP packet I could drop. When all
the fragments stored, I could make the decision about the destination
for balancing/routing. But now, here come problems, seems I could
construct a big packet / jumbo frame, but it seems a little bit ugly.
How could I emit all fragments from the map to the network after I've
got the last fragment?

-- 
Alexander Petrovsky
