Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32874 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfF0KPi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 27 Jun 2019 06:15:38 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190627101536euoutp021fceeb7483f7088a5f36f4c366b708a9~sBrMMZqGL2411124111euoutp02b
        for <xdp-newbies@vger.kernel.org>; Thu, 27 Jun 2019 10:15:36 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v5 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date: Thu, 27 Jun 2019 13:15:27 +0300
Message-Id: <20190627101529.11234-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190627101535eucas1p27da11c25b0e15474e4c957053de139d9@eucas1p2.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

Version 5:

    * Fixed incorrect handling of rtnl_lock.

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
 net/xdp/xdp_umem.c     | 21 +++++-----
 net/xdp/xdp_umem.h     |  1 +
 net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 93 insertions(+), 21 deletions(-)

-- 
2.17.1
