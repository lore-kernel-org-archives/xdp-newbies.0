Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35484 "EHLO
        tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730415AbfEWLZr (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 May 2019 07:25:47 -0400
Subject: Re: [PATCH bpf-next 1/3] xdp: Add bulk XDP_TX queue
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-2-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <8736l52zon.fsf@toke.dk>
From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Message-ID: <2ab04d02-634e-9420-9514-e4ede08bcb10@lab.ntt.co.jp>
Date: Thu, 23 May 2019 20:24:46 +0900
MIME-Version: 1.0
In-Reply-To: <8736l52zon.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org

On 2019/05/23 20:11, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
> 
>> XDP_TX is similar to XDP_REDIRECT as it essentially redirects packets to
>> the device itself. XDP_REDIRECT has bulk transmit mechanism to avoid the
>> heavy cost of indirect call but it also reduces lock acquisition on the
>> destination device that needs locks like veth and tun.
>>
>> XDP_TX does not use indirect calls but drivers which require locks can
>> benefit from the bulk transmit for XDP_TX as well.
> 
> XDP_TX happens on the same device, so there's an implicit bulking
> happening because of the NAPI cycle. So why is an additional mechanism
> needed (in the general case)?

Not sure what the implicit bulking you mention is. XDP_TX calls
.ndo_xdp_xmit() for each packet, and it acquires a lock in veth and tun.
To avoid this, we need additional storage for bulking like devmap for
XDP_REDIRECT.

-- 
Toshiaki Makita
