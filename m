Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37510 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730117AbgEZIEz (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 26 May 2020 04:04:55 -0400
Date: Tue, 26 May 2020 10:04:43 +0200
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Subject: Re: XDP_REDIRECT forwarding speed
Message-ID: <20200526100443.2c927057@carbon>
In-Reply-To: <AM0PR08MB3345DF6A3FABBCF262B39E968BB00@AM0PR08MB3345.eurprd08.prod.outlook.com>
References: <AM0PR08MB3345DF6A3FABBCF262B39E968BB00@AM0PR08MB3345.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Denis Salopek <Denis.Salopek@fer.hr>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>

On Tue, 26 May 2020 07:00:30 +0000
Denis Salopek <Denis.Salopek@fer.hr> wrote:

> I want to make sure I did everything right to make my XDP program
> (simple forwarding with bpf_redirect_map) as fast as possible. Is following
> advices and gotchas from this: 
> https://www.mail-archive.com/netdev@vger.kernel.org/msg184139.html
 
I prefer links to lore.kernel.org:
 [1] https://lore.kernel.org/netdev/20170821212506.1cb0d5d6@redhat.com/

Do notice that my results in [1] is for a single queue and single CPU.
In production I assume that you can likely scale this across more CPUs ;-)

> enough or are there some additional/newer recommendations? I managed
> to get near line-rate on my Intel X520s (on Ryzen 3700X and one
> queue/CPU), but not quite 14.88 Mpps so I was wondering is there
> something else to speed things up even more.

In [1] I mention the need to tune the TX-queue to keep up via either
adjusting the TX-DMA completion interrupt interval:

 Tuned with rx-usecs 25:
  ethtool -C ixgbe1 rx-usecs 25 ;\
  ethtool -C ixgbe2 rx-usecs 25

Or increasing the size of the TX-queue, so it doesn't overrun:

 Tuned with adjusting ring-queue sizes:
  ethtool -G ixgbe1 rx 1024 tx 1024 ;\
  ethtool -G ixgbe2 rx 1024 tx 1024

This might not be needed any longer, as I think it was Alexander, that
implemented an improved interrupt adjustment scheme for ixgbe.


> Also, are there any recommended settings/tweaks for bidirectional
> forwarding? I suppose there would be a drop in performance compared to
> single direction, but has anyone done any benchmarks?

As this was 1-CPU you can just run the other direction on another CPU.
That said, it can still be an advantage to run the bidirectional
traffic on the same CPU and RX-TX-queue pair, as above issue with
TX-queue DMA cleanups/completions goes away.  Because, the ixgbe driver
will do TX-cleanups as part (before) the RX-processing.

What is your use-case?
e.g. building an IPv4 router?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
