Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:43911
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732518AbfGHPQa (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:30 -0400
From: Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Date: Mon, 8 Jul 2019 15:16:26 +0000
Message-ID: <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
References: <20190708125554.3863901-1-arnd@arndb.de>
In-Reply-To: <20190708125554.3863901-1-arnd@arndb.de>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDBEA50B673B32448D8087847B960C7E@eurprd05.prod.outlook.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Arnd Bergmann <arnd@arndb.de>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Tariq Toukan <tariqt@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>

On 2019-07-08 15:55, Arnd Bergmann wrote:
> The structure is too large to put on the stack, resulting in a
> warning on 32-bit ARM:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:59:5: error: stack frame size of 1344 bytes in function
>        'mlx5e_open_xsk' [-Werror,-Wframe-larger-than=]
> 
> Use kzalloc() instead.
> 
> Fixes: a038e9794541 ("net/mlx5e: Add XSK zero-copy support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   .../mellanox/mlx5/core/en/xsk/setup.c         | 25 ++++++++++++-------
>   1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> index aaffa6f68dc0..db9bbec68dbf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
> @@ -60,24 +60,28 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
>   		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
>   		   struct mlx5e_channel *c)
>   {
> -	struct mlx5e_channel_param cparam = {};
> +	struct mlx5e_channel_param *cparam;
>   	struct dim_cq_moder icocq_moder = {};
>   	int err;
>   
>   	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
>   		return -EINVAL;
>   
> -	mlx5e_build_xsk_cparam(priv, params, xsk, &cparam);
> +	cparam = kzalloc(sizeof(*cparam), GFP_KERNEL);

Similar code in mlx5e_open_channels (en_main.c) uses kvzalloc. Although 
the struct is currently smaller than a page anyway, and there should be 
no difference in behavior now, I suggest using the same alloc function 
to keep code uniform.

> +	if (!cparam)
> +		return -ENOMEM;
>   
> -	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam.rx_cq, &c->xskrq.cq);
> +	mlx5e_build_xsk_cparam(priv, params, xsk, cparam);
> +
> +	err = mlx5e_open_cq(c, params->rx_cq_moderation, &cparam->rx_cq, &c->xskrq.cq);
>   	if (unlikely(err))
> -		return err;
> +		goto err_kfree_cparam;
>   
> -	err = mlx5e_open_rq(c, params, &cparam.rq, xsk, umem, &c->xskrq);
> +	err = mlx5e_open_rq(c, params, &cparam->rq, xsk, umem, &c->xskrq);
>   	if (unlikely(err))
>   		goto err_close_rx_cq;
>   
> -	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam.tx_cq, &c->xsksq.cq);
> +	err = mlx5e_open_cq(c, params->tx_cq_moderation, &cparam->tx_cq, &c->xsksq.cq);
>   	if (unlikely(err))
>   		goto err_close_rq;
>   
> @@ -87,18 +91,18 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
>   	 * is disabled and then reenabled, but the SQ continues receiving CQEs
>   	 * from the old UMEM.
>   	 */
> -	err = mlx5e_open_xdpsq(c, params, &cparam.xdp_sq, umem, &c->xsksq, true);
> +	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, umem, &c->xsksq, true);
>   	if (unlikely(err))
>   		goto err_close_tx_cq;
>   
> -	err = mlx5e_open_cq(c, icocq_moder, &cparam.icosq_cq, &c->xskicosq.cq);
> +	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->xskicosq.cq);
>   	if (unlikely(err))
>   		goto err_close_sq;
>   
>   	/* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
>   	 * triggered and NAPI to be called on the correct CPU.
>   	 */
> -	err = mlx5e_open_icosq(c, params, &cparam.icosq, &c->xskicosq);
> +	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
>   	if (unlikely(err))
>   		goto err_close_icocq;
>   

Here is kfree missing. It's a memory leak in the good path.

Thanks!

> @@ -123,6 +127,9 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
>   err_close_rx_cq:
>   	mlx5e_close_cq(&c->xskrq.cq);
>   
> +err_kfree_cparam:
> +	kfree(cparam);
> +
>   	return err;
>   }
>   
> 
