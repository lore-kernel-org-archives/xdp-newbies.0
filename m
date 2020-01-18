Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48229 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726831AbgARKOS (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 18 Jan 2020 05:14:18 -0500
Date: Sat, 18 Jan 2020 11:14:05 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: zero-copy between interfaces
Message-ID: <20200118111405.28fd1c75@carbon>
In-Reply-To: <20200117175409.GC69024@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
        <20200113124134.3974cbed@carbon>
        <20200113152759.GD68570@smtp.ads.isi.edu>
        <20200113180411.24d8bd40@carbon>
        <20200117175409.GC69024@smtp.ads.isi.edu>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Ryan Goodfellow <rgoodfel@isi.edu>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, brouer@redhat.com

On Fri, 17 Jan 2020 12:54:09 -0500
Ryan Goodfellow <rgoodfel@isi.edu> wrote:

> On Mon, Jan 13, 2020 at 06:04:11PM +0100, Jesper Dangaard Brouer wrote:
> > On Mon, 13 Jan 2020 10:28:00 -0500
> > Ryan Goodfellow <rgoodfel@isi.edu> wrote:
> >   
> > > On Mon, Jan 13, 2020 at 12:41:34PM +0100, Jesper Dangaard Brouer wrote:  
> > > > On Mon, 13 Jan 2020 00:18:36 +0000
> > > > Ryan Goodfellow <rgoodfel@isi.edu> wrote:
> > > >     
> > > > > The numbers that I have been able to achive with this code are the following. MTU
> > > > > is 1500 in all cases.
> > > > > 
> > > > >     mlx5: pps ~ 2.4 Mpps, 29 Gbps (driver mode, zero-copy)
> > > > >     i40e: pps ~ 700 Kpps, 8 Gbps (skb mode, copy)
> > > > >     virtio: pps ~ 200 Kpps, 2.4 Gbps (skb mode, copy, all qemu/kvm VMs)
> > > > > 
> > > > > Are these numbers in the ballpark of what's expected?    
> > > > 
> > > > I would say they are too slow / low.
> > > > 
> > > > Have you remembered to do bulking?
> > > >     
> > > 
> > > I am using a batch size of 256.  
> > 
> > Hmm...
> > 
> > Maybe you can test with xdp_redirect_map program in samples/bpf/ and
> > compare the performance on this hardware?  
> 
> Hi Jesper,
> 
> I tried to use this program, however it does not seem to work for bidirectional
> traffic across the two interfaces?

It does work bidirectional if you start more of these xdp_redirect_map
programs.  Do notice this is an example program.  Look at xdp_fwd_*.c
if you want a program that is functional and uses the existing IP route
table for XDP acceleration.

My point is that there are alternatives for doing zero-copy between
interfaces... A xdp_redirect_map inside the kernel out another
interface is already zero-copy.

I'm wondering why did you choose/need AF_XDP technology for doing forwarding?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
