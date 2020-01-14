Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f176.google.com ([209.85.222.176]:42813 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbgANUwj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Jan 2020 15:52:39 -0500
Received: by mail-qk1-f176.google.com with SMTP id z14so13536142qkg.9
        for <xdp-newbies@vger.kernel.org>; Tue, 14 Jan 2020 12:52:38 -0800 (PST)
Received: from neptune.home ([206.174.180.53])
        by smtp.gmail.com with ESMTPSA id t38sm8314020qta.78.2020.01.14.12.52.36
        for <xdp-newbies@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 12:52:36 -0800 (PST)
Message-ID: <242dfd7986c0d382f80462f5ce0cbe8a69fac2cd.camel@coverfire.com>
Subject: AF_XDP with Rust
From: dan@coverfire.com
Date: Tue, 14 Jan 2020 15:52:35 -0500
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

https://github.com/aterlo/afxdp-rs

afxdp-rs provides a Rust interface to AF_XDP. The docs.rs build is
broken right now but at high level this provides:
- Mem mapped area
- Umem (completion queue and fill queue)
- AF_XDP sockets (Tx/Rx, Tx-only, Rx-only)
- Buf (to represent a packet). Templated to allow user customization.
- BufPool to manage Bufs (this doesn't do much in the sample programs
but is useful in more complicated scenarios)
- 1 link and 2 link forwarding examples

Performance

Test System:

* Intel(R) Xeon(R) CPU E5-2680 v4 @ 2.40GHz
* Single X710 (4 physical 10G ports) (i40e)
* Kernel: 5.4.2-300.fc31.x86_64
* Kernel boot args: skew_tick=1 mitigations=off selinux=0 isolcpus=4-27 
nohz_full=4-27 rcu_nobcs=4-27 default_hugepagesz=1G hugepagesz=1G
hugepages=4

Traffic Generator:

* Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
* Single X710 (4 physical 10G ports) (i40e)
* Traffic goes from one port, through test system and to second port on
the same X710
* T-Rex traffic generator (https://trex-tgn.cisco.com/) (DPDK)
* 64-byte UDP packets

Scenario 1: l2fwd-2link on a single core running userspace and NAPI

Small amounts of packet loss start at about 6.5M packets-per-second
(PPS) unidirectional and 6.0M PPS bi-directional (3M each direction).

Little effort has been put into optimizing this so I expect there are
some easy performance wins still.
