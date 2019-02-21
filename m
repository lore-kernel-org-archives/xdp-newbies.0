Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36638 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfBUPbt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 10:31:49 -0500
Date: Thu, 21 Feb 2019 16:31:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 3/5] sched/cpufreq: Fix incorrect RCU API usage
Message-ID: <20190221153117.GT32494@hirez.programming.kicks-ass.net>
References: <20190221054942.132388-1-joel@joelfernandes.org>
 <20190221054942.132388-4-joel@joelfernandes.org>
 <20190221091805.GX32477@hirez.programming.kicks-ass.net>
 <20190221152139.GB19213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221152139.GB19213@google.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Thu, Feb 21, 2019 at 10:21:39AM -0500, Joel Fernandes wrote:
> On Thu, Feb 21, 2019 at 10:18:05AM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 21, 2019 at 12:49:40AM -0500, Joel Fernandes (Google) wrote:
> > > @@ -34,8 +34,12 @@ void cpufreq_add_update_util_hook(int cpu, struct update_util_data *data,
> > >  	if (WARN_ON(!data || !func))
> > >  		return;
> > >  
> > > -	if (WARN_ON(per_cpu(cpufreq_update_util_data, cpu)))
> > > +	rcu_read_lock();
> > > +	if (WARN_ON(rcu_dereference(per_cpu(cpufreq_update_util_data, cpu)))) {
> > > +		rcu_read_unlock();
> > >  		return;
> > > +	}
> > > +	rcu_read_unlock();
> > >  
> > >  	data->func = func;
> > >  	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), data);
> > 
> > This doesn't make any kind of sense to me.
> > 
> 
> As per the rcu_assign_pointer() line, I inferred that
> cpufreq_update_util_data is expected to be RCU protected. Reading the pointer
> value of RCU pointers generally needs to be done from RCU read section, and
> using rcu_dereference() (or using rcu_access()).
> 
> In this patch, I changed cpufreq_update_util_data to be __rcu annotated to
> avoid the sparse error thrown by rcu_assign_pointer().
> 
> Instead of doing that, If your intention here is RELEASE barrier, should I
> just replace in this function:
> 	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), data);
> with:
> 	smp_store_release(per_cpu(cpufreq_update_util_data, cpu), data))
> ?
> 
> It would be nice IMO to be explicit about the intention of release/publish
> semantics by using smp_store_release().

No, it is RCU managed, it should be RCU. The problem is that the hunk
above is utter crap.

All that does is read the pointer, it never actually dereferences it.
