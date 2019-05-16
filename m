Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45540 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfEPVy1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 May 2019 17:54:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id i21so2187714pgi.12
        for <xdp-newbies@vger.kernel.org>; Thu, 16 May 2019 14:54:26 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net 0/3] XDP generic related fixes
Date: Thu, 16 May 2019 14:54:20 -0700
Message-Id: <20190516215423.14185-1-sthemmin@microsoft.com>
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

Stephen Hemminger (3):
  netvsc: unshare skb in VF rx handler
  net: core: generic XDP support for stacked device
  netdevice: clarify meaning of rx_handler_result

 drivers/net/hyperv/netvsc_drv.c |  6 ++++++
 include/linux/netdevice.h       | 16 ++++++++--------
 net/core/dev.c                  | 10 ++++++++++
 3 files changed, 24 insertions(+), 8 deletions(-)

-- 
2.20.1
