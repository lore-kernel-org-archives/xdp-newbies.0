Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43966 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfGEGnJ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 5 Jul 2019 02:43:09 -0400
MIME-Version: 1.0
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
 <20190704142503.23501-1-i.maximets@samsung.com>
In-Reply-To: <20190704142503.23501-1-i.maximets@samsung.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Fri, 5 Jul 2019 08:42:56 +0200
Message-ID: <CAJ+HfNi2EdLwtq9SfccZBymDMv_cW5+vxB-JLqxyvYS_TG3ScA@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: fix possible cq entry leak
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Ilya Maximets <i.maximets@samsung.com>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Thu, 4 Jul 2019 at 16:25, Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Completion queue address reservation could not be undone.
> In case of bad 'queue_id' or skb allocation failure, reserved entry
> will be leaked reducing the total capacity of completion queue.
>
> Fix that by moving reservation to the point where failure is not
> possible. Additionally, 'queue_id' checking moved out from the loop
> since there is no point to check it there.
>

Good catch, Ilya! Thanks for the patch!

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> Fixes: 35fcde7f8deb ("xsk: support for Tx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>  net/xdp/xsk.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index f53a6ef7c155..703cf5ea448b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -226,6 +226,9 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
>
>         mutex_lock(&xs->mutex);
>
> +       if (xs->queue_id >= xs->dev->real_num_tx_queues)
> +               goto out;
> +
>         while (xskq_peek_desc(xs->tx, &desc)) {
>                 char *buffer;
>                 u64 addr;
> @@ -236,12 +239,6 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
>                         goto out;
>                 }
>
> -               if (xskq_reserve_addr(xs->umem->cq))
> -                       goto out;
> -
> -               if (xs->queue_id >= xs->dev->real_num_tx_queues)
> -                       goto out;
> -
>                 len = desc.len;
>                 skb = sock_alloc_send_skb(sk, len, 1, &err);
>                 if (unlikely(!skb)) {
> @@ -253,7 +250,7 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
>                 addr = desc.addr;
>                 buffer = xdp_umem_get_data(xs->umem, addr);
>                 err = skb_store_bits(skb, 0, buffer, len);
> -               if (unlikely(err)) {
> +               if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
>                         kfree_skb(skb);
>                         goto out;
>                 }
> --
> 2.17.1
>
