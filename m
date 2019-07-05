Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:43524 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfGEW2K (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jul 2019 18:28:10 -0400
Date: Fri, 05 Jul 2019 15:28:08 -0700 (PDT)
Message-Id: <20190705.152808.1175306947779966525.davem@davemloft.net>
Subject: Re: [PATCH v3 net-next] net: socionext: remove set but not used
 variable 'pkts'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190704033745.1758-1-yuehaibing@huawei.com>
References: <20190704032129.169282-1-yuehaibing@huawei.com>
        <20190704033745.1758-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: yuehaibing@huawei.com
Cc: jaswinder.singh@linaro.org, ast@kernel.org, ilias.apalodimas@linaro.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, hawk@kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, kernel-janitors@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 4 Jul 2019 03:37:45 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/socionext/netsec.c: In function 'netsec_clean_tx_dring':
> drivers/net/ethernet/socionext/netsec.c:637:15: warning:
>  variable 'pkts' set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit ba2b232108d3 ("net: netsec: add XDP support")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied to net-next.
