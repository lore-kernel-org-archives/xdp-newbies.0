Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41466 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfBURNP (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 12:13:15 -0500
Received: by mail-qk1-f195.google.com with SMTP id y15so3243674qki.8
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Feb 2019 09:13:14 -0800 (PST)
Date: Thu, 21 Feb 2019 12:13:11 -0500
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH RFC 3/5] sched/cpufreq: Fix incorrect RCU API usage
Message-ID: <20190221171311.GA118415@google.com>
References: <20190221054942.132388-1-joel@joelfernandes.org>
 <20190221054942.132388-4-joel@joelfernandes.org>
 <20190221091805.GX32477@hirez.programming.kicks-ass.net>
 <20190221152139.GB19213@google.com>
 <20190221153117.GT32494@hirez.programming.kicks-ass.net>
 <20190221155218.GZ11787@linux.ibm.com>
 <20190221161144.GU32494@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221161144.GU32494@hirez.programming.kicks-ass.net>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Thu, Feb 21, 2019 at 05:11:44PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 21, 2019 at 07:52:18AM -0800, Paul E. McKenney wrote:
> > On Thu, Feb 21, 2019 at 04:31:17PM +0100, Peter Zijlstra wrote:
> > > On Thu, Feb 21, 2019 at 10:21:39AM -0500, Joel Fernandes wrote:
> > > > On Thu, Feb 21, 2019 at 10:18:05AM +0100, Peter Zijlstra wrote:
> > > > > On Thu, Feb 21, 2019 at 12:49:40AM -0500, Joel Fernandes (Google) wrote:
> > > > > > @@ -34,8 +34,12 @@ void cpufreq_add_update_util_hook(int cpu, struct update_util_data *data,
> > > > > >  	if (WARN_ON(!data || !func))
> > > > > >  		return;
> > > > > >  
> > > > > > -	if (WARN_ON(per_cpu(cpufreq_update_util_data, cpu)))
> > > > > > +	rcu_read_lock();
> > > > > > +	if (WARN_ON(rcu_dereference(per_cpu(cpufreq_update_util_data, cpu)))) {
> > > > > > +		rcu_read_unlock();
> > > > > >  		return;
> > > > > > +	}
> > > > > > +	rcu_read_unlock();
> > > > > >  
> > > > > >  	data->func = func;
> > > > > >  	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), data);
> 
> > For whatever it is worth, in that case it could use rcu_access_pointer().
> > And this primitive does not do the lockdep check for being within an RCU
> > read-side critical section.  As Peter says, if there is no dereferencing,
> > there can be no use-after-free bug, so the RCU read-side critical is
> > not needed.
> 
> On top of that, I suspect this is under the write-side lock (we're doing
> assignment after all).

Yes it is under a policy->rwsem, just confirmed that.

And indeed rcu_read_lock() is not needed here in this patch, thanks for
pointing that out. Sometimes the word "dereference" plays some visual tricks
and in this case tempted me to add an RCU reader section ;-) Assuming you
guys are in agreement with usage of rcu_access_pointer() here to keep sparse
happy, I'll rework the patch accordingly and resubmit with that.

thanks!

 - Joel
