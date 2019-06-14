Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39874 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfFNM71 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jun 2019 08:59:27 -0400
Subject: Re: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying
 map
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
 <20190614082015.23336-2-toshiaki.makita1@gmail.com> <877e9octre.fsf@toke.dk>
 <87sgscbc5d.fsf@toke.dk>
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <fb895684-c863-e580-f36a-30722c480b41@gmail.com>
Date: Fri, 14 Jun 2019 21:59:20 +0900
MIME-Version: 1.0
In-Reply-To: <87sgscbc5d.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>

On 19/06/14 (金) 21:10:38, Toke Høiland-Jørgensen wrote:
> Toke Høiland-Jørgensen <toke@redhat.com> writes:
> 
>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>
>>> dev_map_free() waits for flush_needed bitmap to be empty in order to
>>> ensure all flush operations have completed before freeing its entries.
>>> However the corresponding clear_bit() was called before using the
>>> entries, so the entries could be used after free.
>>>
>>> All access to the entries needs to be done before clearing the bit.
>>> It seems commit a5e2da6e9787 ("bpf: netdev is never null in
>>> __dev_map_flush") accidentally changed the clear_bit() and memory access
>>> order.
>>>
>>> Note that the problem happens only in __dev_map_flush(), not in
>>> dev_map_flush_old(). dev_map_flush_old() is called only after nulling
>>> out the corresponding netdev_map entry, so dev_map_free() never frees
>>> the entry thus no such race happens there.
>>>
>>> Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
>>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>>
>> I recently posted a patch[0] that gets rid of the bitmap entirely, so I
>> think you can drop this one...
> 
> Alternatively, since this entire series should probably go to stable, I
> can respin mine on top of it?

Indeed conflict will happen, as this is for 'bpf' not 'bpf-next'. Sorry 
for disturbing your work. I'm also not sure how to proceed in this case.

Toshiaki Makita
