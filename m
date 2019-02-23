Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36080 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfBWGev (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 23 Feb 2019 01:34:51 -0500
Received: by mail-qk1-f196.google.com with SMTP id c2so1785537qkb.3
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Feb 2019 22:34:50 -0800 (PST)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v2 0/6] RCU fixes for rcu_assign_pointer() usage
Date: Sat, 23 Feb 2019 01:34:28 -0500
Message-Id: <20190223063434.6793-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

These patches fix various sparse errors found as a result of the recent check
to add rcu_check_sparse() to rcu_assign_pointer().  The errors in some cases
seem to either missing API usage, or missing annotations. The annotations added
in the series can also help avoid future incorrect usages and bugs so it is a
good idea to do in any case.

RFC v1 -> Patch v2:
Made changes to various scheduler patches (Peter Zijlstra)

Joel Fernandes (Google) (6):
net: rtnetlink: Fix incorrect RCU API usage
ixgbe: Fix incorrect RCU API usage
sched/cpufreq: Annotate cpufreq_update_util_data pointer with __rcu
sched_domain: Annotate RCU pointers properly
rcuwait: Annotate task_struct with __rcu
sched: Annotate perf_domain pointer with __rcu

drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  4 ++--
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 15 ++++++++++-----
include/linux/rcuwait.h                       |  2 +-
include/linux/sched/topology.h                |  4 ++--
kernel/sched/cpufreq.c                        |  2 +-
kernel/sched/sched.h                          | 18 +++++++++---------
kernel/sched/topology.c                       | 10 +++++-----
net/core/rtnetlink.c                          |  4 ++--
8 files changed, 32 insertions(+), 27 deletions(-)

--
2.21.0.rc0.258.g878e2cd30e-goog
