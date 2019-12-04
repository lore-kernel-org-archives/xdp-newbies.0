Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-il1-f194.google.com ([209.85.166.194]:40411 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730101AbfLDSEA (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 4 Dec 2019 13:04:00 -0500
Date: Wed, 04 Dec 2019 10:03:49 -0800
From: John Fastabend <john.fastabend@gmail.com>
Message-ID: <5de7f5057f957_96d2b0feaf1e5bc19@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzaTRc8dPxZnWhVZe7xpyMwpL1NEgGQyBjeXnsaN_D5CWA@mail.gmail.com>
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
 <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com>
 <CAADnVQJKSnoMVpQ3F86zBhFyo8WQ0vi65Z4QDtopLRrpK4yB8Q@mail.gmail.com>
 <4BBF99E4-9554-44F7-8505-D4B8416554C4@redhat.com>
 <d588c894-a4e0-8b99-72a9-4429b27091df@fb.com>
 <056E9F5E-4FDD-4636-A43A-EC98A06E84D3@redhat.com>
 <aa59532b-34a9-7887-f550-ef2859f0c9f1@fb.com>
 <B7E0062E-37ED-46E6-AE64-EE3E2A0294EA@redhat.com>
 <CAEf4BzaTRc8dPxZnWhVZe7xpyMwpL1NEgGQyBjeXnsaN_D5CWA@mail.gmail.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>, Eelco Chaudron <echaudro@redhat.com>
Cc: Yonghong Song <yhs@fb.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>

Andrii Nakryiko wrote:
> On Wed, Dec 4, 2019 at 5:20 AM Eelco Chaudron <echaudro@redhat.com> wrote:
> >

[...]

> >
> > PS: If I run the latest pahole (v1.15) on the .o files, I get the
> > following libbpf error: “libbpf: Cannot find bpf_func_info for main
> > program sec fexit/xdp_prog_simple. Ignore all bpf_func_info.”
> >
> 
> pahole is not supposed to be run on BPF object file. It's needed only
> to do DWARF to BTF conversion for kernel itself. So never mind this
> one. The NULL dereference, though, seems like a bug, I agree with
> Yonghong.

Really? I've been using pahole on BPF object files regularly mostly
to test structures match up with kernel pahole output but its always
worked on my side. Even pahole -j seems to work fine here.
