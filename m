Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:60916 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753173AbdGMUpI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jul 2017 16:45:08 -0400
Message-ID: <5967DBC3.5060509@iogearbox.net>
Date: Thu, 13 Jul 2017 22:44:51 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: XDP for Kernel by-pass?
References: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be>
In-Reply-To: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: tom.barbette@ulg.ac.be
Cc: xdp-newbies@vger.kernel.org

On 07/13/2017 09:34 PM, tom.barbette@ulg.ac.be wrote:
> Hi all,
>
> Can XDP be used for "skbuff bypass"? Like a rx_handler but closer to the driver? I'm not very familiar with eBPF, could it be used to pass the kernel to any kernel module or userspace application?
>
> It looks to me that bpf_func in struct bpf_prog could be any function that we could use to deviate XDP and use it for that purpose. Correct?
>
> Kernel app like Click or OVS could benefit from that as they don't use most skbuff facilities.

You can do a lot of things with eBPF already e.g. take a look at the kernel
BPF sample code or BPF selftests e.g. test_l4lb.c, test_xdp.c, etc, or
projects like cilium that get compiled from C to BPF bytecode. BPF and XDP
is heavily tied together and part of the core kernel, so modular code/hooks
like third party kernel modules are not possible. Also f.e. wrt to user space
one of the use cases is that you don't need to cross boundaries in the first
place when you preprocess in XDP and e.g. apply policy to drop unrelated
packets early while remaining ones are forwarded to containers, etc. There's
wip to have an OVS data path in BPF/XDP. I currently don't find the slides,
but Quentin did a good coverage on it from the last workshop [1], so worth
to read up a bit on the topic.

   [1] https://qmonnet.github.io/whirl-offload/2017/03/03/iovisor-summit-summary/

> Thanks,
>
> Tom
>
