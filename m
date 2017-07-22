Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:10232 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752064AbdGVHU6 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 22 Jul 2017 03:20:58 -0400
Date: Sat, 22 Jul 2017 00:20:50 -0700
From: Jakub Kicinski <kubakici@wp.pl>
Subject: Re: XDP/BPF C and python libraries?
Message-ID: <20170722002050.315717be@cakuba.netronome.com>
In-Reply-To: <20170721153743.31cd84a0@cakuba.netronome.com>
References: <20170720225308.14e2ac14@cakuba.netronome.com>
        <5971D5D6.8010300@iogearbox.net>
        <20170721153743.31cd84a0@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: xdp-newbies@vger.kernel.org, ast@fb.com, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>

On Fri, 21 Jul 2017 15:37:43 -0700, Jakub Kicinski wrote:
> On Fri, 21 Jul 2017 12:22:14 +0200, Daniel Borkmann wrote:
> > Hi Jakub,
> > 
> > On 07/21/2017 07:53 AM, Jakub Kicinski wrote:
> > > I think it's recommended to use bpffs, are there any tools for
> > > interacting with it?    
> > 
> > Only to name a few examples, cilium and the iproute2's BPF ELF
> > loader interact with it, and I think recently also bcc got support
> > for bpffs. From library side kernel's libbpf supports pinning into
> > bpffs as well. We could probably have a small tool utilizing libbpf
> > that sits under kernel tools/, though.  
> 
> Upon further reflection it dawned on me that I should probably build on
> top of Martin's work and utilize the prog/map ids.  Martin, do you have
> any code (or plans to produce code :)) for listing/interrogating/
> prodding programs and maps via the new ABI?

I put together this very simple tool with iproute2-like syntax:

https://github.com/Netronome/bpf-tool

These are available subcommands:

bpf prog show

bpf map show
bpf map dump   id MAP_ID
bpf map update id MAP_ID key BYTES value BYTES
bpf map lookup id MAP_ID key BYTES
bpf map delete id MAP_ID key BYTES

The plan is to add support for substituting "id MAP_ID" with "pinned
PATH".

I probably have a need to poke maps more randomly than people would
usually do, but I certainly enjoy the freedom of being able to load the
xdp kernel samples with iproute2 and then observe the values from CLI :)

I wonder what others think.  Or maybe someone else has a similar tool,
but just haven't responded yet?

One thing which is not clear to me is how to get the association
between programs and maps?  Would we need to extend
BPF_OBJ_GET_INFO_BY_FD to provide this info?
