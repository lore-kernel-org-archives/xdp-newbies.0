Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728666AbfBYVNA (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 16:13:00 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1PL4t9G034391
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:12:59 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2qvnc7qqyy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:12:58 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <xdp-newbies@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 25 Feb 2019 21:12:58 -0000
Date: Mon, 25 Feb 2019 13:12:50 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH v2 6/6] sched: Annotate perf_domain pointer with __rcu
Reply-To: paulmck@linux.ibm.com
References: <20190223063434.6793-1-joel@joelfernandes.org>
 <20190223063434.6793-7-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223063434.6793-7-joel@joelfernandes.org>
Message-Id: <20190225211250.GA4072@linux.ibm.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Sat, Feb 23, 2019 at 01:34:34AM -0500, Joel Fernandes (Google) wrote:
> This fixes the following sparse errors in sched/fair.c:
> 
> fair.c:6506:14: error: incompatible types in comparison expression
> fair.c:8642:21: error: incompatible types in comparison expression
> 
> Using __rcu will also help sparse catch any future bugs.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

From an RCU perspective:

Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>

> ---
>  kernel/sched/sched.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index ca6a79f57e7a..c8e6514433a9 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -780,7 +780,7 @@ struct root_domain {
>  	 * NULL-terminated list of performance domains intersecting with the
>  	 * CPUs of the rd. Protected by RCU.
>  	 */
> -	struct perf_domain	*pd;
> +	struct perf_domain __rcu *pd;
>  };
>  
>  extern struct root_domain def_root_domain;
> -- 
> 2.21.0.rc0.258.g878e2cd30e-goog
> 
