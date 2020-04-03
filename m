Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47061 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389857AbgDCBFu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 2 Apr 2020 21:05:50 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id A17765C0318
        for <xdp-newbies@vger.kernel.org>; Thu,  2 Apr 2020 21:05:49 -0400 (EDT)
Mime-Version: 1.0
Message-Id: <7c11add0-e837-4ce4-9158-249c800d0d2d@www.fastmail.com>
Date: Fri, 03 Apr 2020 03:05:15 +0200
From: "Gilberto Bertin" <me@jibi.io>
Subject: Running XSK on a tun device
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain
To: xdp-newbies@vger.kernel.org

I am trying to bind an XSK socket to a tun device, so that I can run some
automated tests on an XSK based server I'm working on. A tun device would in
fact allow me to have fine control over what packets I'm sending to and
receiving from the server (as opposed for example to an approach where the
server listens on a regular interface and tests interact with it over sockets).

The XSK logic of the server is largely based on the one presented in the
xdpsock_user sample in samples/bpf in the Linux kernel (the server is using the
XDP_USE_NEED_WAKEUP bind flag).

When I manually interact with it using a pair of veth devices and netcat,
everything works as expected: the server receives and then sends back packets
properly.

The troubles start when I try to bind it to a tun device as I am not able to move
any packet between the device and the server.

I tried then to reproduce the issue with a simplified setup based on the
xdpsock_user sample, and I got the same results (I tested different combination
of options such as driver mode vs skb mode, poll vs non poll mode, need-wakeup
vs no-need-wakeup, all with the same outcome).

By inspecting more closely the behavior of the sample program I found that:

- packets are actually being received in the rx ring, as poll returns 1 each time
  something is written on the fd of the tun device
- the program gets stuck in rx_drop() [1], more precisely in:

	ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
	while (ret != rcvd) {
		if (ret < 0)
			exit_with_error(-ret);
		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
			ret = poll(fds, num_socks, opt_timeout);
		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
	}

  where xsk_ring_prod__reserve keeps returning 0.

I'm not sure why this is happening as most of the descriptors in the fill ring
should be available (especially since this exact same code works fine for other
devices like veth).

As I'm still getting acquainted with the codebase it's not obvious to me where I
should start looking for to understand what's the underling cause of this issue
so I'd really appreciate some help/pointers on this.

Cheers,
Gilberto

[1] https://github.com/torvalds/linux/blob/8ed47e140867a6e7d56170f325c8d4fdee6d6b66/samples/bpf/xdpsock_user.c#L873-L880
