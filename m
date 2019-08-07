Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f45.google.com ([209.85.221.45]:37106 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbfHGMtf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 7 Aug 2019 08:49:35 -0400
Received: by mail-wr1-f45.google.com with SMTP id b3so150175wro.4
        for <xdp-newbies@vger.kernel.org>; Wed, 07 Aug 2019 05:49:34 -0700 (PDT)
MIME-Version: 1.0
From: Kal Cutter Conley <kal.conley@dectris.com>
Date: Wed, 7 Aug 2019 14:49:22 +0200
Message-ID: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
Subject: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: xdp-newbies@vger.kernel.org

Hello,
I am testing the mlx5e driver with AF_XDP. When I specify
XDP_ZEROCOPY, bind() always returns EINVAL. I observe the same problem
with the xdpsock sample:

sudo samples/bpf/xdpsock -r -i dcb1-port1 -z
samples/bpf/xdpsock_user.c:xsk_configure_socket:322: errno:
22/"Invalid argument"

Without XDP_ZEROCOPY, everything works as expected. Is this a known
issue/limitation? I expected this to be supported looking at the
code/commit history.

Thanks,
Kal
