Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36031 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfEUGI4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 21 May 2019 02:08:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id j187so1498690wmj.1
        for <xdp-newbies@vger.kernel.org>; Mon, 20 May 2019 23:08:55 -0700 (PDT)
Date: Tue, 21 May 2019 08:08:53 +0200
From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
Message-ID: <20190521060853.GA2210@nanopsycho.orion>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
 <20190519031046.4049-3-sthemmin@microsoft.com>
 <20190520091105.GA2142@nanopsycho>
 <cdfec194-30f3-f040-3bb2-98bb08add759@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cdfec194-30f3-f040-3bb2-98bb08add759@redhat.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org, davem@davemloft.net, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>

Tue, May 21, 2019 at 06:47:23AM CEST, jasowang@redhat.com wrote:
>
>On 2019/5/20 下午5:11, Jiri Pirko wrote:
>> Sun, May 19, 2019 at 05:10:46AM CEST, stephen@networkplumber.org wrote:
>> > When a device is stacked like (team, bonding, failsafe or netvsc) the
>> > XDP generic program for the parent device is not called.  In these
>> > cases, the rx handler changes skb->dev to its own in the receive
>> > handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
>> > do_xdp_generic if necessary before starting another round.
>> > 
>> > Review of all the places RX_HANDLER_ANOTHER is returned
>> > show that the current devices do correctly change skb->dev.
>> > 
>> > There was an older patch that got abandoned that did the
>> > same thing, this is just a rewrite.
>> > 
>> > Suggested-by: Jason Wang <jasowang@redhat.com>
>> > Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
>> > Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>> > Acked-by: Jason Wang <jasowang@redhat.com>
>> > ---
>> > net/core/dev.c | 10 ++++++++++
>> > 1 file changed, 10 insertions(+)
>> > 
>> > diff --git a/net/core/dev.c b/net/core/dev.c
>> > index b6b8505cfb3e..240d0b2de1a8 100644
>> > --- a/net/core/dev.c
>> > +++ b/net/core/dev.c
>> > @@ -4921,6 +4921,16 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>> > 			ret = NET_RX_SUCCESS;
>> > 			goto out;
>> > 		case RX_HANDLER_ANOTHER:
>> > +			if (static_branch_unlikely(&generic_xdp_needed_key)) {
>> > +				struct bpf_prog *xdp_prog;
>> > +
>> > +				xdp_prog = rcu_dereference(skb->dev->xdp_prog);
>> > +				ret = do_xdp_generic(xdp_prog, skb);
>> > +				if (ret != XDP_PASS) {
>> > +					ret = NET_RX_SUCCESS;
>> > +					goto out;
>> > +				}
>> > +			}
>> I'm always scarred of changes like this. The history tells us that this
>> codepaths are very fragile. It took us non-trivial efford to fix bonding
>> here, not to mention vlans (that was pain).
>
>
>I may miss something, did you see any issue for bonding with this patch?

No, I was talking about past.


>
>
>> 
>> The reason for troubles was often fact that different flows were treated
>> differently (vlan accel/non-accel).
>
>
>Do you mean we need do something similar after vlan_do_receive() returns
>true?

No.


>
>
>> This patch calls do_xdp_generic for master device in different point in
>> the receive patch comparing to lower device. Would it be possible to
>> unify this? E.g. by moving do_xdp_generice() call from
>> netif_rx_internal()/netif_receive_skb_internal() here,
>> to the beginning of __netif_receive_skb_core()?
>
>
>Probably just after another_round label. And this means generic XDP is done
>after RPS which could be even better.

Yes. That is exactly the place I have in mind.


>
>Thanks
>
>
>> 
>> 
>> 
>> > 			goto another_round;
>> > 		case RX_HANDLER_EXACT:
>> > 			deliver_exact = true;
>> > -- 
>> > 2.20.1
>> > 
