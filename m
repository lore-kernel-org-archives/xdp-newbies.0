Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbdECHv7 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 3 May 2017 03:51:59 -0400
Date: Wed, 3 May 2017 09:51:53 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: BPF Updates 01
Message-ID: <20170503095153.561ed64d@redhat.com>
In-Reply-To: <20170503045432.GB19919@gmail.com>
References: <20170503045432.GB19919@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Alexander Alemayhu <alexander@alemayhu.com>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com


On Wed, 3 May 2017 06:54:32 +0200 Alexander Alemayhu <alexander@alemayhu.com> wrote:

> I have started writing a short weekly roundup on the various BPF related
> activity. The first issue 
> https://www.cilium.io/blog/2017/5/2/bpf-updates-01-2017-05-02
> 
> The main motivation is to have something similar to LLVM Weekly[0] and This
> week in Swift[1]. Hopefully useful for people hungry after more BPF related
> content without wanting to subscribe to netdev or filtering through lkml.
> 
> The second issue is already in the works and will be sent to the list
> sometime next week. If you have any feedback, that would very
> appreciated.

This is great thanks for sharing.

I also want to point to this cilium blogpost:
 https://www.cilium.io/blog/2017/4/24/launch-of-bpf-xdp-documentation

eBPF is sort of the XDP programming language, and if you want to learn
the details of the BPF Architecture and know more about the instruction
set, follow the blogpost link to: http://docs.cilium.io/en/latest/bpf/

I believe people subscribed to this list is more interested in having a
toolchain like LLVM that allow us to write (restricted) C-code and
generate the eBPF assembler for us. Luckily the same document describes
how this works and why e.g. inlining is required, here:

 http://docs.cilium.io/en/latest/bpf/#toolchain

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


> [0]: http://llvmweekly.org/issue/174
> [1]: https://swiftnews.curated.co/
