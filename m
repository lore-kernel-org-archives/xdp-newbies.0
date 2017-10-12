Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34179 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752606AbdJLRLu (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Oct 2017 13:11:50 -0400
Received: by mail-vk0-f65.google.com with SMTP id b5so1535272vkf.1
        for <xdp-newbies@vger.kernel.org>; Thu, 12 Oct 2017 10:11:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e9ca4c9b-c17b-5f7f-c1af-2f8fe932f224@netronome.com>
References: <1507803690-17709-1-git-send-email-jiong.wang@netronome.com>
 <20171012130412.72432f87@redhat.com> <e9ca4c9b-c17b-5f7f-c1af-2f8fe932f224@netronome.com>
From: Y Song <ys114321@gmail.com>
Date: Thu, 12 Oct 2017 10:11:08 -0700
Message-ID: <CAH3MdRX-nZx+2eA61L6FRaS8_6WJseA=dddYcn8fQe48z5LpAA@mail.gmail.com>
Subject: Re: [iovisor-dev] [PATCH, bpf-llvm] Fix bug on silently truncating
 64-bit immediate
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, xdp-newbies@vger.kernel.org, Yonghong Song <yhs@fb.com>, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>, oss-drivers@netronome.com, hans@hanshq.net

Hi, Jiong,

The patch looks good. Thanks for fixing the issue. Will merge soon.

Yonghong

On Thu, Oct 12, 2017 at 5:08 AM, Jiong Wang via iovisor-dev
<iovisor-dev@lists.iovisor.org> wrote:
> On 12/10/2017 12:04, Jesper Dangaard Brouer wrote:
>>
>> On Thu, 12 Oct 2017 06:21:30 -0400
>> Jiong Wang <jiong.wang@netronome.com> wrote:
>>
>>> We came across an llvm bug when compiling some testcases that 64-bit
>>> immediates are silently truncated into 32-bit and then packed into
>>> BPF_JMP | BPF_K encoding.  This caused comparison with wrong value.
>>
>> I think you send this to the wrong mailing list... this looks like a
>> patch against the LLVM source code.
>>
>> Shouldn't you send to: llvm-dev@lists.llvm.org ?
>
>
> Hi Jesper,
>
>   I am thinking the users & developers of eBPF llvm are quite focused in
> xdp-newbies and iovisor-dev, so if the code is related with user visible
> effect, for example bug fix, and if the code change is straightforward
> and small, I tend to just send it to these two so related user could be
> aware of it in case they are encountering the same problem, and then this
> patch could be posted to llvm review site (https://reviews.llvm.org).
>
>>
>>>
>>> This bug looks to be introduced by r308080.
>>
>> This looks like a very recent change:
>>    https://llvm.org/viewvc/llvm-project?view=revision&revision=308080
>>    Sat Jul 15 05:41:42 2017 UTC (2 months, 4 weeks ago)
>>
>> (As you are sending this to a user mailing list:
>> xdp-newbies@vger.kernel.org)
>>
>> I want to know if this have made it into a LLVM release? and which
>> release?
>
>
> This has not been made into any LLVM official release.
> The bug may show up if the user is trying to use distributor snapshop
> release.
>
>>
>> As the git-repo[1] replica of LLVM SVN-repo does not git-tag the
>> releases, I could not answer this question myself via the command:
>>
>> $ git describe --contains 7c423e0690
>>
>> [1] http://llvm.org/git/llvm.git
>>
>>> The Select_Ri pattern is
>>> supposed to be lowered into J*_Ri while the latter only support 32-bit
>>> immediate encoding, therefore Select_Ri should have similar immediate
>>> predicate check as what J*_Ri are doing.
>>>
>>> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>>> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
>>> ---
>>>   lib/Target/BPF/BPFISelLowering.cpp |  8 ++++++--
>>>   lib/Target/BPF/BPFInstrInfo.td     |  2 +-
>>>   test/CodeGen/BPF/select_ri.ll      | 35
>>> +++++++++++++++++++++++++++++++++++
>>>   3 files changed, 42 insertions(+), 3 deletions(-)
>
>
> --
>
> Regards,
> Jiong
>
> _______________________________________________
> iovisor-dev mailing list
> iovisor-dev@lists.iovisor.org
> https://lists.iovisor.org/mailman/listinfo/iovisor-dev
