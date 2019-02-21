Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726671AbfBUPw3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 10:52:29 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1LFnDE8027963
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Feb 2019 10:52:28 -0500
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qswmmmmmb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Feb 2019 10:52:28 -0500
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <xdp-newbies@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 21 Feb 2019 15:52:28 -0000
Date: Thu, 21 Feb 2019 07:52:18 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH RFC 3/5] sched/cpufreq: Fix incorrect RCU API usage
Reply-To: paulmck@linux.ibm.com
References: <20190221054942.132388-1-joel@joelfernandes.org>
 <20190221054942.132388-4-joel@joelfernandes.org>
 <20190221091805.GX32477@hirez.programming.kicks-ass.net>
 <20190221152139.GB19213@google.com>
 <20190221153117.GT32494@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221153117.GT32494@hirez.programming.kicks-ass.net>
Message-Id: <20190221155218.GZ11787@linux.ibm.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joel Fernandes <joel@joelfernandes.org>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Thu, Feb 21, 2019 at 04:31:17PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 21, 2019 at 10:21:39AM -0500, Joel Fernandes wrote:
> > On Thu, Feb 21, 2019 at 10:18:05AM +0100, Peter Zijlstra wrote:
> > > On Thu, Feb 21, 2019 at 12:49:40AM -0500, Joel Fernandes (Google) wrote:
> > > > @@ -34,8 +34,12 @@ void cpufreq_add_update_util_hook(int cpu, struct update_util_data *data,
> > > >  	if (WARN_ON(!data || !func))
> > > >  		return;
> > > >  
> > > > -	if (WARN_ON(per_cpu(cpufreq_update_util_data, cpu)))
> > > > +	rcu_read_lock();
> > > > +	if (WARN_ON(rcu_dereference(per_cpu(cpufreq_update_util_data, cpu)))) {
> > > > +		rcu_read_unlock();
> > > >  		return;
> > > > +	}
> > > > +	rcu_read_unlock();
> > > >  
> > > >  	data->func = func;
> > > >  	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), data);
> > > 
> > > This doesn't make any kind of sense to me.
> > > 
> > 
> > As per the rcu_assign_pointer() line, I inferred that
> > cpufreq_update_util_data is expected to be RCU protected. Reading the pointer
> > value of RCU pointers generally needs to be done from RCU read section, and
> > using rcu_dereference() (or using rcu_access()).
> > 
> > In this patch, I changed cpufreq_update_util_data to be __rcu annotated to
> > avoid the sparse error thrown by rcu_assign_pointer().
> > 
> > Instead of doing that, If your intention here is RELEASE barrier, should I
> > just replace in this function:
> > 	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), data);
> > with:
> > 	smp_store_release(per_cpu(cpufreq_update_util_data, cpu), data))
> > ?
> > 
> > It would be nice IMO to be explicit about the intention of release/publish
> > semantics by using smp_store_release().
> 
> No, it is RCU managed, it should be RCU. The problem is that the hunk
> above is utter crap.
> 
> All that does is read the pointer, it never actually dereferences it.

For whatever it is worth, in that case it could use rcu_access_pointer().
And this primitive does not do the lockdep check for being within an RCU
read-side critical section.  As Peter says, if there is no dereferencing,
there can be no use-after-free bug, so the RCU read-side critical is
not needed.

Good eyes, Peter!  ;-)

							Thanx, Paul
