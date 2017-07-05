Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36604 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdGETbg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 5 Jul 2017 15:31:36 -0400
Received: by mail-lf0-f67.google.com with SMTP id f28so21907901lfi.3
        for <xdp-newbies@vger.kernel.org>; Wed, 05 Jul 2017 12:31:35 -0700 (PDT)
Reply-To: jpmenil@gmail.com
Subject: Re: XDP for very newbies
References: <CAPF+HwVtau0R9tywwhuqpB_wXJp_RxfRD-s5KQr_Y-ofFWiSSA@mail.gmail.com>
 <d7a25483-b3ce-0635-c00a-11c94662138e@gmail.com>
 <CAPF+HwU8AmO82N986acfie5qp1hDm3skfG+46Tg1fwNP+C--uQ@mail.gmail.com>
From: Jean-Philippe Menil <jpmenil@gmail.com>
Message-ID: <f72ede56-eed2-502c-75c2-bc4296d709c9@gmail.com>
Date: Wed, 5 Jul 2017 21:31:32 +0200
MIME-Version: 1.0
In-Reply-To: <CAPF+HwU8AmO82N986acfie5qp1hDm3skfG+46Tg1fwNP+C--uQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Donatas Abraitis <donatas.abraitis@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On 07/05/2017 09:23 PM, Donatas Abraitis wrote:
> Yeah, but I cannot find anything useful regarding generic XDP which is
> a new feature.
> 
> On Wed, Jul 5, 2017 at 10:00 PM, Jean-Philippe Menil <jpmenil@gmail.com> wrote:
>> On 07/05/2017 08:36 PM, Donatas Abraitis wrote:
>>>
>>> Hi folks!
>>>
>>> I see some isolated examples about XDP, but cannot find any good
>>> tutorial in one place starting from theory to practical examples. Who
>>> can recommend something as a starting point?
>>>
>>> I would like to try Generic XDP or so.
>>>
>>
>> Hi Donatas,
>>
>> There is tons of stuff already referenced by Quentin:
>> https://qmonnet.github.io/whirl-offload/2016/09/01/dive-into-bpf/
>>
>> It's bpf oriented, but there is a lot of links/docs in the "About XDP"
>> section.
>>
>> Have fun.
>>
>> Jean-Philippe
> 
> 
> 

Hi,

Take a look to the blogspot from Jesper:
http://prototype-kernel.readthedocs.io/en/latest/blogposts/xdp25_eval_generic_xdp_tx.html

Regards.

Jean-Philippe
