Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from relay0111.mxlogin.com ([199.181.239.111]:41391 "EHLO
        relay0111.mxlogin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgEMNZx (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 May 2020 09:25:53 -0400
Received: from filter003.mxroute.com ([168.235.111.26] 168-235-111-26.cloud.ramnode.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by relay0111.mxlogin.com (ZoneMTA) with ESMTPSA id 1720e367261000167e.001
 for <xdp-newbies@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Wed, 13 May 2020 13:25:48 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id 8C5D56002F
        for <xdp-newbies@vger.kernel.org>; Wed, 13 May 2020 13:25:47 +0000 (UTC)
Subject: Re: XDP Software Issue - Payload Matching
References: <9f91026d-e3da-ff7c-b2dd-a4a795e6975b@gflclan.com>
 <878shyg3e9.fsf@toke.dk> <bbf21c58-09b3-b80f-11ab-548b229b9bdb@gflclan.com>
 <87ftc5ut0q.fsf@toke.dk>
From: Christian Deacon <gamemann@gflclan.com>
Message-ID: <edbf300d-a687-7652-d702-d58be09fd541@gflclan.com>
Date: Wed, 13 May 2020 08:25:39 -0500
MIME-Version: 1.0
In-Reply-To: <87ftc5ut0q.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, xdp-newbies@vger.kernel.org

Hey Toke,

Thank you for your response!

Unfortunately, I still haven't been able to get the for loop to work 
properly. I've also noticed if I use `iph->ihl * 4` when initializing 
the `byte` pointer, it produces the following error:

```
R5 !read_ok
processed 732 insns (limit 1000000) max_states_per_insn 4 total_states 
16 peak_states 16 mark_read 10
```

It seems I need to use a static size such as `sizeof(struct iphdr)`. 
Though, not all packets would have an IP header length of 20 bytes. I've 
tried performing checks with the length as well:

```
uint8_t len = iph->ihl * 4;

if (len < 20)
{
     return XDP_DROP;
}
else if (len > 36)
{
     return XDP_DROP;
}

// Setting len to 20 or any other value works fine.
// len = 20;

uint8_t *byte = data + sizeof(struct ethhdr) + len + l4headerLen;
```

However, no luck. I'm not sure what I can do to make BPF believe this is 
safe.

I was also wondering about the following:

 > Use a matching algorithm that doesn't require looping through the 
packet byte-by-byte as you're doing now. For instance, you could have a 
hash map that uses the payload you're trying to match as the key with an 
appropriate chunk size.

Do you know of any BPF Helper/kernel functions that can hash the 
payload? I looked at the BPF Helpers function list, but wasn't able to 
find anything for XDP sadly. I would like to attempt to implement 
something like this to see if I can avoid for loops since they aren't 
working well with BPF from what I've seen.

Thank you!


On 5/12/2020 9:28 AM, Toke Høiland-Jørgensen wrote:
> Christian Deacon <gamemann@gflclan.com> writes:
>
>> Hey Toke,
>>
>> Thank you for your response and the information!
>>
>> I actually found out last night about this as well, but when setting the
>> max payload match length to 1500 bytes (instead of 65535), I receive a
>> new error:
>>
>> ```
>> invalid read from stack off -488+0 size 8
>> processed 46277 insns (limit 1000000) max_states_per_insn 4 total_states
>> 617 peak_states 617 mark_read 599
>> ```
> Hmm, this sounds like the verifier can't prove that your stack variable
> (presumably the 'byte' pointer) is actually safe to read from the stack.
> Not sure why - maybe because the variable is declared in the inner loop
> and the verifier loses track? IDK, really...
>
>> Here's the new code:
>>
>> ```
>> if (filter[i]->payloadLen > 0)
>> {
>>       uint8_t found = 1;
>>
>>       // MAX_PAYLOAD_LENGTH = 1500
>>       for (uint16_t j = 0; j < MAX_PAYLOAD_LENGTH; j++)
>>       {
>>           if ((j + 1) > filter[i]->payloadLen)
>>           {
>>               break;
>>           }
>>
>>           uint8_t *byte = data + sizeof(struct ethhdr) + (iph->ihl * 4) +
>> l4headerLen + j;
>>
>>           if (byte + 1 > (uint8_t *)data_end)
>>           {
>>               break;
>>           }
>>
>>           if (*byte == filter[i]->payloadMatch[j])
>>           {
>>               continue;
>>           }
>>
>>           found = 0;
>>
>>           break;
>>       }
>>
>>       if (!found)
>>       {
>>           continue;
>>       }
>> }
>> ```
>>
>> This error occurs when initializing the `byte` pointer (if I comment out
>> any lines with the `byte` pointer, the XDP program runs without
>> crashing). Though, to my understanding, I am doing things correctly here
>> along with ensuring the `byte` pointer is within the packet's range.
> Well, "doing something safely" and "convincing the verifier that what
> you're doing is safe" is not always the same thing ;)
>
>> I am also going to look into implementing your second suggestion! I've
>> been trying to think of ways to improve performance with the software
>> and initially, I planned to only have filtering rules activated after a
>> certain global PPS/BPS threshold is met (specified in the config file).
>> However, it sounds like your suggestion would be more efficient.
>>
>> Thank you for all your help!
> You're welcome! :)
>
> -Toke
>
