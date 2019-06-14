Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37398 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfFNLHp (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jun 2019 07:07:45 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so1981357ljf.4
        for <xdp-newbies@vger.kernel.org>; Fri, 14 Jun 2019 04:07:44 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf 3/3] devmap: Add missing RCU read lock on flush
In-Reply-To: <20190614082015.23336-4-toshiaki.makita1@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com> <20190614082015.23336-4-toshiaki.makita1@gmail.com>
Date: Fri, 14 Jun 2019 13:07:42 +0200
Message-ID: <874l4sctmp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Toshiaki Makita <toshiaki.makita1@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> .ndo_xdp_xmit() assumes it is called under RCU. For example virtio_net
> uses RCU to detect it has setup the resources for tx. The assumption
> accidentally broke when introducing bulk queue in devmap.
>
> Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> ---

I think this is still needed, but the patch context is going to conflict
with the patch I linked above... I guess it's up to the maintainers to
decide which order to merge them in :)

-Toke
