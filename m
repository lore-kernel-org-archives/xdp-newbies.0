Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:56962 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdFAQrs (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Jun 2017 12:47:48 -0400
Date: Thu, 01 Jun 2017 12:47:32 -0400 (EDT)
Message-Id: <20170601.124732.1936317190288350296.davem@davemloft.net>
Subject: Re: Empty ethernet frame after XDP_TX
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHashqAMeCo5EpdUapXTTk8vgg0VXhYs_dbdvt_kEnaXcW_MmA@mail.gmail.com>
References: <7784F3C775469047B0E8C3B494DB28BEAF7DE1@EXC-MBX03.tsn.tno.nl>
        <20170601.121126.298708208451228255.davem@davemloft.net>
        <CAHashqAMeCo5EpdUapXTTk8vgg0VXhYs_dbdvt_kEnaXcW_MmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: andy@greyhouse.net
Cc: jeffrey.panneman@tno.nl, xdp-newbies@vger.kernel.org

From: Andy Gospodarek <andy@greyhouse.net>
Date: Thu, 1 Jun 2017 12:44:14 -0400

> On Thu, Jun 1, 2017 at 12:11 PM, David Miller <davem@davemloft.net> wrote:
>>
>> This is almost certainly a bug in generic XDP.
> 
> It looks like he is running 4.11 (though I'm not sure what patches
> have been laid on top), so Generic XDP isn't there by default in 4.11.

Right you are.
