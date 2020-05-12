Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45277 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725929AbgELO2o (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 12 May 2020 10:28:44 -0400
Received: by mail-lj1-f199.google.com with SMTP id u2so1917418ljg.22
        for <xdp-newbies@vger.kernel.org>; Tue, 12 May 2020 07:28:40 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP Software Issue - Payload Matching
In-Reply-To: <bbf21c58-09b3-b80f-11ab-548b229b9bdb@gflclan.com>
References: <9f91026d-e3da-ff7c-b2dd-a4a795e6975b@gflclan.com> <878shyg3e9.fsf@toke.dk> <bbf21c58-09b3-b80f-11ab-548b229b9bdb@gflclan.com>
Date: Tue, 12 May 2020 16:28:37 +0200
Message-ID: <87ftc5ut0q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Christian Deacon <gamemann@gflclan.com>, xdp-newbies@vger.kernel.org

Christian Deacon <gamemann@gflclan.com> writes:

> Hey Toke,
>
> Thank you for your response and the information!
>
> I actually found out last night about this as well, but when setting the 
> max payload match length to 1500 bytes (instead of 65535), I receive a 
> new error:
>
> ```
> invalid read from stack off -488+0 size 8
> processed 46277 insns (limit 1000000) max_states_per_insn 4 total_states 
> 617 peak_states 617 mark_read 599
> ```

Hmm, this sounds like the verifier can't prove that your stack variable
(presumably the 'byte' pointer) is actually safe to read from the stack.
Not sure why - maybe because the variable is declared in the inner loop
and the verifier loses track? IDK, really...

> Here's the new code:
>
> ```
> if (filter[i]->payloadLen > 0)
> {
>      uint8_t found = 1;
>
>      // MAX_PAYLOAD_LENGTH = 1500
>      for (uint16_t j = 0; j < MAX_PAYLOAD_LENGTH; j++)
>      {
>          if ((j + 1) > filter[i]->payloadLen)
>          {
>              break;
>          }
>
>          uint8_t *byte = data + sizeof(struct ethhdr) + (iph->ihl * 4) + 
> l4headerLen + j;
>
>          if (byte + 1 > (uint8_t *)data_end)
>          {
>              break;
>          }
>
>          if (*byte == filter[i]->payloadMatch[j])
>          {
>              continue;
>          }
>
>          found = 0;
>
>          break;
>      }
>
>      if (!found)
>      {
>          continue;
>      }
> }
> ```
>
> This error occurs when initializing the `byte` pointer (if I comment out 
> any lines with the `byte` pointer, the XDP program runs without 
> crashing). Though, to my understanding, I am doing things correctly here 
> along with ensuring the `byte` pointer is within the packet's range.

Well, "doing something safely" and "convincing the verifier that what
you're doing is safe" is not always the same thing ;)

> I am also going to look into implementing your second suggestion! I've 
> been trying to think of ways to improve performance with the software 
> and initially, I planned to only have filtering rules activated after a 
> certain global PPS/BPS threshold is met (specified in the config file). 
> However, it sounds like your suggestion would be more efficient.
>
> Thank you for all your help!

You're welcome! :)

-Toke
