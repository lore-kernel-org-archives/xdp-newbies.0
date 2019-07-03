Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35089 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfGCKTJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 3 Jul 2019 06:19:09 -0400
Received: by mail-lf1-f68.google.com with SMTP id p197so1385654lfa.2
        for <xdp-newbies@vger.kernel.org>; Wed, 03 Jul 2019 03:19:08 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v6 net-next 0/5] net: ethernet: ti: cpsw: Add XDP support
Date: Wed,  3 Jul 2019 13:18:58 +0300
Message-Id: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc: ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

This patchset adds XDP support for TI cpsw driver and base it on
page_pool allocator. It was verified on af_xdp socket drop,
af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.

It was verified with following configs enabled:
CONFIG_JIT=y
CONFIG_BPFILTER=y
CONFIG_BPF_SYSCALL=y
CONFIG_XDP_SOCKETS=y
CONFIG_BPF_EVENTS=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_BPF_JIT=y
CONFIG_CGROUP_BPF=y

Link on previous v5:
https://lkml.org/lkml/2019/6/30/89

Also regular tests with iperf2 were done in order to verify impact on
regular netstack performance, compared with base commit:
https://pastebin.com/JSMT0iZ4

v5..v6:
- do changes that is rx_dev while redirect/flush cycle is kept the same
- dropped net: ethernet: ti: davinci_cpdma: return handler status
- other changes desc in patches

v4..v5:
- added two plreliminary patches:
  net: ethernet: ti: davinci_cpdma: allow desc split while down
  net: ethernet: ti: cpsw_ethtool: allow res split while down
- added xdp alocator refcnt on xdp level, avoiding page pool refcnt
- moved flush status as separate argument for cpdma_chan_process
- reworked cpsw code according to last changes to allocator
- added missed statistic counter

v3..v4:
- added page pool user counter
- use same pool for ndevs in dual mac
- restructured page pool create/destroy according to the last changes in API

v2..v3:
- each rxq and ndev has its own page pool

v1..v2:
- combined xdp_xmit functions
- used page allocation w/o refcnt juggle
- unmapped page for skb netstack
- moved rxq/page pool allocation to open/close pair
- added several preliminary patches:
  net: page_pool: add helper function to retrieve dma addresses
  net: page_pool: add helper function to unmap dma addresses
  net: ethernet: ti: cpsw: use cpsw as drv data
  net: ethernet: ti: cpsw_ethtool: simplify slave loops

Ivan Khoronzhuk (5):
  xdp: allow same allocator usage
  net: ethernet: ti: davinci_cpdma: add dma mapped submit
  net: ethernet: ti: davinci_cpdma: allow desc split while down
  net: ethernet: ti: cpsw_ethtool: allow res split while down
  net: ethernet: ti: cpsw: add XDP support

 drivers/net/ethernet/ti/Kconfig         |   1 +
 drivers/net/ethernet/ti/cpsw.c          | 485 +++++++++++++++++++++---
 drivers/net/ethernet/ti/cpsw_ethtool.c  |  76 +++-
 drivers/net/ethernet/ti/cpsw_priv.h     |   7 +
 drivers/net/ethernet/ti/davinci_cpdma.c |  99 ++++-
 drivers/net/ethernet/ti/davinci_cpdma.h |   7 +-
 include/net/xdp_priv.h                  |   2 +
 net/core/xdp.c                          |  55 +++
 8 files changed, 656 insertions(+), 76 deletions(-)

-- 
2.17.1
