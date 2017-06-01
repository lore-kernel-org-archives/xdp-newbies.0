Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35792 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdFAQok (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Jun 2017 12:44:40 -0400
Received: by mail-qk0-f176.google.com with SMTP id 19so41027653qke.2
        for <xdp-newbies@vger.kernel.org>; Thu, 01 Jun 2017 09:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170601.121126.298708208451228255.davem@davemloft.net>
References: <7784F3C775469047B0E8C3B494DB28BEAF7DE1@EXC-MBX03.tsn.tno.nl> <20170601.121126.298708208451228255.davem@davemloft.net>
From: Andy Gospodarek <andy@greyhouse.net>
Date: Thu, 1 Jun 2017 12:44:14 -0400
Message-ID: <CAHashqAMeCo5EpdUapXTTk8vgg0VXhYs_dbdvt_kEnaXcW_MmA@mail.gmail.com>
Subject: Re: Empty ethernet frame after XDP_TX
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: jeffrey.panneman@tno.nl, xdp-newbies@vger.kernel.org

On Thu, Jun 1, 2017 at 12:11 PM, David Miller <davem@davemloft.net> wrote:
>
> This is almost certainly a bug in generic XDP.

It looks like he is running 4.11 (though I'm not sure what patches
have been laid on top), so Generic XDP isn't there by default in 4.11.
