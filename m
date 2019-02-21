Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from cloudserver094114.home.pl ([79.96.170.134]:63179 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbfBUXGj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 18:06:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH RFC 3/5] sched/cpufreq: Fix incorrect RCU API usage
Date: Fri, 22 Feb 2019 00:05:08 +0100
Message-ID: <3194474.xhKMNsEZRq@aspire.rjw.lan>
In-Reply-To: <20190221054942.132388-4-joel@joelfernandes.org>
References: <20190221054942.132388-1-joel@joelfernandes.org> <20190221054942.132388-4-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Thursday, February 21, 2019 6:49:40 AM CET Joel Fernandes (Google) wrote:
> Recently I added an RCU annotation check to rcu_assign_pointer(). All
> pointers assigned to RCU protected data are to be annotated with __rcu
> inorder to be able to use rcu_assign_pointer() similar to checks in
> other RCU APIs.
> 
> This resulted in a sparse error: kernel//sched/cpufreq.c:41:9: sparse:
> error: incompatible types in comparison expression (different address
> spaces)
> 
> Fix this by using the correct APIs for RCU accesses. This will
> potentially avoid any future bugs in the code. If it is felt that RCU
> protection is not needed here, then the rcu_assign_pointer call can be
> dropped and replaced with, say, WRITE_ONCE or smp_store_release. Or, may
> be we add a new API to do it. But calls rcu_assign_pointer seems an
> abuse of the RCU API unless RCU is being used.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  kernel/sched/cpufreq.c | 8 ++++++--
>  kernel/sched/sched.h   | 2 +-
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/cpufreq.c b/kernel/sched/cpufreq.c
> index 22bd8980f32f..c9aeb3bf5dc2 100644
> --- a/kernel/sched/cpufreq.c
> +++ b/kernel/sched/cpufreq.c
> @@ -7,7 +7,7 @@
>   */
>  #include "sched.h"
>  
> -DEFINE_PER_CPU(struct update_util_data *, cpufreq_update_util_data);
> +DEFINE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
>  
>  /**
>   * cpufreq_add_update_util_hook - Populate the CPU's update_util_data pointer.
> @@ -34,8 +34,12 @@ void cpufreq_add_update_util_hook(int cpu, struct update_util_data *data,
>  	if (WARN_ON(!data || !func))
>  		return;
>  
> -	if (WARN_ON(per_cpu(cpufreq_update_util_data, cpu)))
> +	rcu_read_lock();
> +	if (WARN_ON(rcu_dereference(per_cpu(cpufreq_update_util_data, cpu)))) {
> +		rcu_read_unlock();
>  		return;
> +	}
> +	rcu_read_unlock();

As Steve said, this is not a read-side critical section, so the rcu_read_lock()
and rcu_read_unlock() don't help.

But rcu_access_pointer() should work here AFAICS.

Cheers,
Rafael
