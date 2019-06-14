Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39000 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfFNLE4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jun 2019 07:04:56 -0400
Received: by mail-ed1-f67.google.com with SMTP id m10so2923281edv.6
        for <xdp-newbies@vger.kernel.org>; Fri, 14 Jun 2019 04:04:55 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying map
In-Reply-To: <20190614082015.23336-2-toshiaki.makita1@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com> <20190614082015.23336-2-toshiaki.makita1@gmail.com>
Date: Fri, 14 Jun 2019 13:04:53 +0200
Message-ID: <877e9octre.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Toshiaki Makita <toshiaki.makita1@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> dev_map_free() waits for flush_needed bitmap to be empty in order to
> ensure all flush operations have completed before freeing its entries.
> However the corresponding clear_bit() was called before using the
> entries, so the entries could be used after free.
>
> All access to the entries needs to be done before clearing the bit.
> It seems commit a5e2da6e9787 ("bpf: netdev is never null in
> __dev_map_flush") accidentally changed the clear_bit() and memory access
> order.
>
> Note that the problem happens only in __dev_map_flush(), not in
> dev_map_flush_old(). dev_map_flush_old() is called only after nulling
> out the corresponding netdev_map entry, so dev_map_free() never frees
> the entry thus no such race happens there.
>
> Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

I recently posted a patch[0] that gets rid of the bitmap entirely, so I
think you can drop this one...

-Toke

[0] https://lore.kernel.org/netdev/156042464148.25684.11881534392137955942.stgit@alrua-x1/
