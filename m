Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:56180 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbeADASc (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 3 Jan 2018 19:18:32 -0500
Received: from [2a01:e35:2fb6:1160:c685:8ff:feb3:c9c8] (helo=tiger2)
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1eWtEs-0005PK-2V
        for xdp-newbies@vger.kernel.org; Thu, 04 Jan 2018 01:18:31 +0100
Message-ID: <1515025109.7473.10.camel@regit.org>
Subject: CPU redirect and skb mode
From: Eric Leblond <eric@regit.org>
Date: Thu, 04 Jan 2018 01:18:29 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

I'm currently working on implementing XDP CPU redirect map inside
Suricata.

I've used CPU redirect map on my test laptop that has only skb mode
available and my implementation was failing with result being almost
all packets if not all were dropped.

So I decided to build the XPD sample and test them:

sudo ./xdp_redirect_cpu --debug -d wlan0  --cpu 4 -S

The result was the same with packet blocked.

Am I missing something in the setup ?

For those interested, I've pushed my POC implementation here: 
https://github.com/regit/suricata/commit/b1369fd0dc3a22a932190846a8bcbec4bfbd34b2

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
