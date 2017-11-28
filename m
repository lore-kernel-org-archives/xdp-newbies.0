Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:37954 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbdK1OaX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Nov 2017 09:30:23 -0500
Subject: Re: Compile error with unsigned integers
References: <6fc588408c38bdb9fe79b4128bb4e124@cse.iitd.ac.in>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d215e8a7-7bad-e0c2-8402-cfc7aca87225@iogearbox.net>
Date: Tue, 28 Nov 2017 15:30:19 +0100
MIME-Version: 1.0
In-Reply-To: <6fc588408c38bdb9fe79b4128bb4e124@cse.iitd.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: anmol07.visitor@cse.iitd.ac.in
Cc: Xdp <xdp-newbies@vger.kernel.org>, u9012063@gmail.com

[ + William ]

On 11/28/2017 01:19 PM, Anmol Panda wrote:
> Dear all,
> 
>     We are trying to compile the xdp programs in the /tests folder of p4c-xdp. On compiling from .c to .o using clang:
> clang -O2 -S -Wall -target bpf -c xdp1-mod.c -o xdp1-mod.o

Looks like you are double posting these issues within few hours
even (!?) ...

  https://github.com/vmware/p4c-xdp/issues/59

... p4c-xdp project is the more appropriate place to ask since
it's most likely related to the project itself.

> the following errors are reported:
> 
> In file included from xdp1-mod.c:3:
> ./xdp1-mod.h:16:5: error: unknown type name 'u32'
>     u32 input_port; /* bit<32> */
>     ^
> ./xdp1-mod.h:21:5: error: unknown type name 'u32'
>     u32 output_port; /* bit<32> */
>     ^
> ./xdp1-mod.h:25:5: error: unknown type name 'u64'
>     u64 destination; /* bit<48> */
>     ^
> ./xdp1-mod.h:26:5: error: unknown type name 'u64'
>     u64 source; /* bit<48> */
>     ^
> ./xdp1-mod.h:27:5: error: unknown type name 'u16'
>     u16 etherType; /* bit<16> */
>     ^
>    It reports 20 such errors and exits. We weren't getting such errors before when we successfully compiled and ran the test programs and even some programs that we had written. After browsing for this error, we tried including <stdint.h> and <linux/types.h>, but the error persists.
> 
>    The libstdc++ version is 7.2.0, llvm version is 6.0.0svn. Please guide us how we may resolve this issue. We are utmost grateful for your help and time.
> 
> Awaiting your response,
> Sincerely,
