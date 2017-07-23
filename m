Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:34560 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdGWFgR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 23 Jul 2017 01:36:17 -0400
Received: by mail-ua0-f181.google.com with SMTP id q25so42742677uah.1
        for <xdp-newbies@vger.kernel.org>; Sat, 22 Jul 2017 22:36:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170722002050.315717be@cakuba.netronome.com>
References: <20170720225308.14e2ac14@cakuba.netronome.com> <5971D5D6.8010300@iogearbox.net>
 <20170721153743.31cd84a0@cakuba.netronome.com> <20170722002050.315717be@cakuba.netronome.com>
From: Y Song <ys114321@gmail.com>
Date: Sat, 22 Jul 2017 22:35:35 -0700
Message-ID: <CAH3MdRUemzziXr+74ik-fZLiuWJCeEQqFjimLLKdk1O+9P6nVA@mail.gmail.com>
Subject: Re: XDP/BPF C and python libraries?
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, Alexei Starovoitov <ast@fb.com>, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>, Tom Herbert via iovisor-dev <iovisor-dev@lists.iovisor.org>

cc'ing iovisor/bcc dev alias

Jakub,

I think this (bpf prog/map introspection) is a great idea.
I am cc'ing iovisor/bcc alias so maybe similar functionality
can be implemented in bcc as well.

Thanks,

Yonghong


On Sat, Jul 22, 2017 at 12:20 AM, Jakub Kicinski <kubakici@wp.pl> wrote:
> On Fri, 21 Jul 2017 15:37:43 -0700, Jakub Kicinski wrote:
>> On Fri, 21 Jul 2017 12:22:14 +0200, Daniel Borkmann wrote:
>> > Hi Jakub,
>> >
>> > On 07/21/2017 07:53 AM, Jakub Kicinski wrote:
>> > > I think it's recommended to use bpffs, are there any tools for
>> > > interacting with it?
>> >
>> > Only to name a few examples, cilium and the iproute2's BPF ELF
>> > loader interact with it, and I think recently also bcc got support
>> > for bpffs. From library side kernel's libbpf supports pinning into
>> > bpffs as well. We could probably have a small tool utilizing libbpf
>> > that sits under kernel tools/, though.
>>
>> Upon further reflection it dawned on me that I should probably build on
>> top of Martin's work and utilize the prog/map ids.  Martin, do you have
>> any code (or plans to produce code :)) for listing/interrogating/
>> prodding programs and maps via the new ABI?
>
> I put together this very simple tool with iproute2-like syntax:
>
> https://github.com/Netronome/bpf-tool
>
> These are available subcommands:
>
> bpf prog show
>
> bpf map show
> bpf map dump   id MAP_ID
> bpf map update id MAP_ID key BYTES value BYTES
> bpf map lookup id MAP_ID key BYTES
> bpf map delete id MAP_ID key BYTES
>
> The plan is to add support for substituting "id MAP_ID" with "pinned
> PATH".
>
> I probably have a need to poke maps more randomly than people would
> usually do, but I certainly enjoy the freedom of being able to load the
> xdp kernel samples with iproute2 and then observe the values from CLI :)
>
> I wonder what others think.  Or maybe someone else has a similar tool,
> but just haven't responded yet?
>
> One thing which is not clear to me is how to get the association
> between programs and maps?  Would we need to extend
> BPF_OBJ_GET_INFO_BY_FD to provide this info?
