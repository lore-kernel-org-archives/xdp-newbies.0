Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43909 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfFNIU1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jun 2019 04:20:27 -0400
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: [PATCH bpf 0/3] Devmap fixes around memory and RCU
Date: Fri, 14 Jun 2019 17:20:12 +0900
Message-Id: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>

Patch1: Jesper showed concerns around devmap free and flush race when
    reviewing my XDP bulk TX patch set, and I think indeed there is a
    race. Patch1 fix it.

Patch2: While reviewing dev_map_free I found bulk queue was not freed.
    Patch2 fix it.

Patch3: Some days ago David Ahern reported suspicous RCU usage in
    virtnet_xdp_xmit(), but it seems no one posted an official fix
    patch. So I arraged the fix.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (3):
  devmap: Fix premature entry free on destroying map
  devmap: Add missing bulk queue free
  devmap: Add missing RCU read lock on flush

 kernel/bpf/devmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
1.8.3.1
