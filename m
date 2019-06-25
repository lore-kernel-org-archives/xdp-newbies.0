Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37779 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWWS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 18:22:18 -0400
MIME-Version: 1.0
References: <20190625114246.14726-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625114246.14726-1-ivan.khoronzhuk@linaro.org>
From: Song Liu <liu.song.a23@gmail.com>
Date: Tue, 25 Jun 2019 15:22:06 -0700
Message-ID: <CAPhsuW4oB55TNJx9stfOq68d1O8quxuhonLv0466pdAo0cR=bg@mail.gmail.com>
Subject: Re: [[PATCH net-next]] net: core: xdp: make __mem_id_disconnect to be static
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: Networking <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>, xdp-newbies@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, hawk@kernel.org

On Tue, Jun 25, 2019 at 6:11 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Add missed static for local __mem_id_disconnect().
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

https://patchwork.ozlabs.org/patch/1121730/

I guess you are a little late. :)

Please ack the other patch.

Song

> ---
>  net/core/xdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index b29d7b513a18..829377cc83db 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>         kfree(xa);
>  }
>
> -bool __mem_id_disconnect(int id, bool force)
> +static bool __mem_id_disconnect(int id, bool force)
>  {
>         struct xdp_mem_allocator *xa;
>         bool safe_to_remove = true;
> --
> 2.17.1
>
