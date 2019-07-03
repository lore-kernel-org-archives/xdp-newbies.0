Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:60558 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCSaG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 3 Jul 2019 14:30:06 -0400
Date: Wed, 03 Jul 2019 11:30:05 -0700 (PDT)
Message-Id: <20190703.113005.69711790321030429.davem@davemloft.net>
Subject: Re: [PATCH net-next] net: socionext: remove set but not used
 variable 'pkts'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20190703024213.191191-1-yuehaibing@huawei.com>
References: <20190703024213.191191-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: yuehaibing@huawei.com
Cc: jaswinder.singh@linaro.org, ast@kernel.org, ilias.apalodimas@linaro.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, hawk@kernel.org, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, kernel-janitors@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 3 Jul 2019 02:42:13 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/socionext/netsec.c: In function 'netsec_clean_tx_dring':
> drivers/net/ethernet/socionext/netsec.c:637:15: warning:
>  variable 'pkts' set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit ba2b232108d3 ("net: netsec: add XDP support")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 5544a722543f..015d1ec5436a 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -634,7 +634,7 @@ static void netsec_set_rx_de(struct netsec_priv *priv,
>  static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  {
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
> -	unsigned int pkts, bytes;
> +	unsigned int bytes;
>  	struct netsec_de *entry;
>  	int tail = dring->tail;
>  	int cnt = 0;

This breaks the reverse christmas-tree ordering of the local variables in this
function.  Please move the 'bytes' declaration down by two lines when you make
this change.

Thanks.
