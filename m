Return-path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:53272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdDKA4i (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 10 Apr 2017 20:56:38 -0400
Date: Mon, 10 Apr 2017 20:56:31 -0400 (EDT)
Message-Id: <20170410.205631.1242763166483761576.davem@davemloft.net>
Subject: Re: [PATCH v2 net-next RFC] Generic XDP
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACKFLik+GKHPqKU7Mb4dXMLVLBKKDLVWZd7uuR=uA5yZ4_GmsQ@mail.gmail.com>
References: <20170410.152854.2025617543091711047.davem@davemloft.net>
        <20170410213025.GC4730@C02RW35GFVH8.dhcp.broadcom.net>
        <CACKFLik+GKHPqKU7Mb4dXMLVLBKKDLVWZd7uuR=uA5yZ4_GmsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: michael.chan@broadcom.com
Cc: andy@greyhouse.net, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Mon, 10 Apr 2017 14:47:04 -0700

> On Mon, Apr 10, 2017 at 2:30 PM, Andy Gospodarek <andy@greyhouse.net> wrote:
>> On Mon, Apr 10, 2017 at 03:28:54PM -0400, David Miller wrote:
>>> From: Andy Gospodarek <andy@greyhouse.net>
>>> Date: Mon, 10 Apr 2017 14:39:35 -0400
>>>
>>> > As promised, I did some testing today with bnxt_en's implementation
>>> > of XDP and this one.
>>>
>>> Thanks a lot Andy, obviously the patch needs some more work.
>>>
>>> I noticed GRO stuff in your profile, and Alexei mentioned this earlier
>>> today.  We probably should elide GRO if generic XDP is attached, since
>>> in particular this makes the skb_linearize() really expensive.
>>
>> Good catch -- I actually thought we were disabling GRO automatically and it
>> looks like we are not.  :-/  I'll send Michael a patch.
> 
> Andy,  I think we only need to disable GRO if we are doing generic
> XDP.  Optimized XDP can still use GRO for the XDP_PASS case.

Right.
