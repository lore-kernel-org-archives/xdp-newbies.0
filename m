Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46204 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgAZExG (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 25 Jan 2020 23:53:06 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so3376456pgb.13
        for <xdp-newbies@vger.kernel.org>; Sat, 25 Jan 2020 20:53:06 -0800 (PST)
Message-ID: <03dce571f7c17726938daaf0fa576d75b2a5f90f.camel@coverfire.com>
Subject: Re: zero-copy between interfaces
From: Dan Siemon <dan@coverfire.com>
Date: Sat, 25 Jan 2020 23:53:00 -0500
In-Reply-To: <20200118140857.GA9363@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
         <20200113124134.3974cbed@carbon> <20200113152759.GD68570@smtp.ads.isi.edu>
         <20200113180411.24d8bd40@carbon> <20200117175409.GC69024@smtp.ads.isi.edu>
         <20200118111405.28fd1c75@carbon> <20200118140857.GA9363@smtp.ads.isi.edu>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Ryan Goodfellow <rgoodfel@isi.edu>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Sat, 2020-01-18 at 09:08 -0500, Ryan Goodfellow wrote:
> On Sat, Jan 18, 2020 at 11:14:05AM +0100, Jesper Dangaard
> Brouerwrote:
> > 
> > I'm wondering why did you choose/need AF_XDP technology for doing
> > forwarding?
> 
> This is just a sample program used to demonstrate moving packets
> between
> different interfaces efficiently using AF_XDP.
> 
> Our actual use case is performing network emulation in userspace. For
> example,
> representing impaired links or entire networks with link-by-link
> shaping
> specifications. We are using AF_XDP to get packets to/from our
> network emulation
> software as quickly as possible without having to go through the
> entire network
> stack, as the emulation host's network configuration does not
> influence the
> networks it's emulating.
> 
> Traditionally we've used DPDK for this, but are porting to AF_XDP for
> the 
> relative simplicity and flexibility it provides. Some specific
> benefits for us
> are:
> 
> - Can attach to VTEPs which allows us to hook into some EVPN/VXLAN
> based
>   networks we have easily. Alternatively with the BPF program
> flexibility, we
>   also have the option to split out BGP control plane traffic from
> overlay
>   traffic when attaching to the physical interface and pass it
> through to the 
>   kernel. Both of these approaches let the kernel manage the FDB for
> VTEPs as 
>   well as taking care of encap/decap (potentially offloaded to the
> NIC itself) 
>   and let our software focus on emulation.
> 
> - Using XDP in virtual machines in our testing environment is
> straightforward,
>   while this is possible with DPDK and virtio, the setup was rather
> convoluted.

I'm in a very similar situation. The per-packet work we do is
complicated. Doing it all in BPF would be much more painful if even
possible. For us, AF_XDP is a nice, simple DPDK. We have no need for
BPF in the AF_XDP path.
