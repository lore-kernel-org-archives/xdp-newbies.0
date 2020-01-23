Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726260AbgAWMau (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 23 Jan 2020 07:30:50 -0500
Date: Thu, 23 Jan 2020 13:30:33 +0100
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Subject: Re: Measuring/Debugging XDP Performance
Message-ID: <20200123133033.5398e848@carbon>
In-Reply-To: <alpine.OSX.2.21.2001221405250.1261@jiadeimac.local>
References: <6c3dc8ff-e2bd-a06e-d9f0-c5be0103d266@gflclan.com>
        <alpine.OSX.2.21.2001221405250.1261@jiadeimac.local>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Vincent Li <mchun.li@gmail.com>
Cc: Christian Deacon <gamemann@gflclan.com>, xdp-newbies@vger.kernel.org

On Wed, 22 Jan 2020 14:11:07 -0800 (PST)
Vincent Li <mchun.li@gmail.com> wrote:

> On Wed, 22 Jan 2020, Christian Deacon wrote:
> 
> > Hey everyone,
> > 
> > I am new to XDP + AF_XDP (along with C programming in general), but I am very
> > interested in it and I've been learning a lot recently. I own an Anycast
> > network and our POP servers are running custom software our developer created
> > that processes packets using XDP. This software basically forwards specific
> > traffic to another machine via an IPIP tunnel. One issue I've been noticing is
> > the packets our software is processing and forwarding to another machine keep
> > dropping at higher traffic loads. I can't tell if this is dropping at the POP
> > level or if the machine the software is forwarding this specific traffic to
> > is. I've even tried upgrading the POP server from a two-core VPS (2.5 GHz
> > CPUs) to a dedicated server (Intel E3-1230v6 @ 3.5 GHz, 4 cores, and 8
> > threads). If this is being dropped at the POP level, I'm wondering if the
> > software is being limited to one core on this specific POP (other POPs are
> > able to use more than one core specifically). However, I have no way to
> > confirm that. To my understanding XDP programs should be able to use more than
> > one core.
> > 
> > My questions are the following:
> > 
> > 1. Is there a way to see how much CPU the XDP program is using or the load of
> > the NIC? To my understanding, you cannot tell the XDP program's CPU usage
> > based off of something like `top` or `htop` due to that being in the user
> > space (XDP happens at the NIC driver level in the kernel IIRC).  
> 
> I am newbie in XDP too, maybe Linux 
> Perf http://www.brendangregg.com/perf.html tool could help you figuring 
> out which part of the code in your XDP app consuming CPU cycles (debug 
> symbol needed)


I agree start with the 'perf' command line tool to look at the issue. 
As this is likely a CPU load distribution issue, let me give you are
couple of perf commands to use.

First record system wide (-a) entire system for 10 sec:

  perf record -g -a sleep 10

Look at what happened:

  perf report --no-children

Now you also want to look at this per CPU:

  perf report --no-children --sort cpu,comm,dso,symbol

If you want to send some info about your perf report results via email,
you can use the --stdio parameter to get the plain text output.

Once you have completed this quest, I'll help you with some more
advanced commands... does you distro have 'bpftrace' ?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
