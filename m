Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:22658 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbdHaEYR (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 31 Aug 2017 00:24:17 -0400
Date: Wed, 30 Aug 2017 21:24:10 -0700
From: Jakub Kicinski <kubakici@wp.pl>
Subject: Re: BPF assembler?
Message-ID: <20170830212410.76ba6124@cakuba.netronome.com>
In-Reply-To: <CAADnVQ+O=a7Q5cxOxkkrVi09VyF+4u+ScV7F8TtZ2qAEL1a2aA@mail.gmail.com>
References: <20170830210619.6a97c0d0@cakuba.netronome.com>
        <CAADnVQ+O=a7Q5cxOxkkrVi09VyF+4u+ScV7F8TtZ2qAEL1a2aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On Wed, 30 Aug 2017 21:14:33 -0700, Alexei Starovoitov wrote:
> On Wed, Aug 30, 2017 at 9:06 PM, Jakub Kicinski <kubakici@wp.pl> wrote:
> > Hi!
> >
> > Is there any way to write eBPF programs in some form of an assembly
> > language?  
> 
> was Dave's gnu asm upstreamed? I lost the track while away...

I'm not sure, I don't see it here:

https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git

> llvm assembler is almost there too, but it needs some work.

Does it use the "verifier instruction format"?  Is it available
somewhere to look at?

Either way, I would be happy to help finish at least one of them :)
