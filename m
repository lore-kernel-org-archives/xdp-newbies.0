Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from forward102j.mail.yandex.net ([5.45.198.243]:59476 "EHLO
        forward102j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbfHUPnP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Aug 2019 11:43:15 -0400
Received: from mxback18j.mail.yandex.net (mxback18j.mail.yandex.net [IPv6:2a02:6b8:0:1619::94])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id AE98AF204DF
        for <xdp-newbies@vger.kernel.org>; Wed, 21 Aug 2019 18:37:11 +0300 (MSK)
From: Ilya Golshtein <ilejn@yandex.ru>
Subject: l2fwd between interfaces
Message-ID: <c4ba6c71-89e0-e8c3-1353-184b2e9f99a8@yandex.ru>
Date: Wed, 21 Aug 2019 18:37:10 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

l2fwd mode of xdpsock sample puts a packet back into the same interface. 
Is there a good example how xdpsock can be modified to read a packet 
from one interface and to send it to another?

I've failed to find such example and created my own app 
https://github.com/ilejn/xdpbridge.

Do hope that such a thing already exists.

If not, I appreciate if anyone can review the code of my application. In 
particular I am concerned about the ENOSPC case in xq_enq_copy.

Basically the thing works Ok, but not as fast as I expected.

I've tried to share umem to get rid of memcpy, but bind returns EINVAL 
in this case. Exploring xsk_bind (net/xdp/xsk.c) in 4.18 kernel I can 
see, that there is an explicit check umem_xs->dev != dev . Is it a 
fundamental limitaion?

Thanks.

-- 
Regards,
Ilya Golshtein
