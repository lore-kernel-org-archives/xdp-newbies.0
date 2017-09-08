Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932289AbdIHHpb (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 8 Sep 2017 03:45:31 -0400
Date: Fri, 8 Sep 2017 09:45:25 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel
 bpf restricted C
Message-ID: <20170908094525.7b05dcf9@redhat.com>
In-Reply-To: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kiran T <kiran.lkml@gmail.com>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com

On Thu, 7 Sep 2017 14:37:42 -0700 Kiran T <kiran.lkml@gmail.com> wrote:

> The samples and test cases have examples showing how user space
> programs can pin maps and get pinned maps as FDs.  However, how would
> one access a user-space created pinned map from kernel space, without
> having to statically have a 'maps' section defined (and depend on the
> elf loader)?

Reading further in the thread, I do realize that you have special or
strange use case that is hard/impossible with bpf, as the map type is
needed at bpf load/verifier time.

(IMHO) A more common issue is: asking how can I change/update an
BPF-elf-object-file to use another bpf-map at load-time?

The use-case behind this question is:  I have pinned bpf-map accessible
via the filesystem (bpffs), and I want several BPF programs to
share-and-use this map (on the kernel side).

This is what I'm doing in my xdp_ddos01 example[1].  You can load
xdp_ddos01 on several NICs and they will all share and use the same
blacklist-maps. I've highlighted the code here[1]:

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samples/bpf/xdp_ddos01_blacklist_user.c#L186-L218

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
