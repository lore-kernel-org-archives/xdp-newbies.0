Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37092 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfFAK4U (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sat, 1 Jun 2019 06:56:20 -0400
Subject: Re: [PATCH v2 net-next 4/7] net: ethernet: ti: cpsw_ethtool: simplify
 slave loops
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
 <20190530182039.4945-5-ivan.khoronzhuk@linaro.org>
From: grygorii <grygorii.strashko@ti.com>
Message-ID: <d9e38ccf-004e-b2bd-fed4-af71157d02b4@ti.com>
Date: Sat, 1 Jun 2019 13:55:51 +0300
MIME-Version: 1.0
In-Reply-To: <20190530182039.4945-5-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, hawk@kernel.org, davem@davemloft.net
Cc: ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com



On 30/05/2019 21:20, Ivan Khoronzhuk wrote:
> Only for consistency reasons, do it like in main cpsw.c module
> and use ndev reference but not by means of slave.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>   drivers/net/ethernet/ti/cpsw_ethtool.c | 40 ++++++++++++++------------
>   1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index a4a7ec0d2531..c260bb32aacf 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -458,7 +458,6 @@ int cpsw_nway_reset(struct net_device *ndev)
>   static void cpsw_suspend_data_pass(struct net_device *ndev)
>   {

[...]

>   
>   	return 0;
>   }
> @@ -587,7 +590,6 @@ int cpsw_set_channels_common(struct net_device *ndev,
>   {
>   	struct cpsw_priv *priv = netdev_priv(ndev);
>   	struct cpsw_common *cpsw = priv->cpsw;
> -	struct cpsw_slave *slave;
>   	int i, ret;
>   
>   	ret = cpsw_check_ch_settings(cpsw, chs);
> @@ -604,20 +606,20 @@ int cpsw_set_channels_common(struct net_device *ndev,
>   	if (ret)
>   		goto err;
>   
> -	for (i = cpsw->data.slaves, slave = cpsw->slaves; i; i--, slave++) {
> -		if (!(slave->ndev && netif_running(slave->ndev)))
> +	for (i = 0; i < cpsw->data.slaves; i++) {
> +		struct net_device *ndev = cpsw->slaves[i].ndev;

Sry, but could you rename this local var "ndev" and make it differ from func argument name.

> +
> +		if (!(ndev && netif_running(ndev)))
>   			continue;
>   
>   		/* Inform stack about new count of queues */
> -		ret = netif_set_real_num_tx_queues(slave->ndev,
> -						   cpsw->tx_ch_num);
> +		ret = netif_set_real_num_tx_queues(ndev, cpsw->tx_ch_num);
>   		if (ret) {
>   			dev_err(priv->dev, "cannot set real number of tx queues\n");
>   			goto err;
>   		}
>   
> -		ret = netif_set_real_num_rx_queues(slave->ndev,
> -						   cpsw->rx_ch_num);
> +		ret = netif_set_real_num_rx_queues(ndev, cpsw->rx_ch_num);
>   		if (ret) {
>   			dev_err(priv->dev, "cannot set real number of rx queues\n");
>   			goto err;
> 

-- 
Best regards,
grygorii
