Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbeJDOom (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 4 Oct 2018 10:44:42 -0400
Date: Thu, 4 Oct 2018 09:52:33 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: AF_XDP umem and jumbo frames?
Message-ID: <20181004095233.5430b87c@redhat.com>
In-Reply-To: <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
References: <CAKxSbF09EOU4nvNLaVmMqb7hE-ZrKMd7SC+rVEAqeasG2HGRKg@mail.gmail.com>
        <CAJL276DCPNAB_s=ZPHAbanWjQ4rGvo_rKJG+yxa1dP+-OCBfpw@mail.gmail.com>
        <CAKxSbF0yn0s5JEbWsF65uwEB6sCThhvJ8kpuOVCNaf=diFxjyA@mail.gmail.com>
        <CAFg6RxsSRzww4f3n6xH1gRWQfXhhHkk0oZNSWNc6+kHT0p_VeQ@mail.gmail.com>
        <CAJ+HfNivt8pQN_FjA2DauCXNemW-ZT3pHxQFGCt2eHi592GXhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc: rob.sherwood@gmail.com, aforster@cloudflare.com, justin.azoff@gmail.com, xdp-newbies@vger.kernel.org, "Karlsson, Magnus" <magnus.karlsson@intel.com>, brouer@redhat.com

On Thu, 4 Oct 2018 08:44:27 +0200
Björn Töpel <bjorn.topel@gmail.com> wrote:

> Den tors 27 sep. 2018 kl 02:56 skrev Rob Sherwood <rob.sherwood@gmail.com>:
> >
> > Thanks for the reference and the page-per-packet point makes sense.
> > At the same time, not supporting jumbo frames seems like a non-trivial
> > limitation.  Are there a subset of drivers that do support jumbo
> > frames (or LRO or the other features that require multiple pages per
> > packet)?
> >  
> 
> No, not at the moment. XDP has a strict "one frame cannot exceed a
> page" constraint. Everything that applies to XDP in terms of
> constraints, applies to AF_XDP as well.
> 
> Just to clarify, XDP supports jumbo frames -- i.e. larger than 1500B
> payload, just not the maximum 9000B size. My personal observation is
> that many deployments that "require jumbo frames", are usually OK with
> an of MTU ~3000B. Jumbo frames, yes. Full jumbo frames, no. :-)

Thank you for clarifying that Bjørn.

Can Alex or Rob explain:
 
(1) What is your use-case for wanting jumbo-frames?
 
And (2) will an MTU of ~3000Bytes be sufficient? (which XDP does support)


> > On Tue, Sep 25, 2018 at 9:44 AM Alex Forster <aforster@cloudflare.com> wrote:  
> > >  
> > > > On my test box running 4.18 if XDP is in use the MTU can not be
> > > > set higher than 3050.  
> > >
> > > Ah, that answers a few questions for me. Thanks!
> > >
> > > Alex Forster  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
