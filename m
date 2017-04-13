Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34935 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755796AbdDMCQb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Apr 2017 22:16:31 -0400
Received: by mail-pf0-f175.google.com with SMTP id i5so21789568pfc.2
        for <xdp-newbies@vger.kernel.org>; Wed, 12 Apr 2017 19:16:31 -0700 (PDT)
Subject: Re: [PATCH v3 net-next RFC] Generic XDP
References: <20170412.145415.1441440342830198148.davem@davemloft.net>
 <0861d2c9-a5ec-f40e-b849-f6421938b357@cumulusnetworks.com>
 <20170412.220828.661268690055956936.davem@davemloft.net>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <7e5dabd3-5066-de0b-ee5c-eafe77abfb1b@cumulusnetworks.com>
Date: Wed, 12 Apr 2017 20:16:29 -0600
MIME-Version: 1.0
In-Reply-To: <20170412.220828.661268690055956936.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org

On 4/12/17 8:08 PM, David Miller wrote:
> From: David Ahern <dsa@cumulusnetworks.com>
> Date: Wed, 12 Apr 2017 13:54:20 -0600
> 
>> packet passed to xdp seems to be messed up
> Ok, the problem is that skb->mac_len isn't set properly at this point.
> That doesn't happen until __netif_receive_skb_core().
> 
> I'm also not setting xdp.data_hard_start properly.
> 
> It should work better with this small diff:

it does.
