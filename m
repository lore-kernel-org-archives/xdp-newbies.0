Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752159AbeADJ6N (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 4 Jan 2018 04:58:13 -0500
Date: Thu, 4 Jan 2018 10:58:07 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: CPU redirect and skb mode
Message-ID: <20180104105807.00363429@redhat.com>
In-Reply-To: <1515052793.7473.14.camel@regit.org>
References: <1515025109.7473.10.camel@regit.org>
        <20180104081500.73d55bd8@redhat.com>
        <1515052793.7473.14.camel@regit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Cc: xdp-newbies@vger.kernel.org, brouer@redhat.com

On Thu, 04 Jan 2018 08:59:53 +0100
Eric Leblond <eric@regit.org> wrote:

> Hello Jesper,
> 
> On Thu, 2018-01-04 at 08:15 +0100, Jesper Dangaard Brouer wrote:
> > On Thu, 04 Jan 2018 01:18:29 +0100 Eric Leblond <eric@regit.org>
> > wrote:
> >   
> > > Hello,
> > > 
> > > I'm currently working on implementing XDP CPU redirect map inside
> > > Suricata.
> > > 
> > > I've used CPU redirect map on my test laptop that has only skb mode
> > > available and my implementation was failing with result being
> > > almost
> > > all packets if not all were dropped.  
> > 
> > Remember that the tool xdp_monitor helps identify if XDP drops
> > packets.
> > (It's on my TODO list to expose the return values, until now I've
> > just
> > used the existing perf record/script to inspect the individual return
> > ERRNO's when I needed more details).
> > 
> > Maybe suricata should attach itself to the XDP error tracepoints, to
> > help the user experience?  
> 
> Gonna look at it and see if it is doable.

Notice that the xdp redirect tracepoints have an "_err" variant.  For
performance reasons, thus only attach to the xdp_redirect_{map_,}err
variants.

The current XDP tracepoints available are:

  $ perf list | grep xdp
  xdp:xdp_cpumap_enqueue                         [Tracepoint event]
  xdp:xdp_cpumap_kthread                         [Tracepoint event]
  xdp:xdp_exception                              [Tracepoint event]
  xdp:xdp_redirect                               [Tracepoint event]
  xdp:xdp_redirect_err                           [Tracepoint event]
  xdp:xdp_redirect_map                           [Tracepoint event]
  xdp:xdp_redirect_map_err                       [Tracepoint event]

It will be useful to attach to 'xdp:xdp_exception', as returning
XDP_ABORTED will activate this tracepoint, giving developers of XDP
programs an easy way to signal error cases in execution.


> >   
> > > So I decided to build the XPD sample and test them:
> > > 
> > > sudo ./xdp_redirect_cpu --debug -d wlan0  --cpu 4 -S  
> > 
> > I notice the -S option, which long option is --skb-mode.  
> 
> Yes, I don't have a network card with XDP enable driver available on my
> laptop.
> 
> > > The result was the same with packet blocked.
> > > 
> > > Am I missing something in the setup ?  
> > 
> > The cpumap redirect feature does not for for skb-mode. 

Typo (s/for/work) let me update the sentence:
 "The cpumap redirect feature does not work for skb-mode."

> > It's on my TODO-list to make it work for skb-mode, but I got
> > side-tracked after netconf (implementing xdp_rxq_info).  From a
> > performance PoV it goes against the basic idea of CPUMAP, which is to
> > move the SKB allocation to another CPU.  
> 
> I second that, this is just pointless.

I actually predict that it will still be faster than RPS, thus there is
still a performance argument for doing this. (I'm tempted to code it
up, just to see how much faster...)
 
> >   But for completeness sake I
> > will implement this, it just requires the cpumap-code handle both
> > xdp_buff's and SKB's in its queue.  
> 
> Or you could just error if ever a BOF with CPU redirect is used in a
> skb-mode ?

(Assuming typo: s/BOF/BPF)

Due to how eBPF+tailcalls and XDP-attach interact, we cannot detect and
reject the eBPF program at XDP-attach time.  Normally the eBPF program
gets loaded into the kernel _before_ attaching it to the driver
XDP-hook.  Which means we (at XDP-driver attach time) could simply walk
the eBPF program and maps to detect any use of cpumap. *BUT* due to
BPF-tailcalls new BPF-progs can be attached _after_ the XDP-attach step.
(I actually coded up a solution, that added XDP feature bits to
bpf-progs and bpf-maps, thus allowing to revalidate when attaching new
tailcalls... but it was too complex code)

For now, skb-mode using cpumap will result in a runtime tracepoint
(xdp:xdp_redirect_map_err) error event with errno-code: EBADRQC.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
