Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42065 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbfGWL3k (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 23 Jul 2019 07:29:40 -0400
MIME-Version: 1.0
References: <20190708125554.3863901-1-arnd@arndb.de> <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
 <535ebf16-c523-0799-3ffe-6cfbeee3ac57@mellanox.com>
In-Reply-To: <535ebf16-c523-0799-3ffe-6cfbeee3ac57@mellanox.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 23 Jul 2019 13:29:23 +0200
Message-ID: <CAK8P3a2z=h02_1ybRzL1DpW26-Qn-v22=Fdf_Z_C02fYg9OFgQ@mail.gmail.com>
Subject: Re: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate mlx5e_channel_param
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Maxim Mikityanskiy <maximmi@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Tariq Toukan <tariqt@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>

On Tue, Jul 23, 2019 at 1:21 PM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> On 2019-07-08 18:16, Maxim Mikityanskiy wrote:
> > On 2019-07-08 15:55, Arnd Bergmann wrote:
> >> -    mlx5e_build_xsk_cparam(priv, params, xsk, &cparam);
> >> +    cparam = kzalloc(sizeof(*cparam), GFP_KERNEL);
> >
> > Similar code in mlx5e_open_channels (en_main.c) uses kvzalloc. Although
> > the struct is currently smaller than a page anyway, and there should be
> > no difference in behavior now, I suggest using the same alloc function
> > to keep code uniform.
> >
> >>      /* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
> >>       * triggered and NAPI to be called on the correct CPU.
> >>       */
> >> -    err = mlx5e_open_icosq(c, params, &cparam.icosq, &c->xskicosq);
> >> +    err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
> >>      if (unlikely(err))
> >>              goto err_close_icocq;
> >>
> >
> > Here is kfree missing. It's a memory leak in the good path.
>
> Arnd, I'm going to take over your patch and respin it, addressing my own
> comments, because it's been quite a while, and we want to have this fix.
>
> Thanks for spotting it.

Thanks for taking care of it now. I was planning to do a respin, but
the reply got lost in the depth of my inbox so I forgot about it.

      Arnd
