Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35310 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdK1Omv (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Nov 2017 09:42:51 -0500
Received: by mail-it0-f51.google.com with SMTP id f143so11972itb.0
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Nov 2017 06:42:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d215e8a7-7bad-e0c2-8402-cfc7aca87225@iogearbox.net>
References: <6fc588408c38bdb9fe79b4128bb4e124@cse.iitd.ac.in> <d215e8a7-7bad-e0c2-8402-cfc7aca87225@iogearbox.net>
From: William Tu <u9012063@gmail.com>
Date: Tue, 28 Nov 2017 06:42:09 -0800
Message-ID: <CALDO+SZrv33Y56A6KYEhDGaWy3pASCpm6_oZPaEexcPRFJ8SeA@mail.gmail.com>
Subject: Re: Compile error with unsigned integers
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: anmol07.visitor@cse.iitd.ac.in, Xdp <xdp-newbies@vger.kernel.org>

On Tue, Nov 28, 2017 at 6:30 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> [ + William ]
>
> On 11/28/2017 01:19 PM, Anmol Panda wrote:
>> Dear all,
>>
>>     We are trying to compile the xdp programs in the /tests folder of p4c-xdp. On compiling from .c to .o using clang:
>> clang -O2 -S -Wall -target bpf -c xdp1-mod.c -o xdp1-mod.o
>
> Looks like you are double posting these issues within few hours
> even (!?) ...
>
>   https://github.com/vmware/p4c-xdp/issues/59
>
> ... p4c-xdp project is the more appropriate place to ask since
> it's most likely related to the project itself.
>
>> the following errors are reported:
>>
>> In file included from xdp1-mod.c:3:
>> ./xdp1-mod.h:16:5: error: unknown type name 'u32'
>>     u32 input_port; /* bit<32> */
>>     ^
>> ./xdp1-mod.h:21:5: error: unknown type name 'u32'
>>     u32 output_port; /* bit<32> */
>>     ^
>> ./xdp1-mod.h:25:5: error: unknown type name 'u64'
>>     u64 destination; /* bit<48> */
>>     ^
>> ./xdp1-mod.h:26:5: error: unknown type name 'u64'
>>     u64 source; /* bit<48> */
>>     ^
>> ./xdp1-mod.h:27:5: error: unknown type name 'u16'
>>     u16 etherType; /* bit<16> */
>>     ^
>>    It reports 20 such errors and exits. We weren't getting such errors before when we successfully compiled and ran the test programs and even some programs that we had written. After browsing for this error, we tried including <stdint.h> and <linux/types.h>, but the error persists.
>>
>>    The libstdc++ version is 7.2.0, llvm version is 6.0.0svn. Please guide us how we may resolve this issue. We are utmost grateful for your help and time.
>>
>> Awaiting your response,
>> Sincerely,
>
Hi,

Since it's p4c-xdp project related, let's discuss in github issue page.
And thanks Daniel for forwarding.

William
