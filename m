Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46165 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfF1IEQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 28 Jun 2019 04:04:16 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190628080415euoutp02c6bc5935dbff4a081e7936ca8aa6a3f5~sThyUPxeL1432614326euoutp02a
        for <xdp-newbies@vger.kernel.org>; Fri, 28 Jun 2019 08:04:15 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v6 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date: Fri, 28 Jun 2019 11:04:05 +0300
Message-Id: <20190628080407.30354-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190628080413eucas1p13f3400f657b4827414737af42f02a57b@eucas1p1.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

Version 6:

    * Better names for socket state.

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
