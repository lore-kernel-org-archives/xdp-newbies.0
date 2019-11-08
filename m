Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-il1-f172.google.com ([209.85.166.172]:42926 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHBaj (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Nov 2019 20:30:39 -0500
Received: by mail-il1-f172.google.com with SMTP id n18so3644459ilt.9
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Nov 2019 17:30:39 -0800 (PST)
From: David Ahern <dsahern@gmail.com>
Subject: xdp with mlx5 not working as expected
Message-ID: <a47dae54-87c8-c563-0c3c-524f4c95518e@gmail.com>
Date: Thu, 7 Nov 2019 18:30:36 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Saeed Mahameed <saeedm@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi:

I am trying to get an XDP program working with an mlx5 based nic and not
having much success. The same program works fine with sfc and i40e, but
with mlx5 it seems to be limited. I added a trace_printk and basically
it seems to only run cpu 1 and rx queue 0. Fiddling with the number of
channels (ethtool -L) I was, for a brief moment, seeing the program
running on different cpu with a different rx-queue id. I am clearly
missing some setting that is needed for mlx5, but I have not been able
to find any wiki, conference paper or git commit message with helpful
hints. Do you have any references you can forward?

Server has 48 cores, 96 threads and RPS is configureed. The card is:
d8:00.0 Ethernet controller: Mellanox Technologies MT27710 Family
[ConnectX-4 Lx]

Thanks,
David
