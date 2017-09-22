Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:49362 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdIVE4M (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 22 Sep 2017 00:56:12 -0400
Received: by mail-vk0-f53.google.com with SMTP id h191so15112vke.6
        for <xdp-newbies@vger.kernel.org>; Thu, 21 Sep 2017 21:56:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a6541ae5-0da5-4959-c903-36eb749cc3e9@netronome.com>
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
 <1505767641-40512-4-git-send-email-jiong.wang@netronome.com>
 <CAH3MdRVE-CCzVoaFg1tDtyFV7s9Q5nwbotHDs3je03OeX7M9MA@mail.gmail.com> <a6541ae5-0da5-4959-c903-36eb749cc3e9@netronome.com>
From: Y Song <ys114321@gmail.com>
Date: Thu, 21 Sep 2017 21:55:31 -0700
Message-ID: <CAH3MdRU6CkcW5xLFmqs-Bm0jyHP18tjNZ3Mb-3Ss6Gu8u84paA@mail.gmail.com>
Subject: Re: [iovisor-dev] [PATCH RFC 3/4] New 32-bit register set
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, LLVM Developers Mailing List <llvm-dev@lists.llvm.org>, oss-drivers@netronome.com, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>

Hi, Jiong,

The new patch looks good. I did some basic testing on
net-next:samples/bpf and net-next:tools/testing/selftests/bpf and it
works fine. All existing llvm unit tests are not impacted as well as
expected.

I have applied the patch to the trunk. Besides your other work to
support 32bit abi, it would be
interesting to see how new 32bit register can be used in 64bit
architecture which may help improve performance and/or reduce
instruction count.

Thanks,
Yonghong

On Tue, Sep 19, 2017 at 4:10 PM, Jiong Wang <jiong.wang@netronome.com> wrote:
> On 19/09/2017 07:44, Y Song wrote:
>>
>> Hi, Jiong,
>>
>> Thanks for the patch! It is a great start to support 32bit register in
>> BPF.
>> In the past, I have studied a little bit to see whether 32bit register
>> support may reduce
>> the number of unnecessary shifts on x86_64 and improve the
>> performance. Looking through
>> a few bpf programs and it looks like the opportunity is not great, but
>> still nice to have if we
>> have this capability. As you mentioned, this definitely helped 32bit
>> architecture!
>>
>> I am not an expert in LLVM tablegen. I briefly looked through the code
>> change and it looks like
>> correct. Hopefully some llvm-dev tablegen experts can comment on the
>> implementation.
>>
>> Below I only have a couple of minor comments.
>
>
> Yong Hong,
>
>   Thanks for the review.
>
>   I have addressed your comments and attached the updated patch.
>
>   Do you want me to put this patch set on to llvm review website? I guess it
> is the
>   formal review channel?
>
> Regards,
> Jiong
>
