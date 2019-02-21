Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbfBUR37 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 12:29:59 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1LHOOZE094407
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Feb 2019 12:29:58 -0500
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qsx65qted-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Feb 2019 12:29:58 -0500
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <xdp-newbies@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Thu, 21 Feb 2019 17:29:56 -0000
Date: Thu, 21 Feb 2019 09:29:48 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH RFC 3/5] sched/cpufreq: Fix incorrect RCU API usage
Reply-To: paulmck@linux.ibm.com
References: <20190221054942.132388-1-joel@joelfernandes.org>
 <20190221054942.132388-4-joel@joelfernandes.org>
 <20190221091805.GX32477@hirez.programming.kicks-ass.net>
 <20190221152139.GB19213@google.com>
 <20190221153117.GT32494@hirez.programming.kicks-ass.net>
 <20190221155218.GZ11787@linux.ibm.com>
 <20190221161144.GU32494@hirez.programming.kicks-ass.net>
 <20190221171311.GA118415@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221171311.GA118415@google.com>
Message-Id: <20190221172948.GA11787@linux.ibm.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Thu, Feb 21, 2019 at 12:13:11PM -0500, Joel Fernandes wrote:
> On Thu, Feb 21, 2019 at 05:11:44PM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 21, 2019 at 07:52:18AM -0800, Paul E. McKenney wrote:
> > > On Thu, Feb 21, 2019 at 04:31:17PM +0100, Peter Zijlstra wrote:
> > > > On Thu, Feb 21, 2019 at 10:21:39AM -0500, Joel Fernandes wrote:
> > > > > On Thu, Feb 21, 2019 at 10:18:05AM +0100, Peter Zijlstra wrote:
> > > > > > On Thu, Feb 21, 2019 at 12:49:40AM -0500, Joel Fernandes (Google) wrote:
> > > > > > > @@ -34,8 +34,12 @@ void cpufreq_add_update_util_hook(int cpu, struct update_util_data *data,
> > > > > > >  	if (WARN_ON(!data || !func))
> > > > > > >  		return;
> > > > > > >  
> > > > > > > -	if (WARN_ON(per_cpu(cpufreq_update_util_data, cpu)))
> > > > > > > +	rcu_read_lock();
> > > > > > > +	if (WARN_ON(rcu_dereference(per_cpu(cpufreq_update_util_data, cpu)))) {
> > > > > > > +		rcu_read_unlock();
> > > > > > >  		return;
> > > > > > > +	}
> > > > > > > +	rcu_read_unlock();
> > > > > > >  
> > > > > > >  	data->func = func;
> > > > > > >  	rcu_assign_pointer(per_cpu(cpufreq_update_util_data, cpu), data);
> > 
> > > For whatever it is worth, in that case it could use rcu_access_pointer().
> > > And this primitive does not do the lockdep check for being within an RCU
> > > read-side critical section.  As Peter says, if there is no dereferencing,
> > > there can be no use-after-free bug, so the RCU read-side critical is
> > > not needed.
> > 
> > On top of that, I suspect this is under the write-side lock (we're doing
> > assignment after all).
> 
> Yes it is under a policy->rwsem, just confirmed that.
> 
> And indeed rcu_read_lock() is not needed here in this patch, thanks for
> pointing that out. Sometimes the word "dereference" plays some visual tricks
> and in this case tempted me to add an RCU reader section ;-) Assuming you
> guys are in agreement with usage of rcu_access_pointer() here to keep sparse
> happy, I'll rework the patch accordingly and resubmit with that.

Works for me!

							Thanx, Paul
