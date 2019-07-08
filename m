Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:59346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732549AbfGHWML (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 18:12:11 -0400
Date: Mon, 08 Jul 2019 15:12:05 -0700 (PDT)
Message-Id: <20190708.151205.542308481913266663.davem@davemloft.net>
Subject: Re: [PATCH v9 net-next 0/5] net: ethernet: ti: cpsw: Add XDP
 support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190708213432.8525-1-ivan.khoronzhuk@linaro.org>
References: <20190708213432.8525-1-ivan.khoronzhuk@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: ivan.khoronzhuk@linaro.org
Cc: grygorii.strashko@ti.com, hawk@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Date: Tue,  9 Jul 2019 00:34:27 +0300

> This patchset adds XDP support for TI cpsw driver and base it on
> page_pool allocator. It was verified on af_xdp socket drop,
> af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.
 ...

Series applied, thanks Ivan!
