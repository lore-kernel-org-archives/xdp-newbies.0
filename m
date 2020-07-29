Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:34453 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgG2SWW (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 29 Jul 2020 14:22:22 -0400
Date: Wed, 29 Jul 2020 11:22:20 -0700
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: igb native xdp support
Message-ID: <20200729112220.000041da@intel.com>
In-Reply-To: <9ffcedaa-5b57-0188-0ab7-9a38ecbb9f69@gmail.com>
References: <9ffcedaa-5b57-0188-0ab7-9a38ecbb9f69@gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Sandip Patil <techiek7@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On Wed, 29 Jul 2020 14:14:51 +0530
Sandip Patil <techiek7@gmail.com> wrote:

> Hello team,
> 
> Is there a plan to add support for native XDP in Intel igb driver?

I think someone has just recently posted patches for part of this on
intel-wired-lan mailing list.

you can download the patch or see it's status here:
https://lore.kernel.org/netdev/20200713090549.b7dive4cmtm4o7dq@SvensMacbookPro.hq.voleatech.com/

Have a look and give us feedback on the list by replying (if you're not
subscribed you can bounce the message to yourself via the below)
https://lore.kernel.org/netdev/20200713090549.b7dive4cmtm4o7dq@SvensMacbookPro.hq.voleatech.com/
