Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:56332 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIXSHO (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 24 Sep 2017 14:07:14 -0400
Received: from [109.190.253.11] (helo=tiger2)
        by home.regit.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <eric@regit.org>)
        id 1dwBJA-0001gM-IX
        for xdp-newbies@vger.kernel.org; Sun, 24 Sep 2017 20:07:13 +0200
Message-ID: <1506276431.21618.2.camel@regit.org>
Subject: libbpf missing set_link_xdp_fd ?
From: Eric Leblond <eric@regit.org>
Date: Sun, 24 Sep 2017 20:07:11 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,

bpf_load is implementing the set_link_xdp_fd() function and it seems
this function is not available in libbpf.

Should it be the case or should it be part of another library ?

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
