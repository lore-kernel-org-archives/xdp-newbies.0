Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbfHGMgR (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 7 Aug 2019 08:36:17 -0400
Subject: [bpf-next PATCH 0/3] bpf: improvements to xdp_fwd sample
From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 07 Aug 2019 14:36:12 +0200
Message-ID: <156518133219.5636.728822418668658886.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com, dsahern@gmail.com, Jesper Dangaard Brouer <brouer@redhat.com>

This patchset is focused on improvements for XDP forwarding sample
named xdp_fwd, which leverage the existing FIB routing tables as
described in LPC2018[1] talk by David Ahern.

The primary motivation is to illustrate how Toke's recent work
improves usability of XDP_REDIRECT via lookups in devmap. The other
patches are to help users understand the sample.

I have more improvements to xdp_fwd, but those might requires changes
to libbpf.  Thus, sending these patches first as they are isolated.

[1] http://vger.kernel.org/lpc-networking2018.html#session-1

---

Jesper Dangaard Brouer (3):
      samples/bpf: xdp_fwd rename devmap name to be xdp_tx_ports
      samples/bpf: make xdp_fwd more practically usable via devmap lookup
      samples/bpf: xdp_fwd explain bpf_fib_lookup return codes


 samples/bpf/xdp_fwd_kern.c |   42 +++++++++++++++++++++++++++++++++---------
 samples/bpf/xdp_fwd_user.c |   38 ++++++++++++++++++++++++++------------
 2 files changed, 59 insertions(+), 21 deletions(-)

--
