Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f182.google.com ([209.85.222.182]:37756 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgBTWty (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 20 Feb 2020 17:49:54 -0500
Received: by mail-qk1-f182.google.com with SMTP id c188so157991qkg.4
        for <xdp-newbies@vger.kernel.org>; Thu, 20 Feb 2020 14:49:54 -0800 (PST)
MIME-Version: 1.0
From: William Tu <u9012063@gmail.com>
Date: Thu, 20 Feb 2020 14:49:17 -0800
Message-ID: <CALDO+SZmCxtWCeqh93HO6vm1KHh_UGxMby+td2ba_o66ZT+MVQ@mail.gmail.com>
Subject: xdpsock poll syscall CPU 100%
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: Xdp <xdp-newbies@vger.kernel.org>
Cc: "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>

Hi,

I'm trying to save some CPU cycles when there is no packet arrives.
I enable the poll syscall option of xdpsock, by doing

$ ./xdpsock -r -p -S -i ens16
 sock0@ens160:0 rxdrop xdp-skb poll()
                pps         pkts        1.00
rx              0           0
tx              0           0

Since there is no packet coming, I though by calling poll()
system call, the xdpsock process will be blocked and CPU utilization
should be way under 100%. However, I'm still seeing 100%
CPU utilization. Am I understanding this correctly?

Thanks,
William
