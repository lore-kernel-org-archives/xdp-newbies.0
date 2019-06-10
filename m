Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388734AbfFJKPq (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Jun 2019 06:15:46 -0400
Date: Mon, 10 Jun 2019 12:15:40 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: ethtool isn't showing xdp statistics
Message-ID: <20190610121540.36391dc3@carbon>
In-Reply-To: <CAK6Qs9=ig3-PWKtSk7UJfm1gcWz9cSGYU7uDxxUw=xju5TtP9w@mail.gmail.com>
References: <CAK6Qs9=ig3-PWKtSk7UJfm1gcWz9cSGYU7uDxxUw=xju5TtP9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?xLBicmFoaW0=?= Ercan <ibrahim.metu@gmail.com>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com, David Ahern <dsahern@gmail.com>

On Mon, 10 Jun 2019 12:55:07 +0300
İbrahim Ercan <ibrahim.metu@gmail.com> wrote:

> Hi.
> I'm trying to do a xdp performance test on redhat based environment.
> To do so, I compiled kernel 5.0.13 and iproute 4.6.0
> Then I loaded compiled code to interface with below command.
> #ip -force link set dev enp7s0f0 xdp object xdptest.o
> 
> After that packets dropped as expected but I can not see statistics
> with ethtool command like below.
> #ethtool -S enp7s0f0 | grep xdp
> 
> ethtool version is 4.8
> I did my test with that NIC
> Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
> 
> I wonder why I can't see statistics. Did I miss something while
> compiling kernel or iproute? Should I also compile ethtool too?

You did nothing wrong. Consistency for statistics with XDP is a known
issue, see [1].  The behavior varies per driver, which obviously is bad
from a user perspective.  You NIC is based on ixgbe driver, which don't
have ethtool stats counters for XDP, instead it actually updates
ifconfig counters correctly. While for mlx5 it's opposite (p.s. I use
this[2] ethtool stats tool).

We want to bring consistency in this area, but there are performance
concerns.  As any stat counter will bring overhead, and XDP is all
about maximum performance.  Thus, we want this counter overhead to be
opt-in (that is not on as default).

Currently you have to add the stats your want to the XDP/BPF program
itself.  That is the current opt-in mechanism.  To help you coded this,
we have an example here[3].


[1] https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#consistency-for-statistics-with-xdp
[2] https://github.com/netoptimizer/network-testing/blob/master/bin/ethtool_stats.pl
[3] https://github.com/xdp-project/xdp-tutorial/blob/master/common/xdp_stats_kern.h
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
