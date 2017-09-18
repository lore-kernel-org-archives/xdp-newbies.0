Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:50948 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdIRV3p (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 18 Sep 2017 17:29:45 -0400
Message-ID: <59C03AC5.3080109@iogearbox.net>
Date: Mon, 18 Sep 2017 23:29:41 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC 0/4] Initial 32-bit eBPF encoding support
References: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1505767641-40512-1-git-send-email-jiong.wang@netronome.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, llvm-dev@lists.llvm.org, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, ys114321@gmail.com

On 09/18/2017 10:47 PM, Jiong Wang wrote:
> Hi,
>
>    Currently, LLVM eBPF backend always generate code in 64-bit mode, this may
> cause troubles when JITing to 32-bit targets.
>
>    For example, it is quite common for XDP eBPF program to access some packet
> fields through base + offset that the default eBPF will generate BPF_ALU64 for
> the address formation, later when JITing to 32-bit hardware, BPF_ALU64 needs
> to be expanded into 32 bit ALU sequences even though the address space is
> 32-bit that the high bits is not significant.
>
>    While a complete 32-bit mode implemention may need an new ABI (something like
> -target-abi=ilp32), this patch set first add some initial code so we could
> construct 32-bit eBPF tests through hand-written assembly.
>
>    A new 32-bit register set is introduced, its name is with "w" prefix and LLVM
> assembler will encode statements like "w1 += w2" into the following 8-bit code
> field:
>
>      BPF_ADD | BPF_X | BPF_ALU
>
> BPF_ALU will be used instead of BPF_ALU64.
>
>    NOTE, currently you can only use "w" register with ALU statements, not with
> others like branches etc as they don't have different encoding for 32-bit
> target.

Great to see work in this direction! Can we also enable to use / emit
all the 32bit BPF_ALU instructions whenever possible for the currently
available bpf targets while at it (which only use BPF_ALU64 right now)?

Thanks,
Daniel

> *** BLURB HERE ***
>
> Jiong Wang (4):
>    Improve instruction encoding descriptions
>    Improve class inheritance in instruction patterns
>    New 32-bit register set
>    Initial 32-bit ALU (BPF_ALU) encoding support in assembler
>
>   lib/Target/BPF/BPFInstrFormats.td               |  84 +++-
>   lib/Target/BPF/BPFInstrInfo.td                  | 506 +++++++++++-------------
>   lib/Target/BPF/BPFRegisterInfo.td               |  74 +++-
>   lib/Target/BPF/Disassembler/BPFDisassembler.cpp |  15 +
>   test/MC/BPF/insn-unit-32.s                      |  53 +++
>   5 files changed, 427 insertions(+), 305 deletions(-)
>   create mode 100644 test/MC/BPF/insn-unit-32.s
>
