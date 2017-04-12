Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:32875 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752256AbdDLVak (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Apr 2017 17:30:40 -0400
Received: by mail-pg0-f50.google.com with SMTP id x125so20592564pgb.0
        for <xdp-newbies@vger.kernel.org>; Wed, 12 Apr 2017 14:30:40 -0700 (PDT)
Date: Wed, 12 Apr 2017 14:30:37 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net-next RFC] Generic XDP
Message-ID: <20170412143037.5fd7a088@xeon-e3>
In-Reply-To: <20170412.145415.1441440342830198148.davem@davemloft.net>
References: <20170412.145415.1441440342830198148.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org

On Wed, 12 Apr 2017 14:54:15 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index b0aa089..071a58b 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1891,9 +1891,17 @@ struct net_device {
>  	struct lock_class_key	*qdisc_tx_busylock;
>  	struct lock_class_key	*qdisc_running_key;
>  	bool			proto_down;
> +	struct bpf_prog __rcu	*xdp_prog;

It would be good if all devices could reuse this for the xdp_prog pointer.
It would allow for could be used for introspection utility functions in future.
