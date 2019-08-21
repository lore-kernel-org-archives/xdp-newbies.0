Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:42416 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfHUMfc (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 21 Aug 2019 08:35:32 -0400
Subject: Re: [PATCH bpf-next v2 0/3] xdpsock: allow mmap2 usage for 32bits
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <95fb201c-1623-149b-a72e-ed4860f742e1@iogearbox.net>
Date: Wed, 21 Aug 2019 14:35:19 +0200
MIME-Version: 1.0
In-Reply-To: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc: davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org, jlemon@flugsvamp.com, yhs@fb.com, andrii.nakryiko@gmail.com

On 8/15/19 2:13 PM, Ivan Khoronzhuk wrote:
> This patchset contains several improvements for af_xdp socket umem
> mappings for 32bit systems. Also, there is one more patch outside of
> this series that on linux-next tree and related to mmap2 af_xdp umem
> offsets: "mm: mmap: increase sockets maximum memory size pgoff for 32bits"
> https://lkml.org/lkml/2019/8/12/549
> 
> Based on bpf-next/master
> 
> Prev: https://lkml.org/lkml/2019/8/13/437
> 
> v2..v1:
> 	- replaced "libbpf: add asm/unistd.h to xsk to get __NR_mmap2" on
> 	 "libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2
> 	 syscall"
> 	- use vmap along with page_address to avoid overkill
> 	- define mmap syscall trace5 for mmap if defined
> 
> Ivan Khoronzhuk (3):
>    libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2 syscall
>    xdp: xdp_umem: replace kmap on vmap for umem map
>    samples: bpf: syscal_nrs: use mmap2 if defined
> 
>   net/xdp/xdp_umem.c         | 36 +++++++++++++++++++++++-----
>   samples/bpf/syscall_nrs.c  |  6 +++++
>   samples/bpf/tracex5_kern.c | 13 ++++++++++
>   tools/lib/bpf/Makefile     |  1 +
>   tools/lib/bpf/xsk.c        | 49 +++++++++++---------------------------
>   5 files changed, 64 insertions(+), 41 deletions(-)
> 

Applied, and fixed up typo in last one's subject, thanks!
