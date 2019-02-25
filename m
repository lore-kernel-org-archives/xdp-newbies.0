Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727586AbfBYVGE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 16:06:04 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1PL4q4M104778
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:06:03 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qvncy7pmx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:06:03 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <xdp-newbies@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 25 Feb 2019 21:06:01 -0000
Date: Mon, 25 Feb 2019 13:05:51 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH v2 1/6] net: rtnetlink: Fix incorrect RCU API usage
Reply-To: paulmck@linux.ibm.com
References: <20190223063434.6793-1-joel@joelfernandes.org>
 <20190223063434.6793-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223063434.6793-2-joel@joelfernandes.org>
Message-Id: <20190225210551.GV4072@linux.ibm.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Sat, Feb 23, 2019 at 01:34:29AM -0500, Joel Fernandes (Google) wrote:
> rtnl_register_internal() and rtnl_unregister_all tries to directly
> dereference an RCU protected pointed outside RCU read side section.
> While this is Ok to do since a lock is held, let us use the correct
> API to avoid programmer bugs in the future.
> 
> This also fixes sparse warnings arising from not using RCU API.
> 
> net/core/rtnetlink.c:332:13: warning: incorrect type in assignment
> (different address spaces) net/core/rtnetlink.c:332:13:    expected
> struct rtnl_link **tab net/core/rtnetlink.c:332:13:    got struct
> rtnl_link *[noderef] <asn:4>*<noident>
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

From an RCU perspective:

Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>

> ---
>  net/core/rtnetlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 5ea1bed08ede..98be4b4818a9 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -188,7 +188,7 @@ static int rtnl_register_internal(struct module *owner,
>  	msgindex = rtm_msgindex(msgtype);
>  
>  	rtnl_lock();
> -	tab = rtnl_msg_handlers[protocol];
> +	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
>  	if (tab == NULL) {
>  		tab = kcalloc(RTM_NR_MSGTYPES, sizeof(void *), GFP_KERNEL);
>  		if (!tab)
> @@ -329,7 +329,7 @@ void rtnl_unregister_all(int protocol)
>  	BUG_ON(protocol < 0 || protocol > RTNL_FAMILY_MAX);
>  
>  	rtnl_lock();
> -	tab = rtnl_msg_handlers[protocol];
> +	tab = rtnl_dereference(rtnl_msg_handlers[protocol]);
>  	if (!tab) {
>  		rtnl_unlock();
>  		return;
> -- 
> 2.21.0.rc0.258.g878e2cd30e-goog
> 
