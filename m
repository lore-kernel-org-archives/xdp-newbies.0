Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388405AbfBMLzm (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 13 Feb 2019 06:55:42 -0500
Date: Wed, 13 Feb 2019 12:55:30 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next v4 0/2] libbpf: adding AF_XDP support
Message-ID: <20190213125530.4a7fb8bc@carbon>
In-Reply-To: <CAJ8uoz19UjmEHTc28Qd_9KdY9D-ojXSBRTbmffRhUTX49mnWvg@mail.gmail.com>
References: <1549631126-29067-1-git-send-email-magnus.karlsson@intel.com>
        <36557463-D23A-432E-AA18-7731F43CEBA6@gmail.com>
        <CAJ8uoz19UjmEHTc28Qd_9KdY9D-ojXSBRTbmffRhUTX49mnWvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>, Magnus Karlsson <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, ast@kernel.org, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, Jakub Kicinski <jakub.kicinski@netronome.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>, "Zhang, Qi Z" <qi.z.zhang@intel.com>, xiaolong.ye@intel.com, brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Wed, 13 Feb 2019 12:32:47 +0100
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> On Mon, Feb 11, 2019 at 9:44 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On 8 Feb 2019, at 5:05, Magnus Karlsson wrote:
> >  
> > > This patch proposes to add AF_XDP support to libbpf. The main reason
> > > for this is to facilitate writing applications that use AF_XDP by
> > > offering higher-level APIs that hide many of the details of the AF_XDP
> > > uapi. This is in the same vein as libbpf facilitates XDP adoption by
> > > offering easy-to-use higher level interfaces of XDP
> > > functionality. Hopefully this will facilitate adoption of AF_XDP, make
> > > applications using it simpler and smaller, and finally also make it
> > > possible for applications to benefit from optimizations in the AF_XDP
> > > user space access code. Previously, people just copied and pasted the
> > > code from the sample application into their application, which is not
> > > desirable.  
> >
> > I like the idea of encapsulating the boilerplate logic in a library.
> >
> > I do think there is an important missing piece though - there should be
> > some code which queries the netdev for how many queues are attached, and
> > create the appropriate number of umem/AF_XDP sockets.
> >
> > I ran into this issue when testing the current AF_XDP code - on my test
> > boxes, the mlx5 card has 55 channels (aka queues), so when the test program
> > binds only to channel 0, nothing works as expected, since not all traffic
> > is being intercepted.  While obvious in hindsight, this took a while to
> > track down.  
> 
> Yes, agreed. You are not the first one to stumble upon this problem
> :-). Let me think a little bit on how to solve this in a good way. We
> need this to be simple and intuitive, as you say.

I see people hitting this with AF_XDP all the time... I had some
backup-slides[2] in our FOSDEM presentation[1] that describe the issue,
give the performance reason why and propose a workaround.

[1] https://github.com/xdp-project/xdp-project/tree/master/conference/FOSDEM2019
[2] https://github.com/xdp-project/xdp-project/blob/master/conference/FOSDEM2019/xdp_building_block.org#backup-slides

Alternative work-around
  * Create as many AF_XDP sockets as RXQs
  * Have userspace poll()/select on all sockets

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

* Backup Slides                                                      :export:

** Slide: Where does AF_XDP performance come from?                  :export:

/Lock-free [[https://lwn.net/Articles/169961/][channel]] directly from driver RX-queue into AF_XDP socket/
- Single-Producer/Single-Consumer (SPSC) descriptor ring queues
- *Single*-/Producer/ (SP) via bind to specific RX-*/queue id/*
  * NAPI-softirq assures only 1-CPU process 1-RX-queue id (per sched)
- *Single*-/Consumer/ (SC) via 1-Application
- *Bounded* buffer pool (UMEM) allocated by userspace (register with kernel)
  * Descriptor(s) in ring(s) point into UMEM
  * /No memory allocation/, but return frames to UMEM in timely manner
- [[http://www.lemis.com/grog/Documentation/vj/lca06vj.pdf][Transport signature]] Van Jacobson talked about
  * Replaced by XDP/eBPF program choosing to XDP_REDIRECT

** Slide: Details: Actually *four* SPSC ring queues                 :export:

AF_XDP /socket/: Has /two rings/: *RX* and *TX*
 - Descriptor(s) in ring points into UMEM
/UMEM/ consists of a number of equally sized chunks
 - Has /two rings/: *FILL* ring and *COMPLETION* ring
 - FILL ring: application gives kernel area to RX fill
 - COMPLETION ring: kernel tells app TX is done for area (can be reused)

** Slide: Gotcha by RX-queue id binding                             :export:

AF_XDP bound to */single RX-queue id/* (for SPSC performance reasons)
- NIC by default spreads flows with RSS-hashing over RX-queues
  * Traffic likely not hitting queue you expect
- You *MUST* configure NIC *HW filters* to /steer to RX-queue id/
  * Out of scope for XDP setup
  * Use ethtool or TC HW offloading for filter setup
- *Alternative* work-around
  * /Create as many AF_XDP sockets as RXQs/
  * Have userspace poll()/select on all sockets
