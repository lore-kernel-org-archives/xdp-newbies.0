Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbeADHPI (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 4 Jan 2018 02:15:08 -0500
Date: Thu, 4 Jan 2018 08:15:00 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: CPU redirect and skb mode
Message-ID: <20180104081500.73d55bd8@redhat.com>
In-Reply-To: <1515025109.7473.10.camel@regit.org>
References: <1515025109.7473.10.camel@regit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com


On Thu, 04 Jan 2018 01:18:29 +0100 Eric Leblond <eric@regit.org> wrote:

> Hello,
> 
> I'm currently working on implementing XDP CPU redirect map inside
> Suricata.
> 
> I've used CPU redirect map on my test laptop that has only skb mode
> available and my implementation was failing with result being almost
> all packets if not all were dropped.

Remember that the tool xdp_monitor helps identify if XDP drops packets.
(It's on my TODO list to expose the return values, until now I've just
used the existing perf record/script to inspect the individual return
ERRNO's when I needed more details).

Maybe suricata should attach itself to the XDP error tracepoints, to
help the user experience?

> So I decided to build the XPD sample and test them:
> 
> sudo ./xdp_redirect_cpu --debug -d wlan0  --cpu 4 -S

I notice the -S option, which long option is --skb-mode.

> The result was the same with packet blocked.
> 
> Am I missing something in the setup ?

The cpumap redirect feature does not for for skb-mode. 

It's on my TODO-list to make it work for skb-mode, but I got
side-tracked after netconf (implementing xdp_rxq_info).  From a
performance PoV it goes against the basic idea of CPUMAP, which is to
move the SKB allocation to another CPU.  But for completeness sake I
will implement this, it just requires the cpumap-code handle both
xdp_buff's and SKB's in its queue.

> For those interested, I've pushed my POC implementation here: 
> https://github.com/regit/suricata/commit/b1369fd0dc3a22a932190846a8bcbec4bfbd34b2

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
