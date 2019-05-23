Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35434 "EHLO
        tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWK6L (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 May 2019 06:58:11 -0400
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Subject: [PATCH bpf-next 0/3] veth: Bulk XDP_TX
Date: Thu, 23 May 2019 19:56:45 +0900
Message-Id: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

This adds an infrastructure for bulk XDP_TX and makes veth use it.
Improves XDP_TX performance by approximately 8%. The detailed
performance numbers are shown in patch 3.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

Toshiaki Makita (3):
  xdp: Add bulk XDP_TX queue
  xdp: Add tracepoint for bulk XDP_TX
  veth: Support bulk XDP_TX

 drivers/net/veth.c         | 26 +++++++++++++++++++++++++-
 include/net/xdp.h          |  7 +++++++
 include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 net/core/xdp.c             |  3 +++
 5 files changed, 61 insertions(+), 1 deletion(-)

-- 
1.8.3.1
