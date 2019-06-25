Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40512 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729106AbfFYScz (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 14:32:55 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so9358954pgj.7
        for <xdp-newbies@vger.kernel.org>; Tue, 25 Jun 2019 11:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190625182352.13918-1-natechancellor@gmail.com>
In-Reply-To: <20190625182352.13918-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 25 Jun 2019 11:32:42 -0700
Message-ID: <CAKwvOdkdXRRrTSukQ4mJ6FfjqD-GJeBzOK34e+=jJzaQ3qOaiw@mail.gmail.com>
Subject: Re: [PATCH] xsk: Properly terminate assignment in xskq_produce_flush_desc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>, Nathan Huckleberry <nhuck@google.com>

On Tue, Jun 25, 2019 at 11:24 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> In file included from net/xdp/xsk_queue.c:10:
> net/xdp/xsk_queue.h:292:2: warning: expression result unused
> [-Wunused-value]
>         WRITE_ONCE(q->ring->producer, q->prod_tail);
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
>         __u.__val;                                      \
>         ~~~ ^~~~~
> 1 warning generated.
>
> The q->prod_tail assignment has a comma at the end, not a semi-colon.
> Fix that so clang no longer warns and everything works as expected.

oh no! -Wunderhanded-C-contest-style-use-of-comma-operator strikes again!
Great find and thanks for the fix.
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

Bj=C3=B6rn and Alexei should carefully review.  Because WRITE_ONCE is a
macro that expands to a GNU C statement expression, which returns the
last statement, this code was previously assigning q->prod_tail to
itself, now it's assigning it to q->prod_head.  I assume that was not
intentional, but am unfamiliar with the code.

>
> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/544
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  net/xdp/xsk_queue.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 88b9ae24658d..cba4a640d5e8 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -288,7 +288,7 @@ static inline void xskq_produce_flush_desc(struct xsk=
_queue *q)
>         /* Order producer and data */
>         smp_wmb(); /* B, matches C */
>
> -       q->prod_tail =3D q->prod_head,
> +       q->prod_tail =3D q->prod_head;
>         WRITE_ONCE(q->ring->producer, q->prod_tail);
>  }
>
> --
> 2.22.0
>


--=20
Thanks,
~Nick Desaulniers
