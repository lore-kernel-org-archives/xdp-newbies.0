Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727790AbfBYVKG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Feb 2019 16:10:06 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1PL4mG2038849
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:10:05 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qvn8crpva-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Feb 2019 16:10:04 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <xdp-newbies@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Mon, 25 Feb 2019 21:10:03 -0000
Date: Mon, 25 Feb 2019 13:09:55 -0800
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH v2 2/6] ixgbe: Fix incorrect RCU API usage
Reply-To: paulmck@linux.ibm.com
References: <20190223063434.6793-1-joel@joelfernandes.org>
 <20190223063434.6793-3-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190223063434.6793-3-joel@joelfernandes.org>
Message-Id: <20190225210955.GW4072@linux.ibm.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Christian Brauner <christian@brauner.io>, Daniel Borkmann <daniel@iogearbox.net>, David Ahern <dsahern@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, kernel-team@android.com, Kirill Tkhai <ktkhai@virtuozzo.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Martin KaFai Lau <kafai@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Quentin Perret <quentin.perret@arm.com>, rcu@vger.kernel.org, Song Liu <songliubraving@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>

On Sat, Feb 23, 2019 at 01:34:30AM -0500, Joel Fernandes (Google) wrote:
> Recently, I added an RCU annotation check in rcu_assign_pointer. This
> caused a sparse error to be reported by the ixgbe driver.
> 
> Further looking, it seems the adapter->xdp_prog pointer is not annotated
> with __rcu. Annonating it fixed the error, but caused a bunch of other
> warnings.
> 
> This patch tries to fix all warnings by using RCU API properly. This
> makes sense to do because not using RCU properly can result in various
> hard to find bugs. This is a best effort fix and is only build tested.
> The sparse errors and warnings go away with the change. I request
> maintainers / developers in this area to review / test it properly.
> 
> The sparse error fixed is:
> ixgbe_main.c:10256:25: error: incompatible types in comparison expression
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

From an RCU perspective:

Reviewed-by: Paul E. McKenney <paulmck@linux.ibm.com>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  4 ++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 15 ++++++++++-----
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index 08d85e336bd4..3b14daf27516 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> @@ -311,7 +311,7 @@ struct ixgbe_ring {
>  	struct ixgbe_ring *next;	/* pointer to next ring in q_vector */
>  	struct ixgbe_q_vector *q_vector; /* backpointer to host q_vector */
>  	struct net_device *netdev;	/* netdev ring belongs to */
> -	struct bpf_prog *xdp_prog;
> +	struct bpf_prog __rcu *xdp_prog;
>  	struct device *dev;		/* device for DMA mapping */
>  	void *desc;			/* descriptor ring memory */
>  	union {
> @@ -560,7 +560,7 @@ struct ixgbe_adapter {
>  	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
>  	/* OS defined structs */
>  	struct net_device *netdev;
> -	struct bpf_prog *xdp_prog;
> +	struct bpf_prog __rcu *xdp_prog;
>  	struct pci_dev *pdev;
>  	struct mii_bus *mii_bus;
>  
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index daff8183534b..408a312aa6ba 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -2199,7 +2199,7 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
>  	u32 act;
>  
>  	rcu_read_lock();
> -	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
> +	xdp_prog = rcu_dereference(rx_ring->xdp_prog);
>  
>  	if (!xdp_prog)
>  		goto xdp_out;
> @@ -6547,7 +6547,7 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
>  			     rx_ring->queue_index) < 0)
>  		goto err;
>  
> -	rx_ring->xdp_prog = adapter->xdp_prog;
> +	rcu_assign_pointer(rx_ring->xdp_prog, adapter->xdp_prog);
>  
>  	return 0;
>  err:
> @@ -10246,7 +10246,8 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  	if (nr_cpu_ids > MAX_XDP_QUEUES)
>  		return -ENOMEM;
>  
> -	old_prog = xchg(&adapter->xdp_prog, prog);
> +	old_prog = rcu_access_pointer(adapter->xdp_prog);
> +	rcu_assign_pointer(adapter->xdp_prog, prog);
>  
>  	/* If transitioning XDP modes reconfigure rings */
>  	if (!!prog != !!old_prog) {
> @@ -10271,13 +10272,17 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  static int ixgbe_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  {
>  	struct ixgbe_adapter *adapter = netdev_priv(dev);
> +	struct bpf_prog *prog;
>  
>  	switch (xdp->command) {
>  	case XDP_SETUP_PROG:
>  		return ixgbe_xdp_setup(dev, xdp->prog);
>  	case XDP_QUERY_PROG:
> -		xdp->prog_id = adapter->xdp_prog ?
> -			adapter->xdp_prog->aux->id : 0;
> +		rcu_read_lock();
> +		prog = rcu_dereference(adapter->xdp_prog);
> +		xdp->prog_id = prog ? prog->aux->id : 0;
> +		rcu_read_unlock();
> +
>  		return 0;
>  	case XDP_QUERY_XSK_UMEM:
>  		return ixgbe_xsk_umem_query(adapter, &xdp->xsk.umem,
> -- 
> 2.21.0.rc0.258.g878e2cd30e-goog
> 
