Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65376 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbdHVSaY (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 22 Aug 2017 14:30:24 -0400
From: "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Subject: Re: XDP redirect measurements, gotchas and tracepoints
Date: Tue, 22 Aug 2017 18:30:21 +0000
Message-ID: <1503426617.2434.5.camel@intel.com>
References: <20170821212506.1cb0d5d6@redhat.com>
         <CACKFLimAF9OYwz8EqG=1-N40hWuA-8C8k8ut0oFKYdduvZOxHA@mail.gmail.com>
         <599C7530.2010405@gmail.com>
In-Reply-To: <599C7530.2010405@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <35592A9F08C1AB408F401453791BADC0@intel.com>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "brouer@redhat.com" <brouer@redhat.com>, "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Cc: "pstaszewski@itcare.pl" <pstaszewski@itcare.pl>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "andy@greyhouse.net" <andy@greyhouse.net>, "borkmann@iogearbox.net" <borkmann@iogearbox.net>

On Tue, 2017-08-22 at 11:17 -0700, John Fastabend wrote:
> On 08/22/2017 11:02 AM, Michael Chan wrote:
> > On Mon, Aug 21, 2017 at 12:25 PM, Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > > 
> > > I'be been playing with the latest XDP_REDIRECT feature, that was
> > > accepted in net-next (for ixgbe), see merge commit[1].
> > >  [1] https://git.kernel.org/davem/net-next/c/6093ec2dc31
> > > 
> > 
> > Just catching on XDP_REDIRECT and I have a very basic question.  The
> > ingress device passes the XDP buffer to the egress device for XDP
> > redirect transmission.  When the egress device has transmitted the
> > packet, is it supposed to just free the buffer?  Or is it supposed to
> > be recycled?
> > 
> > In XDP_TX, the buffer is recycled back to the rx ring.
> > 
> 
> With XDP_REDIRECT we must "just free the buffer" in ixgbe this means
> page_frag_free() on the data. There is no way to know where the xdp
> buffer came from it could be a different NIC for example.
> 
> However with how ixgbe is coded up recycling will work as long as
> the memory is free'd before the driver ring tries to use it again. In
> normal usage this should be the case. And if we are over-running a device
> it doesn't really hurt to slow down the sender a bit.
> 
> I think this is a pretty good model, we could probably provide a set
> of APIs for drivers to use so that we get some consistency across
> vendors here, ala Jesper's page pool ideas.
> 
> (+Alex, for ixgbe details)
> 
> Thanks,
> John

I think you pretty much covered the inner workings for the ixgbe bits.

The only piece I would add is that the recycling trick normally only
works if the same interface/driver is doing both the Tx and the Rx. The
redirect code cannot assume that is the case and that is the reason why
it must always be freeing the traffic on clean-up.

- Alex
