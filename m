Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726060AbgDYM4c (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 25 Apr 2020 08:56:32 -0400
Date: Sat, 25 Apr 2020 14:56:19 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: building eBPF
Message-ID: <20200425145619.4405a50d@carbon>
In-Reply-To: <20200425122225.GA455@gmail.com>
References: <20200425122225.GA455@gmail.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Sowmini Varadhan <sowmini05@gmail.com>
Cc: brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>


Cc XDP-newbies, as I cannot scale by doing individual "support".

On Sat, 25 Apr 2020 08:22:25 -0400 Sowmini Varadhan <sowmini05@gmail.com> wrote:

> Hi Jesper, 
> 
> I am trying to get some basic eBPF examples up and running and I ran
> into the problem you describe at https://lkml.org/lkml/2020/2/19/433

Yes, building kernel bpf selftests requires latest LLVM, currently
works with LLVM-10.

> I dont want to deal with building my own llvm (looks like it needs
> more disk space than is available in my test mmachine, and I dont
> want to go hunting for space just yet) so do you have some suggestions
> on how I can work around this (maybe skip some of the advanced
> tests?

The kernel's samples/bpf/ should still builds with LLVM-9 (and lower).
Follow instructions in the README.rst file[1].

There are pre-build Debian and Ubuntu packages for LLVM-10 here:
 https://apt.llvm.org/

> I am just trying to play with basic examples at this point)

I suggest you start with the XDP-tutorial[2], it (still) works with older
LLVM versions: [2] https://github.com/xdp-project/xdp-tutorial


[1] https://github.com/torvalds/linux/blob/master/samples/bpf/README.rst
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
