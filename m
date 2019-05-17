Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfEQBJa (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 16 May 2019 21:09:30 -0400
Subject: Re: [PATCH net 2/3] net: core: generic XDP support for stacked device
References: <20190516215423.14185-1-sthemmin@microsoft.com>
 <20190516215423.14185-3-sthemmin@microsoft.com>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <cb8e4c5a-0455-abf8-3211-72e5226df3a4@redhat.com>
Date: Fri, 17 May 2019 09:09:27 +0800
MIME-Version: 1.0
In-Reply-To: <20190516215423.14185-3-sthemmin@microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org, davem@davemloft.net
Cc: xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>


On 2019/5/17 上午5:54, Stephen Hemminger wrote:
> When a device is stacked like (team, bonding, failsafe or netvsc) the
> XDP generic program for the parent device is not called.  In these
> cases, the rx handler changes skb->dev to its own in the receive
> handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
> do_xdp_generic if necessary before starting another round.
>
> Review of all the places RX_HANDLER_ANOTHER is returned
> show that the current devices do correctly change skb->dev.
>
> There was an older patch that got abandoned that did the
> same thing, this is just a rewrite.
>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> ---
>   net/core/dev.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 108ac8137b9b..9165fd3c9e90 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4921,6 +4921,16 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>   			ret = NET_RX_SUCCESS;
>   			goto out;
>   		case RX_HANDLER_ANOTHER:
> +			if (static_branch_unlikely(&generic_xdp_needed_key)) {
> +				struct bpf_prog *xdp_prog;
> +
> +				xdp_prog = rcu_dereference(skb->dev->xdp_prog);
> +				ret = do_xdp_generic(xdp_prog, skb);
> +				if (ret != XDP_PASS) {
> +					ret = NET_RX_SUCCESS;
> +					goto out;
> +				}
> +			}
>   			goto another_round;
>   		case RX_HANDLER_EXACT:
>   			deliver_exact = true;


Acked-by: Jason Wang <jasowang@redhat.com>
