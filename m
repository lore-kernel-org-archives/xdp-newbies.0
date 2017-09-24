Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:45516 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdIXFqw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 24 Sep 2017 01:46:52 -0400
Received: by mail-pg0-f54.google.com with SMTP id 188so2447909pgb.2
        for <xdp-newbies@vger.kernel.org>; Sat, 23 Sep 2017 22:46:52 -0700 (PDT)
Date: Sat, 23 Sep 2017 22:46:54 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [iovisor-dev] [PATCH RFC 0/4] Initial 32-bit eBPF encoding
 support
Message-ID: <20170924054652.nyszelz2xm3754dz@ast-mbp>
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
 <59C03AC5.3080109@iogearbox.net>
 <f7eb81db-a758-d49d-4c09-08a017b02e98@netronome.com>
 <20170921185654.v7nynvebxjpzbnlj@ast-mbp>
 <20170922182410.71701aee@cakuba>
 <1b6518ff-9d66-f911-4a3c-d762d88919ec@fb.com>
 <20170923104125.3905f545@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170923104125.3905f545@cakuba>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Yonghong Song <yhs@fb.com>, Jiong Wang <jiong.wang@netronome.com>, Daniel Borkmann <daniel@iogearbox.net>, xdp-newbies@vger.kernel.org, llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com

On Sat, Sep 23, 2017 at 10:41:25AM +0200, Jakub Kicinski wrote:
> > > Thinking about next steps - do we expect the 32b operations to clear the
> > > upper halves of the registers?  The interpreter does it, and so does
> > > x86.  I don't think we can load 32bit-only programs on 64bit hosts, so
> > > we would need some form of data flow analysis in the kernel to prune
> > > the zeroing for 32bit offload targets.  Is that correct?  
> > 
> > Could you contrive an example to show the problem? If I understand 
> > correctly, you most worried that some natural sign extension is gone
> > with "clearing the upper 32-bit register" and such clearing may make
> > some operation, esp. memory operation not correct in 64-bit machine?
> 
> Hm.  Perhaps it's a blunder on my side, but let's take:
> 
>   r1 = ~0ULL
>   w1 = 0
>   # use r1
> 
> on x86 and the interpreter, the w1 = 0 will clear upper 32bits, so r1
> ends up as 0.  32b arches may translate this to something like:
> 
>   # r1 = ~0ULL
>   r1.lo = ~0
>   r1.hi = ~0
>   # w1 = 0
>   r1.lo = 0
>   # r1.hi not touched
> 
> which will obviously result in r1 == 0xffffffff00000000.  LLVM should
> not assume r1.hi is cleared, but I'm not sure this is a strong enough
> argument.

llvm will assume that r1.hi is cleared. 32-bit subregisters were
defined on the day one. See Documentation/networking/filter.txt
"All eBPF registers are 64-bit with 32-bit lower
 subregisters that zero-extend into 64-bit if they are being written to."
If some JIT is not clearing upper bits, it's a bug or it's being too smart :)
We can add analysis pass to the verifier to help JITs in such case.
