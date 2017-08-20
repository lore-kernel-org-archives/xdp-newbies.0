Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:50874 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752856AbdHTNEA (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 20 Aug 2017 09:04:00 -0400
Received: from [137.74.104.57] (helo=tiger2)
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1djPtV-0004e4-V4
        for xdp-newbies@vger.kernel.org; Sun, 20 Aug 2017 15:03:58 +0200
Message-ID: <1503234237.13034.9.camel@regit.org>
Subject: What library to use ?
From: Eric Leblond <eric@regit.org>
Date: Sun, 20 Aug 2017 15:03:57 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

I've just started to work again on eBPF and XDP. My target it to work
on XDP support for Suricata (Daniel if you read me, yes finally ;)
Target is to be able to start Suricata with --xdp eth5 and get
everything setup by Suricata to get a working capture.

I've done one year ago an implementation of eBPF support in Suricata
using the library in tools/lib/bpf. One year later is using this
library the way to go or is there another library ?

Thanks in advance for your answer.

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
