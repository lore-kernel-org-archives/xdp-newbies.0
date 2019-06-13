Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43840 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731786AbfFMJkb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jun 2019 05:40:31 -0400
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: [PATCH v3 bpf-next 0/2] veth: Bulk XDP_TX
Date: Thu, 13 Jun 2019 18:39:57 +0900
Message-Id: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>, Jason Wang <jasowang@redhat.com>

This introduces bulk XDP_TX in veth.
Improves XDP_TX performance by approximately 9%. The detailed
explanation and performance numbers are shown in patch 2.

v2:
- Use stack for bulk queue instead of a global variable.

v3:
- Add act field to xdp_bulk_tx tracepoint to be in line with other XDP
  tracepoints.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (2):
  xdp: Add tracepoint for bulk XDP_TX
  veth: Support bulk XDP_TX

 drivers/net/veth.c         | 60 ++++++++++++++++++++++++++++++++++++----------
 include/trace/events/xdp.h | 29 ++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 3 files changed, 78 insertions(+), 12 deletions(-)

-- 
1.8.3.1
