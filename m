Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404050AbfFKOp3 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 11 Jun 2019 10:45:29 -0400
Date: Tue, 11 Jun 2019 16:45:25 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: ethtool isn't showing xdp statistics
Message-ID: <20190611164525.6f8e845c@carbon>
In-Reply-To: <CAK6Qs9mncU4E-ZBSb8RNZrGqUyruU4of-fStr9vhLVmCVHg+TA@mail.gmail.com>
References: <CAK6Qs9=ig3-PWKtSk7UJfm1gcWz9cSGYU7uDxxUw=xju5TtP9w@mail.gmail.com>
        <20190610121540.36391dc3@carbon>
        <CAK6Qs9mdViRXL5BhafcUdv06inVF0ZuciBX1zPNasRYw3We9-g@mail.gmail.com>
        <20190611124119.49a0e440@carbon>
        <CAK6Qs9mncU4E-ZBSb8RNZrGqUyruU4of-fStr9vhLVmCVHg+TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?xLBicmFoaW0=?= Ercan <ibrahim.metu@gmail.com>
Cc: xdp-newbies@vger.kernel.org, David Ahern <dsahern@gmail.com>

On Tue, 11 Jun 2019 16:18:17 +0300
İbrahim Ercan <ibrahim.metu@gmail.com> wrote:

> and loaded with
> ./ip -force link set dev enp7s0f0 xdp object dropudp.o sec prog
> 
> I also realized that after loading xdp code, network go down about 5
> second, Is that normal?
>
> I'm using bridged topology. I don't know it is important or not.
>
> # brctl show
> bridge name     bridge id           STP enabled   interfaces
> br0             8000.00900b3b696c   yes           enp7s0f0   enp7s0f1

I would recommend removing the bridge setup, for isolation the issue,
as this could be the issue.  XDP doesn't cooperate with the bridge
code, and it works on a layer before the bridge.

For the ixgbe driver it does a full link down/up (to reconfigure all
the NIC queues), which is why you likely you see this 5 sec issue, as
you have enabled STP on your bridge.  (Note, replacing an XDP-prog with
another XDP-prog does not require this link down/up).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
