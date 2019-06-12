Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:40520 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407244AbfFLG5P (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Jun 2019 02:57:15 -0400
Received: by mail-it1-f194.google.com with SMTP id q14so8886785itc.5
        for <xdp-newbies@vger.kernel.org>; Tue, 11 Jun 2019 23:57:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9=ig3-PWKtSk7UJfm1gcWz9cSGYU7uDxxUw=xju5TtP9w@mail.gmail.com>
 <20190610121540.36391dc3@carbon> <CAK6Qs9mdViRXL5BhafcUdv06inVF0ZuciBX1zPNasRYw3We9-g@mail.gmail.com>
 <20190611124119.49a0e440@carbon> <CAK6Qs9mncU4E-ZBSb8RNZrGqUyruU4of-fStr9vhLVmCVHg+TA@mail.gmail.com>
 <20190611164525.6f8e845c@carbon>
In-Reply-To: <20190611164525.6f8e845c@carbon>
From: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date: Wed, 12 Jun 2019 09:57:02 +0300
Message-ID: <CAK6Qs9kbWdRSer1LTz53BunJkvpQaa02YExen65Tha3HpGrW+w@mail.gmail.com>
Subject: Re: ethtool isn't showing xdp statistics
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org, David Ahern <dsahern@gmail.com>

I removed bridge and did same tests again. Unfortunately result is same :/

On Tue, Jun 11, 2019 at 5:45 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:

>
> I would recommend removing the bridge setup, for isolation the issue,
> as this could be the issue.  XDP doesn't cooperate with the bridge
> code, and it works on a layer before the bridge.
>
> For the ixgbe driver it does a full link down/up (to reconfigure all
> the NIC queues), which is why you likely you see this 5 sec issue, as
> you have enabled STP on your bridge.  (Note, replacing an XDP-prog with
> another XDP-prog does not require this link down/up).
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
