Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f177.google.com ([209.85.166.177]:35438 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbeJ0Dv2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 26 Oct 2018 23:51:28 -0400
Received: by mail-it1-f177.google.com with SMTP id p64-v6so3003440itp.0
        for <xdp-newbies@vger.kernel.org>; Fri, 26 Oct 2018 12:13:14 -0700 (PDT)
MIME-Version: 1.0
From: Matthew Tejo <matthew.tejo@gmail.com>
Date: Fri, 26 Oct 2018 12:13:02 -0700
Message-ID: <CAKS0-=qXKuTVt+KuXZ08_1VU1reJkCf=v=oNiASbxVaKfcr3oA@mail.gmail.com>
Subject: New to xdp Cant find initial syn packet?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hey,
I started trying out xdp programs recently and I was comparing what
comes out of tcp dump and my test program. It seems like the first syn
in the packet never appears in my logged out put, the rest of the
packets do.

I am using a vm and using the loopback interface and a virtual one
created by docker, both will only start from the second outgoing
packet.

Tcpdump shows syn -> syn,ack -> ack. But the xdp program only starts
from syn,ack then ack. Im logging using bpf_trace_printk and put the
statement at the beginning of the section being loaded so something
should at least print every time?

Is there something Im over looking?

Thanks and let me know if I can clarify anything.
Matt
