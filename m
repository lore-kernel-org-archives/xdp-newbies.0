Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39955 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfBUFuH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 00:50:07 -0500
Received: by mail-qt1-f193.google.com with SMTP id j36so30213425qta.7
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Feb 2019 21:50:06 -0800 (PST)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH RFC 5/5] rcuwait: Replace rcu_assign_pointer() with WRITE_ONCE
Date: Thu, 21 Feb 2019 00:49:42 -0500
Message-Id: <20190221054942.132388-6-joel@joelfernandes.org>
In-Reply-To: <20190221054942.132388-1-joel@joelfernandes.org>
References: <20190221054942.132388-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

This suppresses a sparse error generated due to the recently added
rcu_assign_pointer sparse check below. It seems WRITE_ONCE should be
sufficient here.

>> kernel//locking/percpu-rwsem.c:162:9: sparse: error: incompatible
types in comparison expression (different address spaces)

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rcuwait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index 90bfa3279a01..9e5b4760e6c2 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -44,7 +44,7 @@ extern void rcuwait_wake_up(struct rcuwait *w);
 	 */                                                             \
 	WARN_ON(current->exit_state);                                   \
 									\
-	rcu_assign_pointer((w)->task, current);				\
+	WRITE_ONCE((w)->task, current);					\
 	for (;;) {							\
 		/*							\
 		 * Implicit barrier (A) pairs with (B) in		\
-- 
2.21.0.rc0.258.g878e2cd30e-goog
