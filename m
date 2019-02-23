Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38087 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfBWGex (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 23 Feb 2019 01:34:53 -0500
Received: by mail-qt1-f194.google.com with SMTP id s1so5126576qte.5
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Feb 2019 22:34:52 -0800 (PST)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v2 1/6] net: rtnetlink: Fix incorrect RCU API usage
Date: Sat, 23 Feb 2019 01:34:29 -0500
Message-Id: <20190223063434.6793-2-joel@joelfernandes.org>
In-Reply-To: <20190223063434.6793-1-joel@joelfernandes.org>
References: <20190223063434.6793-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

rtnl_register_internal() and rtnl_unregister_all tries to directly
dereference an RCU protected pointed outside RCU read side section.
While this is Ok to do since a lock is held, let us use the correct
API to avoid programmer bugs in the future.

This also fixes sparse warnings arising from not using RCU API.

net/core/rtnetlink.c:332:13: warning: incorrect type in assignment
(different address spaces) net/core/rtnetlink.c:332:13:    expected
struct rtnl_link **tab net/core/rtnetlink.c:332:13:    got struct
rtnl_link *[noderef] <asn:4>*<noident>

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 net/core/rtnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5ea1bed08ede..98be4b4818a9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -188,7 +188,7 @@ static int rtnl_register_internal(struct module *owner,
 	msgindex = rtm_msgindex(msgtype);
 
 	rtnl_lock();
-	tab = rtnl_msg_handlers[protocol];
+	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
 	if (tab == NULL) {
 		tab = kcalloc(RTM_NR_MSGTYPES, sizeof(void *), GFP_KERNEL);
 		if (!tab)
@@ -329,7 +329,7 @@ void rtnl_unregister_all(int protocol)
 	BUG_ON(protocol < 0 || protocol > RTNL_FAMILY_MAX);
 
 	rtnl_lock();
-	tab = rtnl_msg_handlers[protocol];
+	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
 	if (!tab) {
 		rtnl_unlock();
 		return;
-- 
2.21.0.rc0.258.g878e2cd30e-goog
