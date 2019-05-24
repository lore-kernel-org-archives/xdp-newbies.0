Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38878 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390074AbfEXJlu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 24 May 2019 05:41:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so9285747wrs.5
        for <xdp-newbies@vger.kernel.org>; Fri, 24 May 2019 02:41:49 -0700 (PDT)
Date: Fri, 24 May 2019 12:41:45 +0300
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next 0/3] net: ethernet: ti: cpsw: Add XDP support
Message-ID: <20190524094145.GA24675@apalos>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

Hi Ivan,

More XDP drivers, that's good!
> This patchset add XDP support for TI cpsw driver and base it on
> page_pool allocator. It was verified on af_xdp socket drop,
> af_xdp l2f, ebpf XDP_DROP, XDP_REDIRECT, XDP_PASS, XDP_TX.
> 
> It was verified with following configs enabled:
> CONFIG_JIT=y
> CONFIG_BPFILTER=y
> CONFIG_BPF_SYSCALL=y
> CONFIG_XDP_SOCKETS=y
> CONFIG_BPF_EVENTS=y
> CONFIG_HAVE_EBPF_JIT=y
> CONFIG_BPF_JIT=y
> CONFIG_CGROUP_BPF=y
> 
> Link on previous RFC:
> https://lkml.org/lkml/2019/4/17/861
> 
The recycling pattern has changed i'll have a closer look in the weekend and let
you know
> Also regular tests with iperf2 were done in order to verify impact on
> regular netstack performance, compared with base commit:
> https://pastebin.com/JSMT0iZ4
Do you have any XDP related numbers?
> 
> Based on net-next/master
> 
> Ivan Khoronzhuk (3):
>   net: ethernet: ti: davinci_cpdma: add dma mapped submit
>   net: ethernet: ti: davinci_cpdma: return handler status
>   net: ethernet: ti: cpsw: add XDP support
> 
>  drivers/net/ethernet/ti/Kconfig         |   1 +
>  drivers/net/ethernet/ti/cpsw.c          | 570 +++++++++++++++++++++---
>  drivers/net/ethernet/ti/cpsw_ethtool.c  |  55 ++-
>  drivers/net/ethernet/ti/cpsw_priv.h     |   9 +-
>  drivers/net/ethernet/ti/davinci_cpdma.c | 122 +++--
>  drivers/net/ethernet/ti/davinci_cpdma.h |   6 +-
>  drivers/net/ethernet/ti/davinci_emac.c  |  18 +-
>  7 files changed, 675 insertions(+), 106 deletions(-)
> 
> -- 
> 2.17.1
> 
Thanks
/Ilias
