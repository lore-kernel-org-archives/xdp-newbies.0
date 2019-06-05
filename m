Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38764 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfFEFgq (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 5 Jun 2019 01:36:46 -0400
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: [PATCH v2 bpf-next 0/2] veth: Bulk XDP_TX
Date: Wed,  5 Jun 2019 14:36:11 +0900
Message-Id: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
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

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (2):
  xdp: Add tracepoint for bulk XDP_TX
  veth: Support bulk XDP_TX

 drivers/net/veth.c         | 60 ++++++++++++++++++++++++++++++++++++----------
 include/trace/events/xdp.h | 25 +++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 3 files changed, 74 insertions(+), 12 deletions(-)

-- 
1.8.3.1
