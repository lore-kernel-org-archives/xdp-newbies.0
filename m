Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39228 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfK1Tr1 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 28 Nov 2019 14:47:27 -0500
MIME-Version: 1.0
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com> <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com>
In-Reply-To: <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 28 Nov 2019 11:47:13 -0800
Message-ID: <CAADnVQJKSnoMVpQ3F86zBhFyo8WQ0vi65Z4QDtopLRrpK4yB8Q@mail.gmail.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Eelco Chaudron <echaudro@redhat.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Thu, Nov 28, 2019 at 11:16 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 28 Nov 2019, at 19:18, Alexei Starovoitov wrote:
>
> > On Thu, Nov 28, 2019 at 9:20 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> Trying out the BPF trace to trace a BPF program, but I’m already
> >> getting stuck loading the object with the fexit  :(
> >
> > I can take a look after holidays.
>
> Enjoy the Holidays!! I figured out my auto kernel install script failed
> whiteout me noticing, and I was running an old kernel :(
>
> I will try tomorrow with the correct kernel…

Please also check that you have the latest llvm and pahole.
pahole version should be >= 1.13.
clang ideally from master.
If all that is working then downgrade one by one and bisect whether the bug is.

>
> >> libbpf: load bpf program failed: Argument list too long
> >> libbpf: failed to load program 'fexit/xdp_prog_simple'
> >> libbpf: failed to load object './xdp_sample_fentry_fexit_kern.o'
> >> ERROR: Failed to load object file: Operation not permitted
> >
> > please add -vvv and share full output.
>
