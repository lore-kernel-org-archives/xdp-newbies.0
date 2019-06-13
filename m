Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731623AbfFMML7 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jun 2019 08:11:59 -0400
Date: Thu, 13 Jun 2019 14:11:46 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v3 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
Message-ID: <20190613141146.6901a03e@carbon>
In-Reply-To: <20190613093959.2796-2-toshiaki.makita1@gmail.com>
References: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
        <20190613093959.2796-2-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc: brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>, Jason Wang <jasowang@redhat.com>

On Thu, 13 Jun 2019 18:39:58 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> This is introduced for admins to check what is happening on XDP_TX when
> bulk XDP_TX is in use, which will be first introduced in veth in next
> commit.
> 
> v3:
> - Add act field to be in line with other XDP tracepoints.

Thanks

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
