Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731696AbfFMMOB (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jun 2019 08:14:01 -0400
Date: Thu, 13 Jun 2019 14:13:51 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v3 bpf-next 2/2] veth: Support bulk XDP_TX
Message-ID: <20190613141351.77747fc1@carbon>
In-Reply-To: <20190613093959.2796-3-toshiaki.makita1@gmail.com>
References: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
        <20190613093959.2796-3-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc: brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>, Jason Wang <jasowang@redhat.com>

On Thu, 13 Jun 2019 18:39:59 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> XDP_TX is similar to XDP_REDIRECT as it essentially redirects packets to
> the device itself. XDP_REDIRECT has bulk transmit mechanism to avoid the
> heavy cost of indirect call but it also reduces lock acquisition on the
> destination device that needs locks like veth and tun.
> 
> XDP_TX does not use indirect calls but drivers which require locks can
> benefit from the bulk transmit for XDP_TX as well.
> 
> This patch introduces bulk transmit mechanism in veth using bulk queue
> on stack, and improves XDP_TX performance by about 9%.
> 
> Here are single-core/single-flow XDP_TX test results. CPU consumptions
> are taken from "perf report --no-child".
> 
> - Before:
> 
>   7.26 Mpps
> 
>   _raw_spin_lock  7.83%
>   veth_xdp_xmit  12.23%
> 
> - After:
> 
>   7.94 Mpps
> 
>   _raw_spin_lock  1.08%
>   veth_xdp_xmit   6.10%
> 
> v2:
> - Use stack for bulk queue instead of a global variable.
> 
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> ---
>  drivers/net/veth.c | 60 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 48 insertions(+), 12 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
