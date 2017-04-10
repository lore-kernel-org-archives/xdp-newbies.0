Return-path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:50508 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdDJT24 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Apr 2017 15:28:56 -0400
Date: Mon, 10 Apr 2017 15:28:54 -0400 (EDT)
Message-Id: <20170410.152854.2025617543091711047.davem@davemloft.net>
Subject: Re: [PATCH v2 net-next RFC] Generic XDP
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170410183935.GB4730@C02RW35GFVH8.dhcp.broadcom.net>
References: <20170409.133528.660876505013192371.davem@davemloft.net>
        <20170410183935.GB4730@C02RW35GFVH8.dhcp.broadcom.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: andy@greyhouse.net
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org

From: Andy Gospodarek <andy@greyhouse.net>
Date: Mon, 10 Apr 2017 14:39:35 -0400

> As promised, I did some testing today with bnxt_en's implementation
> of XDP and this one.

Thanks a lot Andy, obviously the patch needs some more work.

I noticed GRO stuff in your profile, and Alexei mentioned this earlier
today.  We probably should elide GRO if generic XDP is attached, since
in particular this makes the skb_linearize() really expensive.
