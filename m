Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726401AbfK1TQf (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Nov 2019 14:16:35 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Date: Thu, 28 Nov 2019 20:16:28 +0100
Message-ID: <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com>
In-Reply-To: <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; markup=markdown
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>



On 28 Nov 2019, at 19:18, Alexei Starovoitov wrote:

> On Thu, Nov 28, 2019 at 9:20 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> Trying out the BPF trace to trace a BPF program, but I’m already
>> getting stuck loading the object with the fexit  :(
>
> I can take a look after holidays.

Enjoy the Holidays!! I figured out my auto kernel install script failed 
whiteout me noticing, and I was running an old kernel :(

I will try tomorrow with the correct kernel…


>> libbpf: load bpf program failed: Argument list too long
>> libbpf: failed to load program 'fexit/xdp_prog_simple'
>> libbpf: failed to load object './xdp_sample_fentry_fexit_kern.o'
>> ERROR: Failed to load object file: Operation not permitted
>
> please add -vvv and share full output.
