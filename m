Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:39634 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727580AbfBONIB (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 15 Feb 2019 08:08:01 -0500
Subject: Re: Interruption in eBPF program after kernel update
References: <96e834867100a5ae9a941c639ef93456a2600021.camel@regit.org>
 <509b74cb74f13b02122707d2505e5c690866b159.camel@regit.org>
 <CAADnVQ+5KbWJqwOWVGGBwfX7h+1r7287452_Scrud8N8iR3Gow@mail.gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aecce2b7-a14d-b649-f180-2c43f30096f7@iogearbox.net>
Date: Fri, 15 Feb 2019 14:07:58 +0100
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+5KbWJqwOWVGGBwfX7h+1r7287452_Scrud8N8iR3Gow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Eric Leblond <eric@regit.org>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 02/14/2019 10:37 PM, Alexei Starovoitov wrote:
> On Thu, Feb 14, 2019 at 10:33 AM Eric Leblond <eric@regit.org> wrote:
>>
>> Hello,
>>
>> On Wed, 2019-02-13 at 20:46 +0100, Eric Leblond wrote:
>>> Hello,
>>>
>>> I've got a simple socket filter program that seems to interrupt when
>>> calling the load_word construct. I'm seeing the first message but
>>> never
>>> the second one.
>>>
>>> The code is the following
>>>
>>> int SEC("filter") hashfilter(struct __sk_buff *skb) {
>>>     __u32 nhoff = BPF_LL_OFF + ETH_HLEN;
>>
>> So it seems the problem was coming from this line. Removing BPF_LL_OFF
>> fixes the problem for kernel starting 4.18.
>>
>> Is this a known issue ?
>>
>> Is there something that would allow a BPF file to work independently of
>> the kernel version ?
> 
> Daniel,
> can this be related to removal of ld_abs legacy ?

Hm, strange, I'll take a look.

Thanks,
Daniel
