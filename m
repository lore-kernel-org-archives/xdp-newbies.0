Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728019AbfBYVKh (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 16:10:37 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1PL4npW000591
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:10:36 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qvq4aajmn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:10:36 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <xdp-newbies@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 25 Feb 2019 21:10:35 -0000
Date: Mon, 25 Feb 2019 13:10:26 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH v2 3/6] sched/cpufreq: Annotate cpufreq_update_util_data
 pointer with __rcu
Reply-To: paulmck@linux.ibm.com
References: <20190223063434.6793-1-joel@joelfernandes.org>
 <20190223063434.6793-4-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223063434.6793-4-joel@joelfernandes.org>
Message-Id: <20190225211026.GX4072@linux.ibm.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Sat, Feb 23, 2019 at 01:34:31AM -0500, Joel Fernandes (Google) wrote:
> Recently I added an RCU annotation check to rcu_assign_pointer(). All
> pointers assigned to RCU protected data are to be annotated with __rcu
> inorder to be able to use rcu_assign_pointer() similar to checks in
> other RCU APIs.
> 
> This resulted in a sparse error: kernel//sched/cpufreq.c:41:9: sparse:
> error: incompatible types in comparison expression (different address
> spaces)
> 
> Fix this by annotating cpufreq_update_util_data pointer with __rcu. This
> will also help sparse catch any future RCU misuage bugs.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

From an RCU perspective:

Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>

> ---
>  kernel/sched/cpufreq.c | 2 +-
>  kernel/sched/sched.h   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/cpufreq.c b/kernel/sched/cpufreq.c
> index 22bd8980f32f..e316ee7bb2e5 100644
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
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index d04530bf251f..2ab545d40381 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -2166,7 +2166,7 @@ static inline u64 irq_time_read(int cpu)
>  #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
>  
>  #ifdef CONFIG_CPU_FREQ
> -DECLARE_PER_CPU(struct update_util_data *, cpufreq_update_util_data);
> +DECLARE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
>  
>  /**
>   * cpufreq_update_util - Take a note about CPU utilization changes.
> -- 
> 2.21.0.rc0.258.g878e2cd30e-goog
> 
