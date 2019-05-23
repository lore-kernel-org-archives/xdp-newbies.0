Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42160 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbfEWLLY (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 May 2019 07:11:24 -0400
Received: by mail-ed1-f65.google.com with SMTP id l25so8640040eda.9
        for <xdp-newbies@vger.kernel.org>; Thu, 23 May 2019 04:11:23 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 1/3] xdp: Add bulk XDP_TX queue
In-Reply-To: <1558609008-2590-2-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp> <1558609008-2590-2-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Date: Thu, 23 May 2019 13:11:20 +0200
Message-ID: <8736l52zon.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:

> XDP_TX is similar to XDP_REDIRECT as it essentially redirects packets to
> the device itself. XDP_REDIRECT has bulk transmit mechanism to avoid the
> heavy cost of indirect call but it also reduces lock acquisition on the
> destination device that needs locks like veth and tun.
>
> XDP_TX does not use indirect calls but drivers which require locks can
> benefit from the bulk transmit for XDP_TX as well.

XDP_TX happens on the same device, so there's an implicit bulking
happening because of the NAPI cycle. So why is an additional mechanism
needed (in the general case)?

-Toke
