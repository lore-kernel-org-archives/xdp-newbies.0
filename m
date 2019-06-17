Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:55598 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfFQKZS (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 17 Jun 2019 06:25:18 -0400
Received: from infra1.stamus-networks.com ([91.121.107.192] helo=[10.24.24.5])
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1hcoQl-0004Rm-Vp
        for xdp-newbies@vger.kernel.org; Mon, 17 Jun 2019 12:00:05 +0200
Message-ID: <86f135475a7820adadb05e7ac9a05c71846bebd6.camel@regit.org>
Subject: AF_XDP and packet timestamp
From: Eric Leblond <eric@regit.org>
Date: Mon, 17 Jun 2019 12:00:02 +0200
Content-Type: text/plain; charset="ISO-8859-15"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

I did start to work on AF_XDP support for Suricata. API was really easy
to use via libbpf.

From Suricata point of view, the current system with default
configuration is lacking an important information. I don't have access
to the timestamp of the packet. I'm in particular interested by the
hardware timestamp as it would allow to do reordering in some capture
cases.

Is there a way to get the information via AF_XDP. I've seen the
discussion on hardware hints but there was no code example I was able
to find. 

BR,
-- 
Eric Leblond <eric@regit.org>
