Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vs1-f41.google.com ([209.85.217.41]:46243 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgAaVdk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 Jan 2020 16:33:40 -0500
Received: by mail-vs1-f41.google.com with SMTP id t12so5281866vso.13
        for <xdp-newbies@vger.kernel.org>; Fri, 31 Jan 2020 13:33:40 -0800 (PST)
MIME-Version: 1.0
From: Elerion <elerion1000@gmail.com>
Date: Fri, 31 Jan 2020 13:33:28 -0800
Message-ID: <CAMDScm=w_B-tqTaoUCQiYiUEye4WO_sVfAA741XRLzAQEdwxKg@mail.gmail.com>
Subject: Packets randomly dropped with virtio-net with xdp loaded in native mode
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: xdp-newbies@vger.kernel.org

Not sure if this is a known issue or if I'm doing something wrong, but
when I tried to load an xdp program in native mode, my server starts
randomly dropping packets while there are no issues with generic mode.

bpf_set_link_xdp_fd(ifindex, fd, XDP_FLAGS_DRV_MODE); // drops packets
bpf_set_link_xdp_fd(ifindex, fd, XDP_FLAGS_SKB_MODE); // doesn't drop packets

Guest
5.0.0-16-generic #17~18.04.1-Ubuntu SMP Mon May 20 14:00:27 UTC 2019
x86_64 x86_64 x86_64 GNU/Linux

00:03.0 Ethernet controller: Red Hat, Inc. Virtio network device
        Subsystem: Red Hat, Inc. Virtio network device
        Physical Slot: 3
        Flags: bus master, fast devsel, latency 0, IRQ 10
        I/O ports at c000 [size=64]
        Memory at febf1000 (32-bit, non-prefetchable) [size=4K]
        Memory at fe000000 (64-bit, prefetchable) [size=16K]
        Capabilities: [98] MSI-X: Enable+ Count=18 Masked-
        Capabilities: [84] Vendor Specific Information: VirtIO: <unknown>
        Capabilities: [70] Vendor Specific Information: VirtIO: Notify
        Capabilities: [60] Vendor Specific Information: VirtIO: DeviceCfg
        Capabilities: [50] Vendor Specific Information: VirtIO: ISR
        Capabilities: [40] Vendor Specific Information: VirtIO: CommonCfg
        Kernel driver in use: virtio-pci

Host
Unknown. It is a server from vultr.com
