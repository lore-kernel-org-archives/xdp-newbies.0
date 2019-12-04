Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37829 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbfLDVTd (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 4 Dec 2019 16:19:33 -0500
MIME-Version: 1.0
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
 <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com> <CAADnVQJKSnoMVpQ3F86zBhFyo8WQ0vi65Z4QDtopLRrpK4yB8Q@mail.gmail.com>
 <4BBF99E4-9554-44F7-8505-D4B8416554C4@redhat.com> <d588c894-a4e0-8b99-72a9-4429b27091df@fb.com>
 <056E9F5E-4FDD-4636-A43A-EC98A06E84D3@redhat.com> <aa59532b-34a9-7887-f550-ef2859f0c9f1@fb.com>
 <B7E0062E-37ED-46E6-AE64-EE3E2A0294EA@redhat.com> <CAEf4BzaTRc8dPxZnWhVZe7xpyMwpL1NEgGQyBjeXnsaN_D5CWA@mail.gmail.com>
 <5de7f5057f957_96d2b0feaf1e5bc19@john-XPS-13-9370.notmuch>
In-Reply-To: <5de7f5057f957_96d2b0feaf1e5bc19@john-XPS-13-9370.notmuch>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 4 Dec 2019 13:19:21 -0800
Message-ID: <CAEf4BzaorvXOcunEg7CPYmeFhWzAg14dOaj10kVxzc9pnoXiLw@mail.gmail.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: John Fastabend <john.fastabend@gmail.com>
Cc: Eelco Chaudron <echaudro@redhat.com>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Wed, Dec 4, 2019 at 10:03 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Wed, Dec 4, 2019 at 5:20 AM Eelco Chaudron <echaudro@redhat.com> wrote:
> > >
>
> [...]
>
> > >
> > > PS: If I run the latest pahole (v1.15) on the .o files, I get the
> > > following libbpf error: “libbpf: Cannot find bpf_func_info for main
> > > program sec fexit/xdp_prog_simple. Ignore all bpf_func_info.”
> > >
> >
> > pahole is not supposed to be run on BPF object file. It's needed only
> > to do DWARF to BTF conversion for kernel itself. So never mind this
> > one. The NULL dereference, though, seems like a bug, I agree with
> > Yonghong.
>
> Really? I've been using pahole on BPF object files regularly mostly
> to test structures match up with kernel pahole output but its always
> worked on my side. Even pahole -j seems to work fine here.

Well, it still works for simpler stuff, but it certainly won't emit
global variables type info, CO-RE relocations, etc. BTF for BPF object
files should get produced by Clang,  which is perfectly capable of
doing this (provided you have recent enough version of it, of course).
