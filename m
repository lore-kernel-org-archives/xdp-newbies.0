Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f174.google.com ([209.85.210.174]:41833 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728224AbfE1Srt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 May 2019 14:47:49 -0400
Received: by mail-pf1-f174.google.com with SMTP id q17so7182987pfq.8
        for <xdp-newbies@vger.kernel.org>; Tue, 28 May 2019 11:47:48 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH PATCH v4 0/2] XDP generic fixes
Date: Tue, 28 May 2019 11:47:29 -0700
Message-Id: <20190528184731.7464-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: davem@davemloft.net, saeedm@mellanox.com, jasowang@redhat.com, brouer@redhat.com
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>

This set of patches came about while investigating XDP
generic on Azure. The split brain nature of the accelerated
networking exposed issues with the stack device model.

Stephen Hemminger (2):
  netvsc: unshare skb in VF rx handler
  net: core: support XDP generic on stacked devices.

 drivers/net/hyperv/netvsc_drv.c |  6 ++++
 net/core/dev.c                  | 58 +++++++--------------------------
 2 files changed, 18 insertions(+), 46 deletions(-)

-- 
2.20.1
