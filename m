Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46990 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732739AbfETPxn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 20 May 2019 11:53:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so6898911pls.13
        for <xdp-newbies@vger.kernel.org>; Mon, 20 May 2019 08:53:43 -0700 (PDT)
Date: Mon, 20 May 2019 08:53:40 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
Message-ID: <20190520085340.4f44ac8b@hermes.lan>
In-Reply-To: <20190520091105.GA2142@nanopsycho>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
        <20190519031046.4049-3-sthemmin@microsoft.com>
        <20190520091105.GA2142@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, davem@davemloft.net, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>, Jason Wang <jasowang@redhat.com>

On Mon, 20 May 2019 11:11:05 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Sun, May 19, 2019 at 05:10:46AM CEST, stephen@networkplumber.org wrote:
> >When a device is stacked like (team, bonding, failsafe or netvsc) the
> >XDP generic program for the parent device is not called.  In these
> >cases, the rx handler changes skb->dev to its own in the receive
> >handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
> >do_xdp_generic if necessary before starting another round.
> >
> >Review of all the places RX_HANDLER_ANOTHER is returned
> >show that the current devices do correctly change skb->dev.
> >
> >There was an older patch that got abandoned that did the
> >same thing, this is just a rewrite.
> >
> >Suggested-by: Jason Wang <jasowang@redhat.com>
> >Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
> >Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> >Acked-by: Jason Wang <jasowang@redhat.com>
> >---

> I'm always scarred of changes like this. The history tells us that this
> codepaths are very fragile. It took us non-trivial efford to fix bonding
> here, not to mention vlans (that was pain).
> 
> The reason for troubles was often fact that different flows were treated
> differently (vlan accel/non-accel).

Yes, this is a sensitive path. Another alternative is to fix it
inside each device (netvsc). That is what my earlier patch did and that
is what is being done now (probably will make it into the RHEL on Azure
drivers).
 
> This patch calls do_xdp_generic for master device in different point in
> the receive patch comparing to lower device. Would it be possible to
> unify this? E.g. by moving do_xdp_generice() call from
> netif_rx_internal()/netif_receive_skb_internal() here,
> to the beginning of __netif_receive_skb_core()?
> 

That could work, but has the question about doing XDP farther down
call stack (lower performance).

There is also the case what if both paths support XDP in driver.
This would be the ideal case, how would this work?
