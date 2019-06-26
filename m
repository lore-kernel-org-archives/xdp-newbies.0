Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47139 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFZSPY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 26 Jun 2019 14:15:24 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190626181522euoutp01153a2dd54d8690403efbeb5867f81377~r0kyvsy_p0227202272euoutp01P
        for <xdp-newbies@vger.kernel.org>; Wed, 26 Jun 2019 18:15:22 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v4 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date: Wed, 26 Jun 2019 21:15:13 +0300
Message-Id: <20190626181515.1640-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190626181520eucas1p1817d31d958b8755600f0745e92edef5a@eucas1p1.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

Version 4:

    * 'xdp_umem_clear_dev' exposed to be used while unregistering.
    * Added XDP socket state to track if resources already unbinded.
    * Splitted in two fixes.

Version 3:

    * Declaration lines ordered from longest to shortest.
    * Checking of event type moved to the top to avoid unnecessary
      locking.

Version 2:

    * Completely re-implemented using netdev event handler.

Ilya Maximets (2):
  xdp: hold device for umem regardless of zero-copy mode
  xdp: fix hang while unregistering device bound to xdp socket

 include/net/xdp_sock.h |  5 +++
 net/xdp/xdp_umem.c     | 27 +++++++------
 net/xdp/xdp_umem.h     |  1 +
 net/xdp/xsk.c          | 88 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 99 insertions(+), 22 deletions(-)

-- 
2.17.1
