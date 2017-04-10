Return-path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752312AbdDJUin (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Apr 2017 16:38:43 -0400
Date: Mon, 10 Apr 2017 22:38:35 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: XDP requirements on the NIC
Message-ID: <20170410223835.20f68f5a@redhat.com>
In-Reply-To: <20170409.191406.134792229765947007.davem@davemloft.net>
References: <c892233e-68b4-6277-c42c-b2fbfc1e872d@gmail.com>
        <20170409.191406.134792229765947007.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: David Miller <davem@davemloft.net>
Cc: f.fainelli@gmail.com, xdp-newbies@vger.kernel.org, brouer@redhat.com, Alexander Duyck <alexander.duyck@gmail.com>

On Sun, 09 Apr 2017 19:14:06 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Sun, 9 Apr 2017 19:05:39 -0700
> 
> > In order for a NIC and its driver to support XDP, it sounds like we need:
> > 
> > - page-based RX  
> 
> Not exactly.

The requirement is actually that the packet-page is _writable_.
These packet-pages come from the NIC DMA engine, and this complicates
keeping them writable, in the case where a RX-page is used for
containing two (or more) packets.  Careful use of the DMA API does make
it possible to page packet sharing to co-exist with XDP (consult Alex
Duyck to review such driver changes).

> > - TX multiqueue support  
> 
> Also, not really required.
> 
> What you need to be able to do is to provide enough space in each
> RX buffer for:
> 
> 1) a full size frame
> 2) 256 bytes (XDP_PACKET_HEADROOM) of headroom
> 
> This is XDP's main set of requirements, a linear buffer and enough
> room to push XDP_PACKET_HEADROOM's worth of headers.

True.
 
> Then if you want to be able to easily wrap the RX packet into an SKB
> for XDP_PASS, you need to have enough tailroom for skb_shared_info()
> which you basically give to something like build_skb().

True this is a stack requirement.

> If you look at __build_skb() it's comment states "Caller provides
> space holding head and skb_shared_info".
> 
> For XDP_TX you just have to be able to queue up a raw skb'less packet
> into your transmit queue.  TX multiqueue is not required for this to
> work.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
