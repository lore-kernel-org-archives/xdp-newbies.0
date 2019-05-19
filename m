Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35228 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfESTRo (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 19 May 2019 15:17:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id t1so4278305pgc.2
        for <xdp-newbies@vger.kernel.org>; Sun, 19 May 2019 12:17:44 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net 0/2] XDP generic related fixes
Date: Sat, 18 May 2019 20:10:44 -0700
Message-Id: <20190519031046.4049-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, davem@davemloft.net
Cc: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>

This set of patches came about while investigating XDP
generic on Azure. The split brain nature of the accelerated
networking exposed issues with the stack device model.

The real fix is in the second patch which is a redo
of earlier patch from Jason Wang.

v2 - hold off the comment fixes for net-next

Stephen Hemminger (2):
  netvsc: unshare skb in VF rx handler
  net: core: generic XDP support for stacked device

 drivers/net/hyperv/netvsc_drv.c |  6 ++++++
 net/core/dev.c                  | 10 ++++++++++
 2 files changed, 16 insertions(+)

-- 
2.20.1
