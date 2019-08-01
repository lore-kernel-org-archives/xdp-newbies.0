Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728783AbfHAQGI (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 1 Aug 2019 12:06:08 -0400
Date: Thu, 1 Aug 2019 18:05:16 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: xdpgeneric, XDP_PASS, and bpf_xdp_adjust_head decapsulation
 dropping packets
Message-ID: <20190801180512.163c471c@carbon>
In-Reply-To: <20190801165408.5cac9287@carbon>
References: <20190731211211.GA87084@multapplied.net>
        <20190801101746.702431fc@carbon>
        <20190801165408.5cac9287@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Brandon Cazander <brandon.cazander@multapplied.net>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, David Miller <davem@davemloft.net>, brouer@redhat.com

On Thu, 1 Aug 2019 16:54:33 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Thu, 1 Aug 2019 10:18:49 +0200
> Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> 
> [...]
> > Cc. Stephen as this might be related to:
> >   commit 458bf2f224f0 ("net: core: support XDP generic on stacked devices.") (Author: Stephen Hemminger).
> > 
> > On Wed, 31 Jul 2019 21:12:23 +0000 Brandon Cazander <brandon.cazander@multapplied.net> wrote:
> >   
> > > I am having an issue with xdpgeneric specifically when using XDP_PASS after
> > > bpf_xdp_adjust_head to pop some headers off. My test environment is qemu using
> > > virtio_net specifically, but it also happens with e1000 in qemu/physical devices.
> > > 
> > > On a real NIC (ixgbe), the same program is successfully passing decapsulated
> > > traffic, but fails in the same way when forcing xdpgeneric mode.    
> >   
> [...]
> > > Kernel is 5.2.2-1-debug, OS is openSUSE Tumbleweed 20190724.    
> > 
> > Can you test an earlier kernel, specifically before: commit
> > 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
> > (Author: Stephen Hemminger)
> > 
> > $ git describe --contains  458bf2f224f04
> > v5.2-rc3~26^2~11^2
> > 
> > I fear that this commit, which moved generic-XDP to a later call point,
> > might cause this.  Because it could be that the SKB network_header
> > update, is now done before calling XDP program (... still looking at
> > code details).  
> 
> I now have a reproducer myself, and I can confirm that this commit
> 458bf2f224f0 ("net: core: support XDP generic on stacked devices.") is
> the issue... reverting it fixes the problem.  (I don't have a fix yet)

I do have a fix now... It was a matter of calling skb_reset_network_header()
which will fix the issue with ip_hdr(skb) as I suspect was wrong (as
explained earlier).

I wonder if we also need to call skb_reset_transport_header(skb) ?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
