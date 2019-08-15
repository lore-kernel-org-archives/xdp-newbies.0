Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38102 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731679AbfHOMO2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 15 Aug 2019 08:14:28 -0400
Received: by mail-lf1-f65.google.com with SMTP id h28so1499457lfj.5
        for <xdp-newbies@vger.kernel.org>; Thu, 15 Aug 2019 05:14:27 -0700 (PDT)
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next v2 0/3] xdpsock: allow mmap2 usage for 32bits
Date: Thu, 15 Aug 2019 15:13:53 +0300
Message-Id: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc: davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com, jakub.kicinski@netronome.com, daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org, jlemon@flugsvamp.com, yhs@fb.com, andrii.nakryiko@gmail.com, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

This patchset contains several improvements for af_xdp socket umem
mappings for 32bit systems. Also, there is one more patch outside of
this series that on linux-next tree and related to mmap2 af_xdp umem
offsets: "mm: mmap: increase sockets maximum memory size pgoff for 32bits"
https://lkml.org/lkml/2019/8/12/549

Based on bpf-next/master

Prev: https://lkml.org/lkml/2019/8/13/437

v2..v1:
	- replaced "libbpf: add asm/unistd.h to xsk to get __NR_mmap2" on
	 "libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2
	 syscall"
	- use vmap along with page_address to avoid overkill
	- define mmap syscall trace5 for mmap if defined

Ivan Khoronzhuk (3):
  libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2 syscall
  xdp: xdp_umem: replace kmap on vmap for umem map
  samples: bpf: syscal_nrs: use mmap2 if defined

 net/xdp/xdp_umem.c         | 36 +++++++++++++++++++++++-----
 samples/bpf/syscall_nrs.c  |  6 +++++
 samples/bpf/tracex5_kern.c | 13 ++++++++++
 tools/lib/bpf/Makefile     |  1 +
 tools/lib/bpf/xsk.c        | 49 +++++++++++---------------------------
 5 files changed, 64 insertions(+), 41 deletions(-)

-- 
2.17.1
