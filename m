Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:49366 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753232AbdJLMIa (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Oct 2017 08:08:30 -0400
Received: by mail-wm0-f44.google.com with SMTP id b189so12485178wmd.4
        for <xdp-newbies@vger.kernel.org>; Thu, 12 Oct 2017 05:08:29 -0700 (PDT)
Subject: Re: [PATCH, bpf-llvm] Fix bug on silently truncating 64-bit immediate
References: <1507803690-17709-1-git-send-email-jiong.wang@netronome.com>
 <20171012130412.72432f87@redhat.com>
From: Jiong Wang <jiong.wang@netronome.com>
Message-ID: <e9ca4c9b-c17b-5f7f-c1af-2f8fe932f224@netronome.com>
Date: Thu, 12 Oct 2017 13:08:23 +0100
MIME-Version: 1.0
In-Reply-To: <20171012130412.72432f87@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: xdp-newbies@vger.kernel.org, yhs@fb.com, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, hans@hanshq.net

On 12/10/2017 12:04, Jesper Dangaard Brouer wrote:
> On Thu, 12 Oct 2017 06:21:30 -0400
> Jiong Wang <jiong.wang@netronome.com> wrote:
>
>> We came across an llvm bug when compiling some testcases that 64-bit
>> immediates are silently truncated into 32-bit and then packed into
>> BPF_JMP | BPF_K encoding.  This caused comparison with wrong value.
> I think you send this to the wrong mailing list... this looks like a
> patch against the LLVM source code.
>
> Shouldn't you send to: llvm-dev@lists.llvm.org ?

Hi Jesper,

   I am thinking the users & developers of eBPF llvm are quite focused in
xdp-newbies and iovisor-dev, so if the code is related with user visible
effect, for example bug fix, and if the code change is straightforward
and small, I tend to just send it to these two so related user could be
aware of it in case they are encountering the same problem, and then this
patch could be posted to llvm review site (https://reviews.llvm.org).

>   
>> This bug looks to be introduced by r308080.
> This looks like a very recent change:
>    https://llvm.org/viewvc/llvm-project?view=revision&revision=308080
>    Sat Jul 15 05:41:42 2017 UTC (2 months, 4 weeks ago)
>
> (As you are sending this to a user mailing list: xdp-newbies@vger.kernel.org)
>
> I want to know if this have made it into a LLVM release? and which release?

This has not been made into any LLVM official release.
The bug may show up if the user is trying to use distributor snapshop release.

>
> As the git-repo[1] replica of LLVM SVN-repo does not git-tag the
> releases, I could not answer this question myself via the command:
>
> $ git describe --contains 7c423e0690
>
> [1] http://llvm.org/git/llvm.git
>
>> The Select_Ri pattern is
>> supposed to be lowered into J*_Ri while the latter only support 32-bit
>> immediate encoding, therefore Select_Ri should have similar immediate
>> predicate check as what J*_Ri are doing.
>>
>> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>> ---
>>   lib/Target/BPF/BPFISelLowering.cpp |  8 ++++++--
>>   lib/Target/BPF/BPFInstrInfo.td     |  2 +-
>>   test/CodeGen/BPF/select_ri.ll      | 35 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 42 insertions(+), 3 deletions(-)

-- 

Regards,
Jiong
