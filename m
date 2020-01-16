Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f180.google.com ([209.85.222.180]:35961 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgAPAku (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 15 Jan 2020 19:40:50 -0500
Received: by mail-qk1-f180.google.com with SMTP id a203so17621866qkc.3
        for <xdp-newbies@vger.kernel.org>; Wed, 15 Jan 2020 16:40:49 -0800 (PST)
Subject: Re: XDP invalid memory access
References: <CAK86TEf+GY3F8resRW11DNvate5uqSsh=JAQuJHhBuL0sQpvjg@mail.gmail.com>
 <87ftggtl7t.fsf@toke.dk>
 <CAK86TEcyRqVrB-OOiCxtM6WLMp-Sr_+eO9G70+T=OMpF2KBrgQ@mail.gmail.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <99fe90fe-cbb4-1ff1-156b-bd8053293aca@gmail.com>
Date: Wed, 15 Jan 2020 17:40:46 -0700
MIME-Version: 1.0
In-Reply-To: <CAK86TEcyRqVrB-OOiCxtM6WLMp-Sr_+eO9G70+T=OMpF2KBrgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Vincent Li <mchun.li@gmail.com>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= <toke@redhat.com>
Cc: xdp-newbies@vger.kernel.org

On 1/15/20 3:31 PM, Vincent Li wrote:
> On Wed, Jan 15, 2020 at 2:21 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> 
>> You have to check that you're not reading out of bounds before
>> dereferencing the bytes in the TCP header...
>>
> 
> I have below before the optlen
> 
>    47 /* sanity check needed by the eBPF verifier */
> 
>     48 if ((void *)(tcphdr + 1) > data_end)
> 
>     49 return 0;
> 
> this is not enough, how do I check the out of bounds properly?
> 

options are optional and after 'struct tcphdr' you need to do something
like:

   if ((void *)(tcphdr + 1) + tcphdr->doff > data_end)
       return XDP_....
