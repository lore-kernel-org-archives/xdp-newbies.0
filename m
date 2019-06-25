Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:50920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUqM (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 16:46:12 -0400
Date: Tue, 25 Jun 2019 13:46:11 -0700 (PDT)
Message-Id: <20190625.134611.1728588998382878928.davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 0/4] net: ethernet: ti: cpsw: Add XDP
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ivan.khoronzhuk@linaro.org
Cc: grygorii.strashko@ti.com, hawk@kernel.org, brouer@redhat.com, saeedm@mellanox.com, leon@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Tue, 25 Jun 2019 20:59:44 +0300

> This patchset adds XDP support for TI cpsw driver and base it on
> page_pool allocator. It was verified on af_xdp socket drop,
> af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.

So happy to watch the progress of this patch set.

Jesper and others, please review.

Thank you.
