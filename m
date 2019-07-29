Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62911 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfG2MQo (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 29 Jul 2019 08:16:44 -0400
Subject: [PATCH net-next] MAINTAINERS: Remove mailing-list entry for XDP
 (eXpress Data Path)
From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 29 Jul 2019 14:16:37 +0200
Message-ID: <156440259790.6123.1563221733550893420.stgit@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

This removes the mailing list xdp-newbies@vger.kernel.org from the XDP
kernel maintainers entry.

Being in the kernel MAINTAINERS file successfully caused the list to
receive kbuild bot warnings, syzbot reports and sometimes developer
patches. The level of details in these messages, doesn't match the
target audience of the XDP-newbies list. This is based on a survey on
the mailing list, where 73% voted for removal from MAINTAINERS file.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9cc156c58f0c..45cb4237eddc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17560,7 +17560,6 @@ M:	Jakub Kicinski <jakub.kicinski@netronome.com>
 M:	Jesper Dangaard Brouer <hawk@kernel.org>
 M:	John Fastabend <john.fastabend@gmail.com>
 L:	netdev@vger.kernel.org
-L:	xdp-newbies@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Supported
 F:	net/core/xdp.c
