Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfFLHx2 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Jun 2019 03:53:28 -0400
Date: Wed, 12 Jun 2019 09:53:23 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: ethtool isn't showing xdp statistics
Message-ID: <20190612095323.620c0791@carbon>
In-Reply-To: <CAK6Qs9kbWdRSer1LTz53BunJkvpQaa02YExen65Tha3HpGrW+w@mail.gmail.com>
References: <CAK6Qs9=ig3-PWKtSk7UJfm1gcWz9cSGYU7uDxxUw=xju5TtP9w@mail.gmail.com>
        <20190610121540.36391dc3@carbon>
        <CAK6Qs9mdViRXL5BhafcUdv06inVF0ZuciBX1zPNasRYw3We9-g@mail.gmail.com>
        <20190611124119.49a0e440@carbon>
        <CAK6Qs9mncU4E-ZBSb8RNZrGqUyruU4of-fStr9vhLVmCVHg+TA@mail.gmail.com>
        <20190611164525.6f8e845c@carbon>
        <CAK6Qs9kbWdRSer1LTz53BunJkvpQaa02YExen65Tha3HpGrW+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?xLBicmFoaW0=?= Ercan <ibrahim.metu@gmail.com>
Cc: xdp-newbies@vger.kernel.org, David Ahern <dsahern@gmail.com>, brouer@redhat.com


On Wed, 12 Jun 2019 09:57:02 +0300 İbrahim Ercan <ibrahim.metu@gmail.com> wrote:

> I removed bridge and did same tests again. Unfortunately result is
> same :/

I sort of expected that, as the ethtool "rx_missed_errors" counter
says, that packets are dropped inside the NIC, before reaching Linux.
Something more fundamental is wrong with your setup.

You mentioned there was a switch between the machines in your lab.  One
possibility is that the switch is somehow corrupting the frames before
the reach the NIC, e.g. in these overload DDoS scenarios.  Try to
remove the switch from the equation (by directly connecting machine
back-to-back), to identify where the pitfall is...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
