Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46279 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfFNNEE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 14 Jun 2019 09:04:04 -0400
Subject: Re: [PATCH bpf 2/3] devmap: Add missing bulk queue free
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
 <20190614082015.23336-3-toshiaki.makita1@gmail.com>
 <20190614135806.4bcb1a31@carbon>
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <4ab32fa0-0c79-79c7-141b-9620f844d23b@gmail.com>
Date: Fri, 14 Jun 2019 22:03:57 +0900
MIME-Version: 1.0
In-Reply-To: <20190614135806.4bcb1a31@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>

On 19/06/14 (金) 20:58:06, Jesper Dangaard Brouer wrote:
> On Fri, 14 Jun 2019 17:20:14 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> 
>> dev_map_free() forgot to free bulk queue when freeing its entries.
>>
>> Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>> ---
>>   kernel/bpf/devmap.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index e001fb1..a126d95 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -186,6 +186,7 @@ static void dev_map_free(struct bpf_map *map)
>>   		if (!dev)
>>   			continue;
>>   
>> +		free_percpu(dev->bulkq);
>>   		dev_put(dev->dev);
>>   		kfree(dev);
>>   	}
> 
> Do we need to call need to call dev_map_flush_old() before
> free_percpu(dev->bulkq) ?
> 
> Looking the code, I guess this is not needed as, above we are ensuring
> all pending flush operations have completed.

My understanding is the same. The code waits for NAPI to flush the 
queue, so no need for dev_map_flush_old().

> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks!

Toshiaki Makita
