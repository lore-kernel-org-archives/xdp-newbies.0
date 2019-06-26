Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36817 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFZUuf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 26 Jun 2019 16:50:35 -0400
MIME-Version: 1.0
References: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Wed, 26 Jun 2019 22:50:23 +0200
Message-ID: <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com>
Subject: Re: [PATCH net-next] xdp: xdp_umem: fix umem pages mapping for 32bits systems
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, David Miller <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, 26 Jun 2019 at 17:59, Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Use kmap instead of page_address as it's not always in low memory.
>

Ah, some 32-bit love. :-) Thanks for working on this!

For future patches, please base AF_XDP patches on the bpf/bpf-next
tree instead of net/net-next.

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  net/xdp/xdp_umem.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 9c6de4f114f8..d3c1411420fd 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -169,6 +169,14 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
>         }
>  }
>
> +static void xdp_umem_unmap_pages(struct xdp_umem *umem)
> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < umem->npgs; i++)
> +               kunmap(umem->pgs[i]);
> +}
> +
>  static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>  {
>         unsigned int i;
> @@ -210,6 +218,7 @@ static void xdp_umem_release(struct xdp_umem *umem)
>
>         xsk_reuseq_destroy(umem);
>
> +       xdp_umem_unmap_pages(umem);
>         xdp_umem_unpin_pages(umem);
>
>         kfree(umem->pages);
> @@ -372,7 +381,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>         }
>
>         for (i = 0; i < umem->npgs; i++)
> -               umem->pages[i].addr = page_address(umem->pgs[i]);
> +               umem->pages[i].addr = kmap(umem->pgs[i]);
>
>         return 0;
>
> --
> 2.17.1
>
