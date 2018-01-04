Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:60746 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751503AbeADH74 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 4 Jan 2018 02:59:56 -0500
Message-ID: <1515052793.7473.14.camel@regit.org>
Subject: Re: CPU redirect and skb mode
From: Eric Leblond <eric@regit.org>
Date: Thu, 04 Jan 2018 08:59:53 +0100
In-Reply-To: <20180104081500.73d55bd8@redhat.com>
References: <1515025109.7473.10.camel@regit.org>
         <20180104081500.73d55bd8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org

Hello Jesper,

On Thu, 2018-01-04 at 08:15 +0100, Jesper Dangaard Brouer wrote:
> On Thu, 04 Jan 2018 01:18:29 +0100 Eric Leblond <eric@regit.org>
> wrote:
> 
> > Hello,
> > 
> > I'm currently working on implementing XDP CPU redirect map inside
> > Suricata.
> > 
> > I've used CPU redirect map on my test laptop that has only skb mode
> > available and my implementation was failing with result being
> > almost
> > all packets if not all were dropped.
> 
> Remember that the tool xdp_monitor helps identify if XDP drops
> packets.
> (It's on my TODO list to expose the return values, until now I've
> just
> used the existing perf record/script to inspect the individual return
> ERRNO's when I needed more details).
> 
> Maybe suricata should attach itself to the XDP error tracepoints, to
> help the user experience?

Gonna look at it and see if it is doable.
> 
> > So I decided to build the XPD sample and test them:
> > 
> > sudo ./xdp_redirect_cpu --debug -d wlan0  --cpu 4 -S
> 
> I notice the -S option, which long option is --skb-mode.

Yes, I don't have a network card with XDP enable driver available on my
laptop.

> > The result was the same with packet blocked.
> > 
> > Am I missing something in the setup ?
> 
> The cpumap redirect feature does not for for skb-mode. 
> 
> It's on my TODO-list to make it work for skb-mode, but I got
> side-tracked after netconf (implementing xdp_rxq_info).  From a
> performance PoV it goes against the basic idea of CPUMAP, which is to
> move the SKB allocation to another CPU.

I second that, this is just pointless.

>   But for completeness sake I
> will implement this, it just requires the cpumap-code handle both
> xdp_buff's and SKB's in its queue.

Or you could just error if ever a BOF with CPU redirect is used in a
skb-mode ?

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
