Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39149 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbfBWGe6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 23 Feb 2019 01:34:58 -0500
Received: by mail-qt1-f193.google.com with SMTP id o6so5120560qtk.6
        for <xdp-newbies@vger.kernel.org>; Fri, 22 Feb 2019 22:34:57 -0800 (PST)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH v2 4/6] sched_domain: Annotate RCU pointers properly
Date: Sat, 23 Feb 2019 01:34:32 -0500
Message-Id: <20190223063434.6793-5-joel@joelfernandes.org>
In-Reply-To: <20190223063434.6793-1-joel@joelfernandes.org>
References: <20190223063434.6793-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

The scheduler uses RCU API in various places to access sched_domain
pointers. These cause sparse errors as below.

Many new errors show up because of an annotation check I added to
rcu_assign_pointer(). Let us annotate the pointers correctly which also
will help sparse catch any potential future bugs.

This fixes the following sparse errors:

rt.c:1681:9: error: incompatible types in comparison expression
deadline.c:1904:9: error: incompatible types in comparison expression
core.c:519:9: error: incompatible types in comparison expression
core.c:1634:17: error: incompatible types in comparison expression
fair.c:6193:14: error: incompatible types in comparison expression
fair.c:9883:22: error: incompatible types in comparison expression
fair.c:9897:9: error: incompatible types in comparison expression
sched.h:1287:9: error: incompatible types in comparison expression
topology.c:612:9: error: incompatible types in comparison expression
topology.c:615:9: error: incompatible types in comparison expression
sched.h:1300:9: error: incompatible types in comparison expression
topology.c:618:9: error: incompatible types in comparison expression
sched.h:1287:9: error: incompatible types in comparison expression
topology.c:621:9: error: incompatible types in comparison expression
sched.h:1300:9: error: incompatible types in comparison expression
topology.c:624:9: error: incompatible types in comparison expression
topology.c:671:9: error: incompatible types in comparison expression
stats.c:45:17: error: incompatible types in comparison expression
fair.c:5998:15: error: incompatible types in comparison expression
fair.c:5989:15: error: incompatible types in comparison expression
fair.c:5998:15: error: incompatible types in comparison expression
fair.c:5989:15: error: incompatible types in comparison expression
fair.c:6120:19: error: incompatible types in comparison expression
fair.c:6506:14: error: incompatible types in comparison expression
fair.c:6515:14: error: incompatible types in comparison expression
fair.c:6623:9: error: incompatible types in comparison expression
fair.c:5970:17: error: incompatible types in comparison expression
fair.c:8642:21: error: incompatible types in comparison expression
fair.c:9253:9: error: incompatible types in comparison expression
fair.c:9331:9: error: incompatible types in comparison expression
fair.c:9519:15: error: incompatible types in comparison expression
fair.c:9533:14: error: incompatible types in comparison expression
fair.c:9542:14: error: incompatible types in comparison expression
fair.c:9567:14: error: incompatible types in comparison expression
fair.c:9597:14: error: incompatible types in comparison expression
fair.c:9421:16: error: incompatible types in comparison expression
fair.c:9421:16: error: incompatible types in comparison expression

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/sched/topology.h |  4 ++--
 kernel/sched/sched.h           | 14 +++++++-------
 kernel/sched/topology.c        | 10 +++++-----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index c31d3a47a47c..4819c9e01e42 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -76,8 +76,8 @@ struct sched_domain_shared {
 
 struct sched_domain {
 	/* These fields must be setup */
-	struct sched_domain *parent;	/* top domain must be null terminated */
-	struct sched_domain *child;	/* bottom domain must be null terminated */
+	struct sched_domain __rcu *parent;	/* top domain must be null terminated */
+	struct sched_domain __rcu *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2ab545d40381..ca6a79f57e7a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -866,8 +866,8 @@ struct rq {
 	atomic_t		nr_iowait;
 
 #ifdef CONFIG_SMP
-	struct root_domain	*rd;
-	struct sched_domain	*sd;
+	struct root_domain		*rd;
+	struct sched_domain __rcu	*sd;
 
 	unsigned long		cpu_capacity;
 	unsigned long		cpu_capacity_orig;
@@ -1305,13 +1305,13 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 	return sd;
 }
 
-DECLARE_PER_CPU(struct sched_domain *, sd_llc);
+DECLARE_PER_CPU(struct sched_domain __rcu *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
-DECLARE_PER_CPU(struct sched_domain_shared *, sd_llc_shared);
-DECLARE_PER_CPU(struct sched_domain *, sd_numa);
-DECLARE_PER_CPU(struct sched_domain *, sd_asym_packing);
-DECLARE_PER_CPU(struct sched_domain *, sd_asym_cpucapacity);
+DECLARE_PER_CPU(struct sched_domain_shared __rcu *, sd_llc_shared);
+DECLARE_PER_CPU(struct sched_domain __rcu *, sd_numa);
+DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
+DECLARE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
 extern struct static_key_false sched_asym_cpucapacity;
 
 struct sched_group_capacity {
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 3f35ba1d8fde..0844ee757dad 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -586,13 +586,13 @@ static void destroy_sched_domains(struct sched_domain *sd)
  * the cpumask of the domain), this allows us to quickly tell if
  * two CPUs are in the same cache domain, see cpus_share_cache().
  */
-DEFINE_PER_CPU(struct sched_domain *, sd_llc);
+DEFINE_PER_CPU(struct sched_domain __rcu *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
-DEFINE_PER_CPU(struct sched_domain_shared *, sd_llc_shared);
-DEFINE_PER_CPU(struct sched_domain *, sd_numa);
-DEFINE_PER_CPU(struct sched_domain *, sd_asym_packing);
-DEFINE_PER_CPU(struct sched_domain *, sd_asym_cpucapacity);
+DEFINE_PER_CPU(struct sched_domain_shared __rcu *, sd_llc_shared);
+DEFINE_PER_CPU(struct sched_domain __rcu *, sd_numa);
+DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_packing);
+DEFINE_PER_CPU(struct sched_domain __rcu *, sd_asym_cpucapacity);
 DEFINE_STATIC_KEY_FALSE(sched_asym_cpucapacity);
 
 static void update_top_cache_domain(int cpu)
-- 
2.21.0.rc0.258.g878e2cd30e-goog
