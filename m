Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47927 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388855AbgEMOmi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 May 2020 10:42:38 -0400
Received: by mail-lf1-f72.google.com with SMTP id 68so6222586lfj.9
        for <xdp-newbies@vger.kernel.org>; Wed, 13 May 2020 07:42:29 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP Software Issue - Payload Matching
In-Reply-To: <edbf300d-a687-7652-d702-d58be09fd541@gflclan.com>
References: <9f91026d-e3da-ff7c-b2dd-a4a795e6975b@gflclan.com> <878shyg3e9.fsf@toke.dk> <bbf21c58-09b3-b80f-11ab-548b229b9bdb@gflclan.com> <87ftc5ut0q.fsf@toke.dk> <edbf300d-a687-7652-d702-d58be09fd541@gflclan.com>
Date: Wed, 13 May 2020 16:42:25 +0200
Message-ID: <874ksjuca6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Christian Deacon <gamemann@gflclan.com>, xdp-newbies@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>

Christian Deacon <gamemann@gflclan.com> writes:

> Hey Toke,
>
> Thank you for your response!
>
> Unfortunately, I still haven't been able to get the for loop to work 
> properly. I've also noticed if I use `iph->ihl * 4` when initializing 
> the `byte` pointer, it produces the following error:
>
> ```
> R5 !read_ok
> processed 732 insns (limit 1000000) max_states_per_insn 4 total_states 
> 16 peak_states 16 mark_read 10
> ```
>
> It seems I need to use a static size such as `sizeof(struct iphdr)`. 
> Though, not all packets would have an IP header length of 20 bytes. I've 
> tried performing checks with the length as well:
>
> ```
> uint8_t len = iph->ihl * 4;
>
> if (len < 20)
> {
>      return XDP_DROP;
> }
> else if (len > 36)
> {
>      return XDP_DROP;
> }
>
> // Setting len to 20 or any other value works fine.
> // len = 20;
>
> uint8_t *byte = data + sizeof(struct ethhdr) + len + l4headerLen;
> ```
>
> However, no luck. I'm not sure what I can do to make BPF believe this is 
> safe.

Hmm, maybe have a look at Jesper's experiments with getting to the end
of the packet:

https://github.com/xdp-project/xdp-tutorial/pull/123
https://github.com/xdp-project/xdp-tutorial/pull/124

Not sure if he ended up concluding anything definite about what the best
technique is :)

> I was also wondering about the following:
>
>  > Use a matching algorithm that doesn't require looping through the 
> packet byte-by-byte as you're doing now. For instance, you could have a 
> hash map that uses the payload you're trying to match as the key with an 
> appropriate chunk size.
>
> Do you know of any BPF Helper/kernel functions that can hash the 
> payload? I looked at the BPF Helpers function list, but wasn't able to 
> find anything for XDP sadly. I would like to attempt to implement 
> something like this to see if I can avoid for loops since they aren't 
> working well with BPF from what I've seen.

No, there's no direct hashing helper for XDP. I just meant that you
could use the (chunk of) the payload directly as a key in a hashmap.
Something like:

struct hash_key {
       u8 payload[CHUNK_SIZE];
}

int xdp_main(ctx) {
    struct hash_key lookup_key = {};
    int *verdict;

    [...]

    memcpy(&lookup_key, ctx->data, CHUNK_SIZE);
    verdict = bpf_map_lookup_elem(&lookup_key, ...);

    if (verdict)
      do_something_with(*verdict);

}

(You'd still need to convince the verifier that the memcpy from packet
data is safe, of course).

-Toke
