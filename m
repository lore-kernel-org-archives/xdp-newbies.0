Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44154 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfFXJvn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 24 Jun 2019 05:51:43 -0400
Received: by mail-ot1-f67.google.com with SMTP id b7so12826637otl.11
        for <xdp-newbies@vger.kernel.org>; Mon, 24 Jun 2019 02:51:43 -0700 (PDT)
MIME-Version: 1.0
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 24 Jun 2019 11:51:32 +0200
Message-ID: <CAJ8uoz2o5jxnUbtKjCbYe+QGffgCtLO05qXHFVfUHFiN3FXvvA@mail.gmail.com>
Subject: Re: Question/Bug about AF_XDP idx_cq from xsk_ring_cons__peek?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: William Tu <u9012063@gmail.com>, xdp-newbies@vger.kernel.org, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Eelco Chaudron <echaudro@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>

On Sat, 15 Jun 2019 at 01:25, William Tu <u9012063@xxxxxxxxx> wrote:
>
> Hi,
>
> In my implementation[1], I'm doing s.t like
>     tx_done = xsk_ring_cons__peek(&xsk->umem->cq, BATCH_SIZE, &idx_cq);
>     if (tx_done > 0) {
>         xsk_ring_cons__release(&xsk->umem->cq, tx_done);
>         xsk->outstanding_tx -= tx_done;
>     }
>
> I expect if tx_done returns 32, then after calling xsk_ring_cons__release,
> the next time I call xsk_ring_cons__peek, I should get idx_cq + 32.
> However, sometimes I see the same value of idx_cq is returned as previous, even
> when tx_done > 0. Is this the expected behavior?
>
> I experiment with xdpsock_user.c with the patch below and run
> ~/bpf-next/samples/bpf# ./xdpsock -l -N -z -i eth3
> using bpf-next commit 5e2ac390fbd08b2a462db66cef2663e4db0d5191
>
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -444,6 +443,8 @@ static void kick_tx(struct xsk_socket_info *xsk)
>         exit_with_error(errno);
>  }
>
> +static int prev_idx_cq;
> +
>  static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
>  {
>         u32 idx_cq = 0, idx_fq = 0;
> @@ -463,6 +464,15 @@ static inline void complete_tx_l2fwd(struct
> xsk_socket_info *xsk)
>                 unsigned int i;
>                 int ret;
>
> +        if (idx_cq == prev_idx_cq) {
> +            printf("\n\n ERROR \n\n");
> +        }
> +        if (idx_cq - prev_idx_cq != rcvd) {

William,

You need to compare with prev_rcvd (and introduce that variable) here
as the difference in index should be the same as the amount you
received last time. If you do this change, you will get no errors. You
can also see this pattern in your printouts. The diff is always equal
to rcvd during the previous iteration.

/Magnus

> +            printf("\n\n ERROR request %d return %d idx_cq %x prev_cq
> %x diff %d\n",
> +                   ndescs, rcvd, idx_cq, prev_idx_cq, idx_cq - prev_idx_cq);
> +        }
> +        prev_idx_cq = idx_cq;
> +
>                 ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
>                 while (ret != rcvd) {
>                         if (ret < 0)
> @@ -599,7 +609,7 @@ static void tx_only(struct xsk_socket_info *xsk)
>         }
>  }
> Most of the time idx_cq - prev_idx_cq == rcvd, but sometimes I got:
>  ERROR request 64 return 64 idx_cq 107f54 prev_cq 107f50 diff 4
>  ERROR request 64 return 4 idx_cq 2df794 prev_cq 2df754 diff 64
>  ERROR request 60 return 60 idx_cq 2df798 prev_cq 2df794 diff 4
>  ERROR request 64 return 64 idx_cq 2df7d4 prev_cq 2df798 diff 60
> I wonder if it is a bug?
> [1]https://github.com/williamtu/ovs-ebpf/blob/afxdp-v11/lib/netdev-afxdp.c#L719
>
> Thanks
> William
