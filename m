Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33037 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbfB0PmT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Feb 2019 10:42:19 -0500
Received: by mail-qk1-f193.google.com with SMTP id x9so10125146qkf.0
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Feb 2019 07:42:18 -0800 (PST)
Date: Wed, 27 Feb 2019 10:42:16 -0500
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v2 3/6] sched/cpufreq: Annotate cpufreq_update_util_data
 pointer with __rcu
Message-ID: <20190227154216.GA248723@google.com>
References: <20190223063434.6793-1-joel@joelfernandes.org>
 <20190223063434.6793-4-joel@joelfernandes.org>
 <20190225211026.GX4072@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225211026.GX4072@linux.ibm.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Mon, Feb 25, 2019 at 01:10:26PM -0800, Paul E. McKenney wrote:
> On Sat, Feb 23, 2019 at 01:34:31AM -0500, Joel Fernandes (Google) wrote:
> > Recently I added an RCU annotation check to rcu_assign_pointer(). All
> > pointers assigned to RCU protected data are to be annotated with __rcu
> > inorder to be able to use rcu_assign_pointer() similar to checks in
> > other RCU APIs.
> > 
> > This resulted in a sparse error: kernel//sched/cpufreq.c:41:9: sparse:
> > error: incompatible types in comparison expression (different address
> > spaces)
> > 
> > Fix this by annotating cpufreq_update_util_data pointer with __rcu. This
> > will also help sparse catch any future RCU misuage bugs.
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> From an RCU perspective:
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>

Thanks a lot Paul.

Peter, Rafael, Steve,
Are you Ok with the patches 3-6? It will be nice to quiet down sparse.

thanks,

 - Joel

> > ---
> >  kernel/sched/cpufreq.c | 2 +-
> >  kernel/sched/sched.h   | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched/cpufreq.c b/kernel/sched/cpufreq.c
> > index 22bd8980f32f..e316ee7bb2e5 100644
> > --- a/kernel/sched/cpufreq.c
> > +++ b/kernel/sched/cpufreq.c
> > @@ -7,7 +7,7 @@
> >   */
> >  #include "sched.h"
> >  
> > -DEFINE_PER_CPU(struct update_util_data *, cpufreq_update_util_data);
> > +DEFINE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
> >  
> >  /**
> >   * cpufreq_add_update_util_hook - Populate the CPU's update_util_data pointer.
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index d04530bf251f..2ab545d40381 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -2166,7 +2166,7 @@ static inline u64 irq_time_read(int cpu)
> >  #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
> >  
> >  #ifdef CONFIG_CPU_FREQ
> > -DECLARE_PER_CPU(struct update_util_data *, cpufreq_update_util_data);
> > +DECLARE_PER_CPU(struct update_util_data __rcu *, cpufreq_update_util_data);
> >  
> >  /**
> >   * cpufreq_update_util - Take a note about CPU utilization changes.
> > -- 
> > 2.21.0.rc0.258.g878e2cd30e-goog
> > 
> 
