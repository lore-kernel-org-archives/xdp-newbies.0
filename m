Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:52278 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfCRWzQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Mar 2019 18:55:16 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 44909B4A
        for <xdp-newbies@vger.kernel.org>; Mon, 18 Mar 2019 22:55:15 +0000 (UTC)
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sYzK0IiBmj-9 for <xdp-newbies@vger.kernel.org>;
        Mon, 18 Mar 2019 17:55:15 -0500 (CDT)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 0B712B38
        for <xdp-newbies@vger.kernel.org>; Mon, 18 Mar 2019 17:55:15 -0500 (CDT)
Received: by mail-it1-f197.google.com with SMTP id m132so2141643ita.4
        for <xdp-newbies@vger.kernel.org>; Mon, 18 Mar 2019 15:55:15 -0700 (PDT)
From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] thunderbolt: xdomain: Fix to check return value of kmemdup
Date: Mon, 18 Mar 2019 17:55:08 -0500
Message-Id: <20190318225508.7886-1-pakki001@umn.edu>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Andreas Noever <andreas.noever@gmail.com>, Michael Jamet <michael.jamet@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Yehezkel Bernat <YehezkelShB@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

kmemdup can fail and return a NULL pointer. The patch modifies the
signature of tb_xdp_schedule_request and passes the failure error upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/thunderbolt/xdomain.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index e27dd8beb94b..b0e9cc30d708 100644
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
@@ -534,13 +534,16 @@ tb_xdp_schedule_request(struct tb *tb, const struct tb_xdp_header *hdr,
 
 	xw = kmalloc(sizeof(*xw), GFP_KERNEL);
 	if (!xw)
-		return;
+		return false;
 
 	INIT_WORK(&xw->work, tb_xdp_handle_request);
 	xw->pkg = kmemdup(hdr, size, GFP_KERNEL);
+	if (!xw->pkg)
+		return false;
 	xw->tb = tb;
 
 	queue_work(tb->wq, &xw->work);
+	return true;
 }
 
 /**
@@ -1417,8 +1420,7 @@ bool tb_xdomain_handle_request(struct tb *tb, enum tb_cfg_pkg_type type,
 	 */
 	if (uuid_equal(&hdr->uuid, &tb_xdp_uuid)) {
 		if (type == TB_CFG_PKG_XDOMAIN_REQ) {
-			tb_xdp_schedule_request(tb, hdr, size);
-			return true;
+			return tb_xdp_schedule_request(tb, hdr, size);
 		}
 		return false;
 	}
-- 
2.17.1
