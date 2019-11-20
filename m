Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f175.google.com ([209.85.214.175]:37579 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbfKTRw5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 20 Nov 2019 12:52:57 -0500
Received: by mail-pl1-f175.google.com with SMTP id bb5so116842plb.4
        for <xdp-newbies@vger.kernel.org>; Wed, 20 Nov 2019 09:52:56 -0800 (PST)
From: David Ahern <dsahern@gmail.com>
Subject: error loading xdp program on virtio nic
Message-ID: <c484126f-c156-2a17-b47d-06d08121c38b@gmail.com>
Date: Wed, 20 Nov 2019 10:52:53 -0700
MIME-Version: 1.0
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Jason Wang <jasowang@redhat.com>

Hi:

Trying to load an XDP program on a virtio based nic is failing with:

virtio_net: XDP expects header/data in single page, any_header_sg required

I have not encountered this error before and not able to find what is
missing. Any tips?

Thanks,
David
