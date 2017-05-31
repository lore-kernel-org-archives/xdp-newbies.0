Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33468 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdEaQeB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 31 May 2017 12:34:01 -0400
Received: by mail-qk0-f171.google.com with SMTP id y201so16220120qka.0
        for <xdp-newbies@vger.kernel.org>; Wed, 31 May 2017 09:34:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABWTmTqaQh_YqMgt=Vh0SPqzdtLmVc=fSY2kJVYNFAA_h=1jkg@mail.gmail.com>
References: <CABWTmTqGtb5bH_vDz986AUNTrygdEubQskvoJ2oh1S=m8VwNbg@mail.gmail.com>
 <CABWTmTqaQh_YqMgt=Vh0SPqzdtLmVc=fSY2kJVYNFAA_h=1jkg@mail.gmail.com>
From: Andy Gospodarek <andy@greyhouse.net>
Date: Wed, 31 May 2017 12:33:40 -0400
Message-ID: <CAHashqCBxToejNy2OhYdX2mSr+eXqEHnk16zZeF2yzpYJ-E6DQ@mail.gmail.com>
Subject: Re: Empty ethernet fram after XDP_TX
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jeffrey Panneman <jeffrey.panneman@student.uva.nl>
Cc: xdp-newbies@vger.kernel.org

On Wed, May 31, 2017 at 5:29 AM, Jeffrey Panneman
<jeffrey.panneman@student.uva.nl> wrote:
> Hi all,
>
> I have recently started experimenting with XDP in regards to my master
> thesis project. I have been playing around with some examples and had
> a question regarding the following sample file from the linux kernel:
> https://github.com/torvalds/linux/blob/master/samples/bpf/xdp2_kern.c
>
> I have setup a test environment on which I can monitor both my source
> and destination port using Wireshark. I observe that when I run the
> example, always returning XDP_PASS, packets go on normal but the MAC
> swapping does not occur. When using the XDP_TX return code after
> swapping I observe that I see Ethernet frames appear in wireshark with
> a source and destination 00:00:00:00:00:00. The IP related headers are
> gone and this is the only thing I am seeing.

That is not what I would expect to see.  I've run numerous tests with
xdp2 on other hardware (Broadcom) and not seen this issue.  Are only
the source and destination MAC addresses all zeros or are other parts
of the ethernet header also zero?

> For some context, I am running on: 4.11.0-041100-generic x86_64 x86_64
> x86_64 GNU/Linux using ConnectX-4 Lx cards with the mlx5_core driver
> (from lspci -v output). From "systool -vm" output I see my mlx5_core
> version is "4.0-2.0.0"
>
> I was wondering if this behaviour was normal, and if anyone knows what
> is going wrong here. I am happy to provide some more diagnostic
> information if needed.

Can you send the diff of the ethtool stats (ethtool -S <netdev>) from
before and after your XDP_TX test to see if anything stands out?

> Kind regards,
>
> Jeffrey
