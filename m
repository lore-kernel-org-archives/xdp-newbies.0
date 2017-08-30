Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:34764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdH3V5B (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 30 Aug 2017 17:57:01 -0400
Date: Wed, 30 Aug 2017 14:57:00 -0700 (PDT)
Message-Id: <20170830.145700.1785875505837122414.davem@davemloft.net>
Subject: Re: Issues with bpf_trace_printk
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAC1LvL1Kj6Q+XHm-RJdgoivTVCJQf-p1dyQ1DpG6ULjAd38rEQ@mail.gmail.com>
References: <CAC1LvL3svMDXSxe3ThoiDFe8f1mQwU8VhPp+2wtQ9gp2Wdg+Xg@mail.gmail.com>
        <59A72D3E.1030909@iogearbox.net>
        <CAC1LvL1Kj6Q+XHm-RJdgoivTVCJQf-p1dyQ1DpG6ULjAd38rEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: zeffron@riotgames.com
Cc: daniel@iogearbox.net, ys114321@gmail.com, xdp-newbies@vger.kernel.org

From: Zvi Effron <zeffron@riotgames.com>
Date: Wed, 30 Aug 2017 14:50:59 -0700

> I managed to set up my configuration with a VM on VMware Workstation,
> and it did not reproduce the bug. I think it was using one of the
> Intel drivers, though, instead of the generic. Is there a way to force
> the use of the generic driver?

Set XDP_FLAGS_SKB_MODE when you install the XDP program.

That will force generic XDP and bypass the device driver level
support.
