Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:52486 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdI0SAw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Sep 2017 14:00:52 -0400
Received: by mail-pf0-f181.google.com with SMTP id p87so7623591pfj.9
        for <xdp-newbies@vger.kernel.org>; Wed, 27 Sep 2017 11:00:51 -0700 (PDT)
Date: Wed, 27 Sep 2017 11:00:46 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: ANN: a different eBPF assembler
Message-ID: <20170927180045.36oefowo67zpmocn@ast-mbp>
References: <f7dcba52-2696-aeac-891c-57cb9315c0eb@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7dcba52-2696-aeac-891c-57cb9315c0eb@solarflare.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Edward Cree <ecree@solarflare.com>
Cc: xdp-newbies@vger.kernel.org

On Wed, Sep 27, 2017 at 05:31:39PM +0100, Edward Cree wrote:
> In recent weeks I've been developing an eBPF assembler, implemented in Python.  It can be found at https://github.com/solarflarecom/ebpf_asm and it consumes an Intel-like syntax very different to that consumed by LLVM or emitted by the kernel verifier's disassembler.

It was a privilege to be the first star on your github :)

The feedback I've received is that most bpf noobs cannot read asm, since they
often come from non-kernel background, but there are niche users that like to
see the ingredients of their soup.
