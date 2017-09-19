Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:47440 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbdISW5C (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 19 Sep 2017 18:57:02 -0400
Received: by mail-wm0-f45.google.com with SMTP id 13so2651281wmq.2
        for <xdp-newbies@vger.kernel.org>; Tue, 19 Sep 2017 15:57:01 -0700 (PDT)
Subject: Re: [iovisor-dev] [PATCH RFC 0/4] Initial 32-bit eBPF encoding
 support
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
 <4e9a7569-e93f-fcd4-ab25-ac00afaa17d3@polito.it>
From: Jiong Wang <jiong.wang@netronome.com>
Message-ID: <0abf5747-f774-d0b3-7cf7-5a996bbf1bec@netronome.com>
Date: Tue, 19 Sep 2017 23:56:34 +0100
MIME-Version: 1.0
In-Reply-To: <4e9a7569-e93f-fcd4-ab25-ac00afaa17d3@polito.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Fulvio Risso <fulvio.risso@polito.it>, xdp-newbies@vger.kernel.org
Cc: llvm-dev@lists.llvm.org, oss-drivers@netronome.com, iovisor-dev@lists.iovisor.org

On 19/09/2017 05:49, Fulvio Risso wrote:
> Dear Jiong,
>
> that's a great work.
> I havent' gone through the whole patches, but it seems to me that the 
> documentation is not that much.
> From my past experiences, putting your hands into a compiler without 
> at least some high-level documentation that presents how it works, it 
> would be a nightmare.

Hi Fulvio,

   Thanks for the feedback.

   I agree that we need some high-level documentation on this. It could let
people evaluating the implementation approach taken and we could make sure
things on on correct direction.

   I was dividing the 32-bit BPF support into the following three parts and
I am thinking the support of the first part could let the user be able to
construct testcases contaning 32-bit ALU which is good for experimenting
and it won't affect code-gen from .c/.ll. Aslo this part is not hard for
review and relatively independent, so I have seperated them out into this
patch set for review.

   Detailed implementation details or high-level design will be included in
the cover letter of patch set for the second part which is the actually
part for 32-bit code-gen enablement.

brief intro on 32-bit BPF support phases
===
     * Support in assembly level.

       This includes cleanup of existing BPF instruction patterns to make them
       32-bit support friendly and also the registration of 32-bit register set.

     * Full code-gen Support in LLVM.

       This includes making 32-bit integer type as legal type and associate it
       with 32-bit register class, also we need to cleanup operation legalization
       stragegies.

       We need to discuss whether we want to make 32-bit BPF an new target or
       just an new environment in LLVM's concept, so the user could simply enable
       it through something like --triple=bpf-unknown-elf-ilp32. We may also need
       new ELF attributes and new relocation types for map address relocation for
       32-bit eBPF.

     * Hook Clang driver with LLVM.

       Support for this is straightforward, especially if we go with new environment
       approach.

Regards,

Jiong
