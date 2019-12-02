Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36052 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfLBPhI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 2 Dec 2019 10:37:08 -0500
MIME-Version: 1.0
References: <CAD56B7dwKDKnrCjpGmrnxz2P0QpNWU3CGBvOtqg3RBx3ejPh9g@mail.gmail.com>
 <20191129164842.qimcmjlz5xq7uupw@linutronix.de>
In-Reply-To: <20191129164842.qimcmjlz5xq7uupw@linutronix.de>
From: Paul Thomas <pthomas8589@gmail.com>
Date: Mon, 2 Dec 2019 10:36:54 -0500
Message-ID: <CAD56B7dtR4GtPUUmmPVcuc0L+7BixW9+S=CR1g4ub3_6ZgRobg@mail.gmail.com>
Subject: Re: xdpsock poll with 5.2.21rt kernel
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, David Miller <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, linux-rt-users <linux-rt-users@vger.kernel.org>

On Fri, Nov 29, 2019 at 11:48 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2019-11-12 17:42:42 [-0500], Paul Thomas wrote:
> > Any thoughts would be appreciated.
>
> Could please enable CONFIG_DEBUG_ATOMIC_SLEEP and check if the kernel
> complains?

Hi Sebastian,

Well, it does complain (report below), but I'm not sure it's related.
The other thing I tried was the AF_XDP example here:
https://github.com/xdp-project/xdp-tutorial/tree/master/advanced03-AF_XDP

With this example poll() always seems to block correctly, so I think
maybe there is something wrong with the xdpsock_user.c example or how
I'm using it.

[  259.591480] BUG: assuming atomic context at net/core/ptp_classifier.c:106
[  259.591488] in_atomic(): 0, irqs_disabled(): 0, pid: 953, name: irq/22-eth%d
[  259.591494] CPU: 0 PID: 953 Comm: irq/22-eth%d Tainted: G        WC
       5.

                        2.21-rt13-00016-g93898e751d0e #90
[  259.591499] Hardware name: Enclustra XU5 SOM (DT)
[  259.591501] Call trace:
[  259.591503] dump_backtrace (/arch/arm64/kernel/traps.c:94)
[  259.591514] show_stack (/arch/arm64/kernel/traps.c:151)
[  259.591520] dump_stack (/lib/dump_stack.c:115)
[  259.591526] __cant_sleep (/kernel/sched/core.c:6386)
[  259.591531] ptp_classify_raw (/./include/linux/compiler.h:194
/./include/asm-generic/atomic-instrumented.h:27
/./include/linux/jump_label.h:251 /net/core/ptp_classifier.c:106)
[  259.591537] skb_defer_rx_timestamp (/./include/linux/skbuff.h:2236
/net/core/timestamping.c:60)
[  259.591541] netif_receive_skb_internal (/net/core/dev.c:5217)
[  259.591547] netif_receive_skb (/net/core/dev.c:5296)
[  259.591550] gem_rx (/drivers/net/ethernet/cadence/macb_main.c:993)
[  259.591556] macb_poll (/drivers/net/ethernet/cadence/macb_main.c:1265)
[  259.591561] net_rx_action (/net/core/dev.c:6387 /net/core/dev.c:6461)
[  259.591565] __do_softirq (/./include/linux/compiler.h:194
/./arch/arm64/include/asm/preempt.h:12 /kernel/softirq.c:400)
[  259.591569] __local_bh_enable_ip (/kernel/softirq.c:182)
[  259.591574] irq_forced_thread_fn (/kernel/irq/manage.c:1008)
[  259.591579] irq_thread (/kernel/irq/manage.c:1101)
[  259.591584] kthread (/kernel/kthread.c:255)
[  259.591589] ret_from_fork (/arch/arm64/kernel/entry.S:1176)
