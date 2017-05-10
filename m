Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752110AbdEJJvk (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 May 2017 05:51:40 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D529C057FA5
        for <xdp-newbies@vger.kernel.org>; Wed, 10 May 2017 09:51:39 +0000 (UTC)
Date: Wed, 10 May 2017 11:51:34 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: XDP eBPF tutorial presentation given at LLC2017
Message-ID: <20170510115134.6b6c726e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies <xdp-newbies@vger.kernel.org>
Cc: brouer@redhat.com

Hi All XDP-newbies,

I recently gave a presentation[1] about how to write XDP eBPF programs,
at LundLinuxCon[2].  The example is a ready to use XDP DDoS protection
program, which does IPv4 blacklisting, and is available on GitHub[3].

I hope people will find this useful, and start writing their own DDoS
protection XDP/eBPF programs.  Such that we can build up an arsenal of
small XDP programs that can handle different types of DDoS attacks.


[1] http://people.netfilter.org/hawk/presentations/LLC2017/
[2] https://lundlinuxcon.org/
[3] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf
[4] https://twitter.com/JesperBrouer/status/860139907376984064
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
