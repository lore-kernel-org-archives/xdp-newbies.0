Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:32808 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbeAZV6x (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 26 Jan 2018 16:58:53 -0500
Message-ID: <1517003922.24241.10.camel@regit.org>
Subject: Limit on max_entries of CPU_ARRAY_MAP
From: Eric Leblond <eric@regit.org>
Date: Fri, 26 Jan 2018 22:58:42 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>

Hello,

I've just finished the initial version of eBPF and XDP support in
Suricata [1] (thanks Jesper for the help) and among other eBPF features
the code is using CPU_ARRAY_MAP to store a flow table in Ipv4 and IPv6.

The max_entries is set to 32768 in the code [2] but I did give a try to
higher value. On my 8 cores system, the allocation of the memory for
the IPv6 table failed between 2000000 and 3000000.

Is there some kind of hard limit or a formula to compute the max ?

How will evolve performances if we increase the max_entries ?

Link:
[1]: https://github.com/OISF/suricata/pull/3193
[2]: https://github.com/OISF/suricata/pull/3193/files#diff-97ad4f31d96b
db666457562cea00a57aR85

Best regards,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
