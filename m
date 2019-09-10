Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from forward103o.mail.yandex.net ([37.140.190.177]:55094 "EHLO
        forward103o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731801AbfIJOGR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 10 Sep 2019 10:06:17 -0400
Received: from mxback16o.mail.yandex.net (mxback16o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::67])
        by forward103o.mail.yandex.net (Yandex) with ESMTP id BF9F65F80756
        for <xdp-newbies@vger.kernel.org>; Tue, 10 Sep 2019 17:01:11 +0300 (MSK)
From: Ilya Goslhtein <ilejn@yandex.ru>
Subject: bidirectional: => AF_XDP , <= XDP_REDIRECT
Message-ID: <d52b5b48-06cf-42dc-180d-896601cf3efb@yandex.ru>
Date: Tue, 10 Sep 2019 17:01:10 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

I am trying to use a network interface to
(1) send packets via AF_XDP
(2) receive packets and redirect to another interface via xdp_redirect_map

Basically, I am making xdpbridge https://github.com/ilejn/xdpbridge.
  bidirectional. My goal is to process packets in one direction in 
kernelspace (xdp_redirect_map) and to pass packets in opposite direction 
via userspace (recieve via AF_XDP then send via AF_XDP, rings are not 
shared, so I perform memcpy).

For test purposes I ran two applications: my xdpbridge and 
xdp_redirect_map bpf sample.

It does not work. Only few packets are received, then the thing stops. 
Redirecting works until xdpbridge does 'bind' against the interface.

 From XDP point of view we have:
application one: bind with PF_XDP
application two: XDP program

What is the nature of the problem? Is it fundamental, 
environment/hardware specific, or I am simply doing something wrong?

ubuntu 18.04, 5.0.0-27-generic,
Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ 
Network Connection (rev 01)

Thanks.

-- 
Best regards,
Ilya Golshtein
