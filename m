Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53454 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfGWMIT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 23 Jul 2019 08:08:19 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190723120817euoutp026b737431e5c446326b8c2afa3a47b01e~0B_-4OkpB2589225892euoutp02D
        for <xdp-newbies@vger.kernel.org>; Tue, 23 Jul 2019 12:08:17 +0000 (GMT)
From: Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf] libbpf: fix using uninitialized ioctl results
Date: Tue, 23 Jul 2019 15:08:10 +0300
Message-Id: <20190723120810.28801-1-i.maximets@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <CGME20190723120815eucas1p21027b1ab47daba7ebb3a885bf869be8a@eucas1p2.samsung.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Magnus Karlsson <magnus.karlsson@intel.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Ilya Maximets <i.maximets@samsung.com>

'channels.max_combined' initialized only on ioctl success and
errno is only valid on ioctl failure.

The code doesn't produce any runtime issues, but makes memory
sanitizers angry:

 Conditional jump or move depends on uninitialised value(s)
    at 0x55C056F: xsk_get_max_queues (xsk.c:336)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

Additionally fixed warning on uninitialized bytes in ioctl arguments:

 Syscall param ioctl(SIOCETHTOOL) points to uninitialised byte(s)
    at 0x648D45B: ioctl (in /usr/lib64/libc-2.28.so)
    by 0x55C0546: xsk_get_max_queues (xsk.c:330)
    by 0x55C05B2: xsk_create_bpf_maps (xsk.c:354)
    by 0x55C089F: xsk_setup_xdp_prog (xsk.c:447)
    by 0x55C0E57: xsk_socket__create (xsk.c:601)
  Address 0x1ffefff378 is on thread 1's stack
  in frame #1, created by xsk_get_max_queues (xsk.c:318)
  Uninitialised value was created by a stack allocation
    at 0x55C04CD: xsk_get_max_queues (xsk.c:318)

CC: Magnus Karlsson <magnus.karlsson@intel.com>
Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 tools/lib/bpf/xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 5007b5d4fd2c..c4f912dc30f9 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -317,7 +317,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 
 static int xsk_get_max_queues(struct xsk_socket *xsk)
 {
-	struct ethtool_channels channels;
+	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
 	struct ifreq ifr;
 	int fd, err, ret;
 
@@ -325,7 +325,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 	if (fd < 0)
 		return -errno;
 
-	channels.cmd = ETHTOOL_GCHANNELS;
+	memset(&ifr, 0, sizeof(ifr));
 	ifr.ifr_data = (void *)&channels;
 	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
 	ifr.ifr_name[IFNAMSIZ - 1] = '\0';
@@ -335,7 +335,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
+	if (err || channels.max_combined == 0)
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
-- 
2.17.1
