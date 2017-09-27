Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52672 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdI0Vis (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 27 Sep 2017 17:38:48 -0400
Message-ID: <59CC1A65.8040001@iogearbox.net>
Date: Wed, 27 Sep 2017 23:38:45 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: ANN: a different eBPF assembler
References: <f7dcba52-2696-aeac-891c-57cb9315c0eb@solarflare.com> <20170927180045.36oefowo67zpmocn@ast-mbp>
In-Reply-To: <20170927180045.36oefowo67zpmocn@ast-mbp>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Edward Cree <ecree@solarflare.com>
Cc: xdp-newbies@vger.kernel.org

On 09/27/2017 08:00 PM, Alexei Starovoitov wrote:
> On Wed, Sep 27, 2017 at 05:31:39PM +0100, Edward Cree wrote:
>> In recent weeks I've been developing an eBPF assembler, implemented in Python.  It can be found at https://github.com/solarflarecom/ebpf_asm and it consumes an Intel-like syntax very different to that consumed by LLVM or emitted by the kernel verifier's disassembler.
>
> It was a privilege to be the first star on your github :)

Very nice tool, I like it!

> The feedback I've received is that most bpf noobs cannot read asm, since they
> often come from non-kernel background, but there are niche users that like to
> see the ingredients of their soup.

So can we now have a flag when loading progs that selects
verifier level to 'Bring It On'? :-))
