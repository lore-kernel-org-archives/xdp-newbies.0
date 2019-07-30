Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfG3KN5 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 30 Jul 2019 06:13:57 -0400
Date: Tue, 30 Jul 2019 12:13:49 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Intel 800 series 100Gbe NIC with XDP
Message-ID: <20190730121349.538b5299@carbon>
In-Reply-To: <CAC1LvL3xoHQo_oNJEVa4DeZ3G9R6Z61ukScRuMq5UrnRCHWo1g@mail.gmail.com>
References: <CAC1LvL3xoHQo_oNJEVa4DeZ3G9R6Z61ukScRuMq5UrnRCHWo1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, brouer@redhat.com, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, anirudh.venkataramanan@intel.com, Jesse Brandeburg <jesse.brandeburg@intel.com>

On Mon, 29 Jul 2019 16:27:01 -0700
Zvi Effron <zeffron@riotgames.com> wrote:

> Hello all,
> 
> I was wondering if anyone knew if the upcoming 800 series Intel NICs
> with 100gbe support XDP? I don't yet see a new driver for them, but
> they may be reusing the i40e driver, or I may have missed it? If they
> do support it, do they maybe also support hardware mode (as opposed to
> driver mode)?

Good to see that Intel customers are requesting XDP support, for new HW
and associated drivers.

AFAIK Linux kernel driver is called ICE for Intel 800 series NIC[1]
(which supports 100/50/25/10 Gbit/s Ethernet).  (p.s. I don't have this
hardware in my testlab).

It is located in the kernel tree[2]: drivers/net/ethernet/intel/ice/.
Reading and grepping the code for 'xdp', reveals that this driver
doesn't support XDP.  So, I guess you need to buy your 100G hardware
from another vendor, or convince Intel to add XDP support.


Code details: Strangely it looks like this driver always does a memcpy
of the headers into linear part of a 256 bytes SKB, and attach the
payload as a SKB "fragment". (I wonder why this was chosen?)
  It should still be easy to add a XDP step before doing this (in
ice_clean_rx_irq() just after call to ice_get_rx_buf())


[1] https://www.intel.com/content/www/us/en/architecture-and-technology/ethernet/introducing-800-series.html
[2] https://github.com/torvalds/linux/tree/master/drivers/net/ethernet/intel/ice
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
