Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54800 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728641AbgAMREX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 13 Jan 2020 12:04:23 -0500
Date: Mon, 13 Jan 2020 18:04:11 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: zero-copy between interfaces
Message-ID: <20200113180411.24d8bd40@carbon>
In-Reply-To: <20200113152759.GD68570@smtp.ads.isi.edu>
References: <14f9e1bf5c3a41dbaec53f83cb5f0564@isi.edu>
        <20200113124134.3974cbed@carbon>
        <20200113152759.GD68570@smtp.ads.isi.edu>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Ryan Goodfellow <rgoodfel@isi.edu>
Cc: brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Mon, 13 Jan 2020 10:28:00 -0500
Ryan Goodfellow <rgoodfel@isi.edu> wrote:

> On Mon, Jan 13, 2020 at 12:41:34PM +0100, Jesper Dangaard Brouer wrote:
> > On Mon, 13 Jan 2020 00:18:36 +0000
> > Ryan Goodfellow <rgoodfel@isi.edu> wrote:
> >   
> > > The numbers that I have been able to achive with this code are the following. MTU
> > > is 1500 in all cases.
> > > 
> > >     mlx5: pps ~ 2.4 Mpps, 29 Gbps (driver mode, zero-copy)
> > >     i40e: pps ~ 700 Kpps, 8 Gbps (skb mode, copy)
> > >     virtio: pps ~ 200 Kpps, 2.4 Gbps (skb mode, copy, all qemu/kvm VMs)
> > > 
> > > Are these numbers in the ballpark of what's expected?  
> > 
> > I would say they are too slow / low.
> > 
> > Have you remembered to do bulking?
> >   
> 
> I am using a batch size of 256.

Hmm...

Maybe you can test with xdp_redirect_map program in samples/bpf/ and
compare the performance on this hardware?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
