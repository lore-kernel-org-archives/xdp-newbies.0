Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56442 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfBUJUm (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 21 Feb 2019 04:20:42 -0500
Date: Thu, 21 Feb 2019 10:19:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 4/5] sched/topology: Annonate RCU pointers properly
Message-ID: <20190221091944.GY32477@hirez.programming.kicks-ass.net>
References: <20190221054942.132388-1-joel@joelfernandes.org>
 <20190221054942.132388-5-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221054942.132388-5-joel@joelfernandes.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, Ingo Molnar <mingo@redhat.com>, "moderated list:INTEL ETHERNET DRIVERS" <intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Thu, Feb 21, 2019 at 12:49:41AM -0500, Joel Fernandes (Google) wrote:

> Also replace rcu_assign_pointer call on rq->sd with WRITE_ONCE. This
> should be sufficient for the rq->sd initialization.

> @@ -668,7 +668,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>  
>  	rq_attach_root(rq, rd);
>  	tmp = rq->sd;
> -	rcu_assign_pointer(rq->sd, sd);
> +	WRITE_ONCE(rq->sd, sd);
>  	dirty_sched_domain_sysctl(cpu);
>  	destroy_sched_domains(tmp);

Where did the RELEASE barrier go?

That was a publish operation, now it is not.
