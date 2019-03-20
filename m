Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:48040 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfCTQrY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Mar 2019 12:47:24 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id EC67FBC2
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Mar 2019 16:47:22 +0000 (UTC)
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iwzmxGBMVciK for <xdp-newbies@vger.kernel.org>;
        Wed, 20 Mar 2019 11:47:22 -0500 (CDT)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id AF7E9178
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Mar 2019 11:47:22 -0500 (CDT)
Received: by mail-it1-f200.google.com with SMTP id e63so2828003ita.1
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Mar 2019 09:47:22 -0700 (PDT)
From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH v2] thunderbolt: xdomain: Fix to check return value of kmemdup
Date: Wed, 20 Mar 2019 11:47:20 -0500
Message-Id: <20190320164720.31264-1-pakki001@umn.edu>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Andreas Noever <andreas.noever@gmail.com>, Michael Jamet <michael.jamet@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Yehezkel Bernat <YehezkelShB@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

kmemdup can fail and return a NULL pointer. The patch modifies the
signature of tb_xdp_schedule_request and passes the failure error upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>

---
v1: Missed clean up of xw in case of kmemdup failure, per David
---
 drivers/thunderbolt/xdomain.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index e27dd8beb94b..316360109bea 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -526,7 +526,7 @@ static void tb_xdp_handle_request(struct work_struct *work)
 	kfree(xw);
 }
 
-static void
+static bool
 tb_xdp_schedule_request(struct tb *tb, const struct tb_xdp_header *hdr,
 			size_t size)
 {
@@ -534,13 +534,18 @@ tb_xdp_schedule_request(struct tb *tb, const struct tb_xdp_header *hdr,
 
 	xw = kmalloc(sizeof(*xw), GFP_KERNEL);
 	if (!xw)
-		return;
+		return false;
 
 	INIT_WORK(&xw->work, tb_xdp_handle_request);
 	xw->pkg = kmemdup(hdr, size, GFP_KERNEL);
+	if (!xw->pkg) {
+		kfree(xw);
+		return false;
+	}
 	xw->tb = tb;
 
 	queue_work(tb->wq, &xw->work);
+	return true;
 }
 
 /**
@@ -1416,10 +1421,8 @@ bool tb_xdomain_handle_request(struct tb *tb, enum tb_cfg_pkg_type type,
 	 * handlers in turn.
 	 */
 	if (uuid_equal(&hdr->uuid, &tb_xdp_uuid)) {
-		if (type == TB_CFG_PKG_XDOMAIN_REQ) {
-			tb_xdp_schedule_request(tb, hdr, size);
-			return true;
-		}
+		if (type == TB_CFG_PKG_XDOMAIN_REQ)
+			return tb_xdp_schedule_request(tb, hdr, size);
 		return false;
 	}
 
-- 
2.17.1
