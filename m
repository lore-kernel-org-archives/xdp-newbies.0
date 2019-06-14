Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:38128 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfFNXHa (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jun 2019 19:07:30 -0400
Subject: Re: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying
 map
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
 <20190614082015.23336-2-toshiaki.makita1@gmail.com> <877e9octre.fsf@toke.dk>
 <87sgscbc5d.fsf@toke.dk> <fb895684-c863-e580-f36a-30722c480b41@gmail.com>
 <87muikb9ev.fsf@toke.dk>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5f6efec8-87f8-4ac5-46ee-47788dbf1d44@iogearbox.net>
Date: Sat, 15 Jun 2019 01:07:14 +0200
MIME-Version: 1.0
In-Reply-To: <87muikb9ev.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Toshiaki Makita <toshiaki.makita1@gmail.com>, Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>

On 06/14/2019 03:09 PM, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
[...]
>>> Alternatively, since this entire series should probably go to stable, I
>>> can respin mine on top of it?
>>
>> Indeed conflict will happen, as this is for 'bpf' not 'bpf-next'.
>> Sorry for disturbing your work.
> 
> Oh, no worries!
> 
>> I'm also not sure how to proceed in this case.
> 
> I guess we'll leave that up to the maintainers :)

So all three look good to me, I've applied them to bpf tree. Fixes to bpf do
have precedence over patches to bpf-next given they need to land in the current
release. I'll get bpf out later tonight and ask David to merge net into net-next
after that since rebase is also needed for Stanislav's cgroup series. We'll then
flush out bpf-next so we can fast-fwd to net-next to pull in all the dependencies.

Thanks a lot,
Daniel
