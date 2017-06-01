Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdFAQ7x (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 1 Jun 2017 12:59:53 -0400
Date: Thu, 1 Jun 2017 18:59:34 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: Running Prototype-kernel package
Message-ID: <20170601185934.73ab06a4@redhat.com>
In-Reply-To: <CAErYV9HG9H=62DL49qY1iewshx3NcMqAq6u3O=RsYEWdZp3Hjw@mail.gmail.com>
References: <CAErYV9HG9H=62DL49qY1iewshx3NcMqAq6u3O=RsYEWdZp3Hjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Adel Fuchs <adelfuchs@gmail.com>
Cc: xdp-newbies@vger.kernel.org, iovisor-dev@lists.iovisor.org, brouer@redhat.com


On Thu, 1 Jun 2017 17:45:03 +0300 Adel Fuchs <adelfuchs@gmail.com> wrote:

> Thank you so much for your help. I need to run an eBPF programs that
> filters packets according to IP address or port. I'm trying to run the
> prototype-kernel package but encounter problems.

The prototype-kernel github repo[1] is actually originally meant for
developing real kernel module.  I guess, I should/could have placed the
eBPF/XDP examples[3] in another github repo.

[1] https://github.com/netoptimizer/prototype-kernel
[2] http://netoptimizer.blogspot.dk/2014/11/announce-github-repo-prototype-kernel.html
[3] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/samples/bpf

> I went over the "getting started" tutorial, but I couldn'f find a
> tutorial which explains how to actually run the samples. So this is
> what I did:
> 
> clang -O2 -Wall -target bpf -c xdp_ddos01_blacklist_cmdline.c -o
> xdp_ddos01_blacklist_cmdline

Don't do this... as you found out all the included path are screwed
this way.  There is a Makefile in the directory[3] kernel/samples/bpf,
so simply chdir into this dir and run 'make'.  Just like you would do
in the kernel tree[4].

[4] https://github.com/torvalds/linux/blob/master/samples/bpf/README.rst

[...] 
> Could you please help me run these samples? Could you please guide me
> to the right sample that I need and tell me how to run it?
> Note that I was able to run a simple XDP program on this computer, so
> I think that it is configured all right...

I've also been touring with a tutorial talk, see latest here[5]

[5] http://people.netfilter.org/hawk/presentations/LLC2017/XDP_DDoS_protecting_LLC2017.pdf

I guess, I'll update the documentation a bit after your feedback,
thanks.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
