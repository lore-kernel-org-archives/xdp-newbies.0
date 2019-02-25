Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f171.google.com ([209.85.222.171]:37926 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfBYUKw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 15:10:52 -0500
Received: by mail-qk1-f171.google.com with SMTP id p15so6155598qkl.5
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 12:10:52 -0800 (PST)
Date: Mon, 25 Feb 2019 12:10:43 -0800
From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: AF_XDP xdp_umem_reg.headroom XDP_ZEROCOPY
Message-ID: <20190225121043.2437c7fd@cakuba.netronome.com>
In-Reply-To: <CAM2iwTj2bymRNj9jpX817VEPGWt-Vw79mzE15s2j9fZ=H2KEqw@mail.gmail.com>
References: <CAM2iwTj2bymRNj9jpX817VEPGWt-Vw79mzE15s2j9fZ=H2KEqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: papito favaro <papito.favaro@gmail.com>
Cc: xdp-newbies@vger.kernel.org, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, Maciej =?UTF-8?B?RmlqYcWCa293c2tp?= <maciejromanfijalkowski@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>

On Mon, 25 Feb 2019 10:16:15 +0100, papito favaro wrote:
> Hi all,
> I woulld like to understand if the behaviour i'm getting is correct.
> 
> When I configure the XDP_UMEM_REG in zerocopy mode with a headroom ==
> 0 on a i40e,
> the driver (i guess) actually sets a headroom of 256.
> if i set a headroom == 256 the driver sets a headroom of 512.
> 
> If this behaviour is correct, would be nice that the xdp_umem_reg
> struct after the setsockopt call would contain the actual configured
> headroom.

Kernel's XDP may require up to 256B (XDP_PACKET_HEADROOM) of headroom
this is for calls to xdp_adjust_head() which may want to prepend data.
The AF_XDP headroom is extra, beyond that.

Perhaps we should document that as expected behaviour?  (Does it hold
for ixgbe?)
