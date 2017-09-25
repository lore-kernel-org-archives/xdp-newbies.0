Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:46816 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934503AbdIYQCA (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 25 Sep 2017 12:02:00 -0400
Received: by mail-pg0-f41.google.com with SMTP id i130so4214134pgc.3
        for <xdp-newbies@vger.kernel.org>; Mon, 25 Sep 2017 09:02:00 -0700 (PDT)
Date: Mon, 25 Sep 2017 09:01:55 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: libbpf missing set_link_xdp_fd ?
Message-ID: <20170925160151.yplmezs2xqnqecxe@ast-mbp.dhcp.thefacebook.com>
References: <1506276431.21618.2.camel@regit.org>
 <20170925112502.1879734a@redhat.com>
 <59C8CF39.7030405@iogearbox.net>
 <59C8E22C.3000609@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59C8E22C.3000609@iogearbox.net>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Eric Leblond <eric@regit.org>, xdp-newbies@vger.kernel.org, wangnan0@huawei.com, Daniel Borkmann <borkmann@iogearbox.net>

On Mon, Sep 25, 2017 at 01:02:04PM +0200, Daniel Borkmann wrote:
> On 09/25/2017 11:41 AM, Daniel Borkmann wrote:
> > On 09/25/2017 11:25 AM, Jesper Dangaard Brouer wrote:
> > > On Sun, 24 Sep 2017 20:07:11 +0200
> > > Eric Leblond <eric@regit.org> wrote:
> > > 
> > > > Hello,
> > > > 
> > > > bpf_load is implementing the set_link_xdp_fd() function and it seems
> > > > this function is not available in libbpf.
> > > 
> > > I also ran into this problem, when I wanted to switch my XDP programs
> > > into using tools/lib/bpf/.
> > 
> > Right.
> > 
> > > E.g.: https://github.com/netoptimizer/prototype-kernel/commit/5397e596c30416763
> > > 
> > > > Should it be the case or should it be part of another library ?
> > > 
> > > I'm not sure... maybe Alexei, Daniel or Wang have an opinion?
> > 
> > It seems that none of the actual attach infra is handled in
> > tools/lib/bpf/, meaning neither attaching the fd to kprobes/
> > uprobes/tracepoints nor tc or xdp, so adding a special case
> > only for xdp into the lib feels that we probably might be better
> > off putting this either into its own mini lib on top of that,
> 
> That could potentially go to tools/lib/xdp/, probably would be
> the best option.

I'm afraid it may spiral out of control.
If we create such dirs, we'd need one for xdp, tc, cgroup, tracepoint, kprobe.
Differentiating the libraries by type of attach point is imo too fine grained.

Why not to put everything into toos/lib/bpf ?
New file for netlink stuff is easy enough and we can gatekeep it with
some knob in the Makefile, so perf build won't need to include it.
