Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:58856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfFYM3N (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 08:29:13 -0400
Subject: Re: [PATCH v3 bpf-next 0/2] veth: Bulk XDP_TX
References: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2ee794bc-403b-84c5-da8f-3cbabf52dff7@iogearbox.net>
Date: Tue, 25 Jun 2019 14:29:05 +0200
MIME-Version: 1.0
In-Reply-To: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Toshiaki Makita <toshiaki.makita1@gmail.com>, Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Jason Wang <jasowang@redhat.com>

On 06/13/2019 11:39 AM, Toshiaki Makita wrote:
> This introduces bulk XDP_TX in veth.
> Improves XDP_TX performance by approximately 9%. The detailed
> explanation and performance numbers are shown in patch 2.
> 
> v2:
> - Use stack for bulk queue instead of a global variable.
> 
> v3:
> - Add act field to xdp_bulk_tx tracepoint to be in line with other XDP
>   tracepoints.
> 
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> 
> Toshiaki Makita (2):
>   xdp: Add tracepoint for bulk XDP_TX
>   veth: Support bulk XDP_TX
> 
>  drivers/net/veth.c         | 60 ++++++++++++++++++++++++++++++++++++----------
>  include/trace/events/xdp.h | 29 ++++++++++++++++++++++
>  kernel/bpf/core.c          |  1 +
>  3 files changed, 78 insertions(+), 12 deletions(-)
> 

Applied, thanks!
