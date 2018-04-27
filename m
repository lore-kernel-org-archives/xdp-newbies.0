Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:37205 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758379AbeD0Nbk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 27 Apr 2018 09:31:40 -0400
Received: by mail-oi0-f49.google.com with SMTP id f63-v6so1576637oic.4
        for <xdp-newbies@vger.kernel.org>; Fri, 27 Apr 2018 06:31:39 -0700 (PDT)
MIME-Version: 1.0
From: Bobby Powers <bobbypowers@gmail.com>
Date: Fri, 27 Apr 2018 09:31:38 -0400
Message-ID: <CAArOQ2UJDD-kA3O9h-MZTedhyRfXg4UC=QM-Hdw9tzPoe__ZvQ@mail.gmail.com>
Subject: egress packet filtering
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hi folks!

I've been reading about eBPF and XDP, and I _think_ that XDP can only
filter incoming (ingress) packets on a machine, not outgoing packets.
Is that right?  In particular I've been looking at:

https://jvns.ca/blog/2017/04/07/xdp-bpf-tutorial/
https://www.netdevconf.org/2.1/slides/apr7/gospodarek-Netdev2.1-XDP-for-the-Rest-of-Us_Final.pdf
https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf

And What I Really Want To Do is create an eBPF filter that will
selectively drop outgoing packets on a particular TCP stream.  The
idea is to simulate underlying network/firewall misconfigurations so I
can observe the effect on higher-level software (like an HTTP client,
a load balancer, and an HTTP server).  I think I can accomplish this
with `tc` and the `cls_bpf` and `act_bpf` modules, as documented here:

http://man7.org/linux/man-pages/man8/tc-bpf.8.html

Does that sound about right?  Am I right in understanding that the
main difference between using a BPF classifier/action and XDP filter
is that performance of XDP filters is higher (because there is some
amount of integration with the NIC/driver), and they only process
ingress traffic?

Thanks for the help!

yours,
Bobby
