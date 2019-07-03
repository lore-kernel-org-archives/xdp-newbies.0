Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53135 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfGCFNB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 3 Jul 2019 01:13:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so746931wms.2
        for <xdp-newbies@vger.kernel.org>; Tue, 02 Jul 2019 22:12:59 -0700 (PDT)
Date: Wed, 3 Jul 2019 08:12:54 +0300
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next] net: socionext: remove set but not used
 variable 'pkts'
Message-ID: <20190703051254.GA25517@apalos>
References: <20190703024213.191191-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703024213.191191-1-yuehaibing@huawei.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: YueHaibing <yuehaibing@huawei.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Alexei Starovoitov <ast@kernel.org>, "David S . Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Jul 03, 2019 at 02:42:13AM +0000, YueHaibing wrote:
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
> @@ -642,7 +642,6 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  	if (dring->is_xdp)
>  		spin_lock(&dring->lock);
>  
> -	pkts = 0;
>  	bytes = 0;
>  	entry = dring->vaddr + DESC_SZ * tail;
> 
> 
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
