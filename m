Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36040 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdKNGh2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Nov 2017 01:37:28 -0500
Date: Tue, 14 Nov 2017 15:37:26 +0900 (KST)
Message-Id: <20171114.153726.1131148784908217955.davem@davemloft.net>
Subject: Re: Packet forwarding in XDP
From: David Miller <davem@davemloft.net>
In-Reply-To: <065d37ce81c88c2cc0f9377805766858@cse.iitd.ac.in>
References: <bb1feffe7bf1e420b484e3963526748d@cse.iitd.ac.in>
        <20171112130024.3e18d0b2@redhat.com>
        <065d37ce81c88c2cc0f9377805766858@cse.iitd.ac.in>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: anmol07.visitor@cse.iitd.ac.in
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com

From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Date: Tue, 14 Nov 2017 12:03:23 +0530

> No bpf syscall, kernel headers too old?

Please enable CONFIG_BPF_SYSCALL in your kernel config.
