Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-il1-f174.google.com ([209.85.166.174]:45256 "EHLO
        mail-il1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKHDgd (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Nov 2019 22:36:33 -0500
Received: by mail-il1-f174.google.com with SMTP id o18so3854565ils.12
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Nov 2019 19:36:32 -0800 (PST)
Subject: Re: xdp with mlx5 not working as expected
References: <a47dae54-87c8-c563-0c3c-524f4c95518e@gmail.com>
 <VI1PR05MB5102CF9D51954A7674C1F92DBE7B0@VI1PR05MB5102.eurprd05.prod.outlook.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <62ce7c93-88de-f458-60ab-1f149e3bd1ac@gmail.com>
Date: Thu, 7 Nov 2019 20:36:30 -0700
MIME-Version: 1.0
In-Reply-To: <VI1PR05MB5102CF9D51954A7674C1F92DBE7B0@VI1PR05MB5102.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Saeed Mahameed <saeedm@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


I think it is a vlan problem. Host traffic is untagged; VM traffic is
tagged.

Never mind; I think I see the problem.
