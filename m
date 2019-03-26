Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f182.google.com ([209.85.160.182]:43349 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731701AbfCZUSV (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 26 Mar 2019 16:18:21 -0400
Received: by mail-qt1-f182.google.com with SMTP id v32so16206970qtc.10
        for <xdp-newbies@vger.kernel.org>; Tue, 26 Mar 2019 13:18:20 -0700 (PDT)
MIME-Version: 1.0
From: William Tu <u9012063@gmail.com>
Date: Tue, 26 Mar 2019 13:17:22 -0700
Message-ID: <CALDO+SYM1jcds1_duzRrVWFJd-DHOcC8DCqfgDsey26eXrf8Sw@mail.gmail.com>
Subject: AF_XDP xdpsock rxdrop not seeing packets
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, Magnus Karlsson <magnus.karlsson@gmail.com>

Hi,

I'm testing xdpsock on the latest bpf-next and found that rxdrop does not work.

To reproduce the issue:
-------------------------------
ip netns add at_ns0
ip link add p0 type veth peer name afxdp-p0
ip link set p0 netns at_ns0
ip link set dev afxdp-p0 up
ip netns exec at_ns0 sh << NS_EXEC_HEREDOC
ip addr add "10.1.1.1/24" dev p0
ip link set dev p0 up
NS_EXEC_HEREDOC

ip addr add "10.1.1.2/24" dev afxdp-p0
ip netns exec at_ns0 ping 10.1.1.2
# the afxdp-p0 will receive ping packets

At another console, run SKB mode rxdrop
------------------------------------------------------
root@osboxes:~/bpf-next/samples/bpf# ./xdpsock -r -S -p -i afxdp-p0
 sock0@afxdp-p0:0 rxdrop xdp-skb poll()
                pps         pkts        1.00
rx              0           0
tx              0           0

Where I think xdpsock should receive packet here, but it's not.
it turns out at rx_drop(),
514     ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
515     while (ret != rcvd) {
518         if (ret < 0)
519             exit_with_error(-ret);
520         ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
521     }

It keeps retrying to reserve blocks in FQ but fails. I'm debugging
this but any suggestions
are welcome.

Regards,
William
