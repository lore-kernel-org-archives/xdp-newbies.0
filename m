Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:27855 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753509AbdGUWhw (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 21 Jul 2017 18:37:52 -0400
Date: Fri, 21 Jul 2017 15:37:43 -0700
From: Jakub Kicinski <kubakici@wp.pl>
Subject: Re: XDP/BPF C and python libraries?
Message-ID: <20170721153743.31cd84a0@cakuba.netronome.com>
In-Reply-To: <5971D5D6.8010300@iogearbox.net>
References: <20170720225308.14e2ac14@cakuba.netronome.com>
        <5971D5D6.8010300@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: xdp-newbies@vger.kernel.org, ast@fb.com, Martin KaFai Lau <kafai@fb.com>, Hannes Frederic Sowa <hannes@redhat.com>

On Fri, 21 Jul 2017 12:22:14 +0200, Daniel Borkmann wrote:
> Hi Jakub,
> 
> On 07/21/2017 07:53 AM, Jakub Kicinski wrote:
> [...]
> > I've been writing various cli programs and little tools to play with
> > XDP and maps lately (testing NFP map offload).  I have a simple CLI
> > for loading programs, setting XDP up and interacting with maps.  It's
> > based on libbpf from tools/ and the loader from samples/bpf.  I wonder
> > how do others perform basic map interactions?  Perhaps I'm approaching
> > the problem from the wrong side?  Is anyone working on command line
> > interface for simple update/dump/delete operations?  
> 
> There is a small debugging tool in golang at [1] for inspection
> (but e.g. main integration and interaction is done from orchestrator
> side in case of cilium).

Thanks that's exactly the sort of functionality I had in mind.

> > I think it's recommended to use bpffs, are there any tools for
> > interacting with it?  
> 
> Only to name a few examples, cilium and the iproute2's BPF ELF
> loader interact with it, and I think recently also bcc got support
> for bpffs. From library side kernel's libbpf supports pinning into
> bpffs as well. We could probably have a small tool utilizing libbpf
> that sits under kernel tools/, though.

Upon further reflection it dawned on me that I should probably build on
top of Martin's work and utilize the prog/map ids.  Martin, do you have
any code (or plans to produce code :)) for listing/interrogating/
prodding programs and maps via the new ABI?

> > Are there any Python libraries which could take care of parsing ELF
> > files and poking maps?  My understanding is that BCC is not really the
> > tool for the job, because it's too high-level.  I don't want to compile
> > programs each time I want to load them.
> >
> > On the kernel sources - I'm pretty sure this was discussed on netdev
> > but I forgot the conclusion :( - is it possible to move
> > samples/bpf/bpf_load.c in some form to libbpf?  
> 
> Yep, that would be great if you have some patches! We should
> unify loader code where possible, so that both samples and
> selftests only use libbpf eventually. Also some of the sample
> programs should move to tools/testing/selftests/bpf/, so they
> can then be run on both, kbuild bot as well as linaro's kernel
> test framework to check for potential regressions.
> 
> Generally speaking, if you have some small, useful and generic
> tools that neither fit into iproute2 nor samples / selftests,
> then feel free to rename tools/net/ into tools/bpf/ (since all of
> there is BPF anyway right now) and add them into that location
> for general use.

If I have anything useful I will definitely share :)

Thanks!
