Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from alpha.coverfire.com ([69.41.199.58]:50236 "EHLO
        alpha.coverfire.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753703AbdF0VjV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 27 Jun 2017 17:39:21 -0400
Received: from neptune.home (pkt.206.174.packetworks.net [206.174.180.53] (may be forged))
        (authenticated bits=0)
        by alpha.coverfire.com (8.15.2/8.15.2) with ESMTPSA id v5RKjjGi011079
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <xdp-newbies@vger.kernel.org>; Tue, 27 Jun 2017 16:45:46 -0400
Message-ID: <1498596345.14503.1.camel@coverfire.com>
Subject: Calculating a hash from a eBPF program?
From: Dan Siemon <dan@coverfire.com>
Date: Tue, 27 Jun 2017 16:45:45 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

[This isn't strictly an XDP question, I'm using cls_bpf but I don't
know of a better place to ask]

Is there a way to calculate a hash of a struct or other data from
within an eBPF program? I need to build a classifier that can hash a
flow encapsulated in protocols like PPPoE or GTP-U. Basically like
cls_flow's use of jhash2 but at a different offset. I looked at the
helpers in bpf.h but don't see anything helpful there.

Thanks.
