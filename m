Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33455 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfBUFt5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 00:49:57 -0500
Received: by mail-qk1-f194.google.com with SMTP id x9so3626999qkf.0
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Feb 2019 21:49:56 -0800 (PST)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH RFC 0/5] RCU fixes for rcu_assign_pointer() usage
Date: Thu, 21 Feb 2019 00:49:37 -0500
Message-Id: <20190221054942.132388-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

These patches fix various RCU API usage issues found due to sparse errors as a
result of the recent check to add rcu_check_sparse() to rcu_assign_pointer().
The errors in many cases seem to indicate either an incorrect API usage, or
missing annotations. The annotations added can also help avoid future incorrect
usages and bugs so it is a good idea to do in any case.

These are only build/boot tested and I request for feedback from maintainers
and developers in the various areas the patches touch. Thanks for any feedback!

(There are still errors in rbtree.h but I have kept those for a later time
since fixing them is a bit more involved).

Joel Fernandes (Google) (5):
net: rtnetlink: Fix incorrect RCU API usage
ixgbe: Fix incorrect RCU API usage
sched/cpufreq: Fix incorrect RCU API usage
sched/topology: Annonate RCU pointers properly
rcuwait: Replace rcu_assign_pointer() with WRITE_ONCE

drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  4 ++--
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 17 ++++++++++++-----
include/linux/rcuwait.h                       |  2 +-
kernel/sched/cpufreq.c                        |  8 ++++++--
kernel/sched/sched.h                          | 14 +++++++-------
kernel/sched/topology.c                       | 12 ++++++------
net/core/rtnetlink.c                          |  4 ++--
7 files changed, 36 insertions(+), 25 deletions(-)

--
2.21.0.rc0.258.g878e2cd30e-goog
