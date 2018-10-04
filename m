Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbeJECjn (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 4 Oct 2018 22:39:43 -0400
Date: Thu, 4 Oct 2018 21:44:52 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: AF_XDP umem and jumbo frames?
Message-ID: <20181004214452.3045c356@redhat.com>
In-Reply-To: <CAFg6Rxt6Xdhzwb41uPOWaihhLYV2Gf69D=XLCt=wyQ1Vc6YwFA@mail.gmail.com>
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
        <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
        <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
        <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
        <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
        <20181004095233.5430b87c@redhat.com>
        <CAFg6Rxt6Xdhzwb41uPOWaihhLYV2Gf69D=XLCt=wyQ1Vc6YwFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Rob Sherwood <rob.sherwood@gmail.com>
Cc: bjorn.topel@gmail.com, aforster@cloudflare.com, Justin Azoff <justin.azoff@gmail.com>, xdp-newbies@vger.kernel.org, magnus.karlsson@intel.com, brouer@redhat.com

On Thu, 4 Oct 2018 08:47:45 -0700
Rob Sherwood <rob.sherwood@gmail.com> wrote:

> [not speaking for my current employer, but just from past experience ]
> 
> Certainly a lot of the 'hard' requirements (hard meaning - "without
> this it won't work")  I've seen could be served with a ~3k non-full
> jumbo frame. 

Glad to hear that _most_ use-cases can be solved with a ~3k non-full
jumbo-frame.

> But at least what I've seen in the past was that because
> many of the host-side operations are per-packet limited (e.g., because
> of CPU or RAM, but ultimately turns into a max pps per host), a
> trivial way to increase application performance/reduce CPU for
> networking was to run at as large a frame size as possible.  For
> example, if your application/host is really pps limited, then getting
> the frame size to increase from 3k to 9k means either 3x more
> bandwidth for the same cpu usage (assuming the application is
> bandwidth limited) or 1/3x the CPU usage for the same bandwidth (if
> the application is not bandwidth limited).  Either way, IMHO it's a
> pretty big win.

With XDP we have basically solved the issue of being PPS (packets per
sec) limited.  And we can avoid these workarounds of using jumbo frames.
That is why it is a bit provoking to ask for jumbo-frames ;-)


People on this list might not realize that there is a significant
overhead in supporting larger that 4K frames for XDP, that is larger
than one memory-page. So let me explain...

It is actually trivially easy for XDP to support jumbo frames, if the
NIC hardware supports storing RX frames into higher order pages (aka
compound pages, more 4K pages physically after each-other) which most
HW does. (Page order0 = 4KB, order1=8KB, order2=16KB, order3=32KB).
As then XDP will work out-of-the-box, as the requirement is really that
packet-payload is layout as phys continuous memory.

Kernel page allocator can give us high-order pages, sure, but is cost
more, see slide 12 of [1].  The large jump to order-1, is because
order-0 have a Per-Cpu-Pages (PCP) cache.  From order-1 and above, the
page allocator goes through a central (per NUMA) lock, which makes
thing even worse, as this does not scale to multiple CPUs.  And there
is also the point of wasting memory when processing 64Byte packets.
So, it is not 100% of the picture, that we could support jumbo-frames
for XDP.  Mostly because we can workaround this cost/issue, by having
recycle caches for these pages, which we even do for order-0 pages.
Hint, I actually left this door open, as you can specify page-order
when setting up the page_pool API in the driver...

[1] http://people.netfilter.org/hawk/presentations/MM-summit2017/MM-summit2017-JesperBrouer.pdf

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer




> On Thu, Oct 4, 2018 at 12:52 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Thu, 4 Oct 2018 08:44:27 +0200
> > Björn Töpel <bjorn.topel@gmail.com> wrote:
> >  
> > > Den tors 27 sep. 2018 kl 02:56 skrev Rob Sherwood <rob.sherwood@gmail.com>:  
> > > >
> > > > Thanks for the reference and the page-per-packet point makes sense.
> > > > At the same time, not supporting jumbo frames seems like a non-trivial
> > > > limitation.  Are there a subset of drivers that do support jumbo
> > > > frames (or LRO or the other features that require multiple pages per
> > > > packet)?
> > > >  
> > >
> > > No, not at the moment. XDP has a strict "one frame cannot exceed a
> > > page" constraint. Everything that applies to XDP in terms of
> > > constraints, applies to AF_XDP as well.
> > >
> > > Just to clarify, XDP supports jumbo frames -- i.e. larger than 1500B
> > > payload, just not the maximum 9000B size. My personal observation is
> > > that many deployments that "require jumbo frames", are usually OK with
> > > an of MTU ~3000B. Jumbo frames, yes. Full jumbo frames, no. :-)  
> >
> > Thank you for clarifying that Bjørn.
> >
> > Can Alex or Rob explain:
> >
> > (1) What is your use-case for wanting jumbo-frames?
> >
> > And (2) will an MTU of ~3000Bytes be sufficient? (which XDP does support)
> >
> >  
> > > > On Tue, Sep 25, 2018 at 9:44 AM Alex Forster <aforster@cloudflare.com> wrote:  
> > > > >  
> > > > > > On my test box running 4.18 if XDP is in use the MTU can not be
> > > > > > set higher than 3050.  
> > > > >
> > > > > Ah, that answers a few questions for me. Thanks!
> > > > >
> > > > > Alex Forster  
> >
> > --
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer  
