Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f54.google.com ([209.85.167.54]:44166 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLWm4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 12 Nov 2019 17:42:56 -0500
MIME-Version: 1.0
From: Paul Thomas <pthomas8589@gmail.com>
Date: Tue, 12 Nov 2019 17:42:42 -0500
Message-ID: <CAD56B7dwKDKnrCjpGmrnxz2P0QpNWU3CGBvOtqg3RBx3ejPh9g@mail.gmail.com>
Subject: xdpsock poll with 5.2.21rt kernel
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, David Miller <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, linux-rt-users <linux-rt-users@vger.kernel.org>

Hello,

I'm doing some testing with AF_XDP, and I'm seeing some behavior I
don't quite understand. It seems I can get into a situation where
xdpsock (from samples/bpf/scpsocke_user.c) is using most of the cpu
even though I'm trying to use poll().

To start with I run xdpsock with --rxdrop and --poll. At first this
behaves nicely, the cpu usage is very low:
# ps -AL -o pid,lwp,cmd,comm,rtprio,cpuid,pcpu | grep [x]dpsock
 1932  1932 ./xdpsock -r -p -i eth1     xdpsock              -     3  0.0
 1932  1933 ./xdpsock -r -p -i eth1     xdpsock              -     2  0.0

And strace shows nice orderly ppoll timeouts every second.
# strace -p 1932
strace: Process 1932 attached
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=0, tv_nsec=510616211}, NULL,
0) = 0 (Timeout)
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 0 (Timeout)
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 0 (Timeout)
...

Then I generate some traffic and ppoll() is not timing out anymore:
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 1
([{fd=3, revents=POLLIN}], left {tv_sec=0, tv_nsec=999996790})
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 1
([{fd=3, revents=POLLIN}], left {tv_sec=0, tv_nsec=999997260})
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 1
([{fd=3, revents=POLLIN}], left {tv_sec=0, tv_nsec=999997100})

This is where it get's strange, if I stop the traffic, then strace no
longer generates any activity but the xdpsock cpu usage is way up:
# ps -AL -o pid,lwp,cmd,comm,rtprio,cpuid,pcpu | grep [x]dpsock
 1932  1932 ./xdpsock -r -p -i eth1     xdpsock              -     3 61.0
 1932  1933 ./xdpsock -r -p -i eth1     xdpsock              -     2  0.0

So is it getting stuck at while (ret != rcvd) in rx_drop()?

Is it a normal case to get past the poll() and then have
xsk_ring_cons__peek() not equal xsk_ring_prod__reserve()?

I see the added xsk_ring_prod__needs_wakeup() with the extra poll() in
the latest 5.4 kernels, but I don't think any of the needs_wakeup
stuff is in the 5.2 kernel. Is that needed for this case?

This is with a 5.2.21 preempt-rt kernel on arm64 using the macb driver
(so XDP_SKB and not XDP_DRV).

Any thoughts would be appreciated.

thanks,
Paul
