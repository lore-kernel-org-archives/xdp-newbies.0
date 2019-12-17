Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pj1-f43.google.com ([209.85.216.43]:37616 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfLQBzn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 16 Dec 2019 20:55:43 -0500
Received: by mail-pj1-f43.google.com with SMTP id ep17so3827581pjb.4
        for <xdp-newbies@vger.kernel.org>; Mon, 16 Dec 2019 17:55:43 -0800 (PST)
Date: Mon, 16 Dec 2019 17:55:38 -0800
From: William Tu <u9012063@gmail.com>
Subject: XDP/AF_XDP checksum use case in OVS
Message-ID: <20191217015538.GB43662@gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
To: dev@openvswitch.org, xdp-newbies@vger.kernel.org, tom@herbertland.com

Hi,

We are measuring the performance of OVS using AF_XDP, and
have the following use case for XDP checksum:

High level Topology, two physical machines (PM1,2):
=A0 VM1 -> OVS encap with Geneve (PM1) -> physical NIC
=A0 -> network ->
=A0 physical NIC -> OVS decap (PM2) -> VM2

When running an iperf TCP client/tx in a VM1, a tcp packet goes
through:
VM1
=A0 1) VM's virtio net device
=A0 2) by default, tx offload is on
PM1 Hypervisor
=A0 3) OVS receives the tcp packet (no checksum)
=A0 4) OVS encap outer Geneve header (no inner, no outer checksum)
=A0 5) AF_XDP sends this frame to network (no inner, no outer checksum)
PM2 Hypervisor
=A0 6) OVS receives using af_xdp port
=A0 7) OVS removes Geneve UDP header, send to VM port
VM2
=A0 8) VM2 kernel drops the TCP packet

A software work around is at 2) disable tx offload by using
ethtool -K tx off. This cause VM1 vcpu calculates inner tcp
csum but drops performance.

If XDP hints can somehow support TX checksum offload at 5),
this overhead can be avoided.

Thanks!
William
