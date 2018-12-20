Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbeLTMoq (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 20 Dec 2018 07:44:46 -0500
Date: Thu, 20 Dec 2018 13:44:39 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Debugging cpumap_kthread drops
Message-ID: <20181220134439.23c45643@redhat.com>
In-Reply-To: <CAHOxX0w+K0u2vQbrAJ0kHG+XQjAqCSZY6SRTZCwWVXyzWQ_D0A@mail.gmail.com>
References: <CAHOxX0w+K0u2vQbrAJ0kHG+XQjAqCSZY6SRTZCwWVXyzWQ_D0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Pavel Popa <pashinho1990@gmail.com>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com

On Wed, 19 Dec 2018 17:51:21 +0100
Pavel Popa <pashinho1990@gmail.com> wrote:

> Hi all,
> 
> I'm encountering the following log line "xdp_cpumap_kthread: kthread
> cpu=0 map_id=155 action=REDIRECT processed=1 drops=1 sched=1", and as
> you can see the "drops" counter is =1, thus not good. Is there any way
> to know the reason of such error? This is triggered when the IP dst
> address of a to be forwarded packet doesn't have a corresponding ARP
> entry, so what the XDP program does is basically redirecting the
> packet to a different CPU core for the net stack processing which will
> perform ARP, at least that's the intent. I should say that it
> perfectly worked some days ago, but now I'm encountering this. So, is
> there any possible way to debug deeper in a "xdp_cpumap_kthread
> drops"?

This trace point is located in function cpu_map_kthread_run() in file
kernel/bpf/cpumap.c.

The relevant code section:
	/* Inject into network stack */
	ret = netif_receive_skb_core(skb);
	if (ret == NET_RX_DROP)
		drops++;

The "drops" count is incremented when we inject the packet into the
network stack and it returns NET_RX_DROP.  Thus, it is the network
stack that choose to drop your packet. As such it is likely a netstack
issue, not an XDP issue.

To debug this further you can use other netstack tracepoint to debug
this further.  It might even be possible to tcpdump the packet before
it gets dropped by netstack.  

It can be hard to follow the code path of the kernel, to figure out
exactly what code path is dropping the packet.  But given you seem to
know howto use tracepoints, there is a shortcut to this information by
using the tracepoint "skb:kfree_skb" and look at the function
call-graph (we have "skb:consume_skb" for normal free path).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
