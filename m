Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46317 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404167AbgDCPbq (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 3 Apr 2020 11:31:46 -0400
Date: Fri, 3 Apr 2020 17:31:40 +0200
From: Gilberto Bertin <me@jibi.io>
Subject: Re: Running XSK on a tun device
Message-ID: <20200403153138.GA28761@apathy>
References: <7c11add0-e837-4ce4-9158-249c800d0d2d@www.fastmail.com>
 <CAJ8uoz1FeupoucsiF_Nrxv6S+XVXjpeB_pqcNJ3n12B1XsEyAQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz1FeupoucsiF_Nrxv6S+XVXjpeB_pqcNJ3n12B1XsEyAQ@mail.gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>

On Fri, Apr 03, 2020 at 04:10:39PM +0200, Magnus Karlsson wrote:
> On Fri, Apr 3, 2020 at 3:07 AM Gilberto Bertin <me@jibi.io> wrote:
> >
> > I am trying to bind an XSK socket to a tun device, so that I can run some
> > automated tests on an XSK based server I'm working on. A tun device would in
> > fact allow me to have fine control over what packets I'm sending to and
> > receiving from the server (as opposed for example to an approach where the
> > server listens on a regular interface and tests interact with it over sockets).
> >
> > The XSK logic of the server is largely based on the one presented in the
> > xdpsock_user sample in samples/bpf in the Linux kernel (the server is using the
> > XDP_USE_NEED_WAKEUP bind flag).
> >
> > When I manually interact with it using a pair of veth devices and netcat,
> > everything works as expected: the server receives and then sends back packets
> > properly.
> >
> > The troubles start when I try to bind it to a tun device as I am not able to move
> > any packet between the device and the server.
> >
> > I tried then to reproduce the issue with a simplified setup based on the
> > xdpsock_user sample, and I got the same results (I tested different combination
> > of options such as driver mode vs skb mode, poll vs non poll mode, need-wakeup
> > vs no-need-wakeup, all with the same outcome).
> >
> > By inspecting more closely the behavior of the sample program I found that:
> >
> > - packets are actually being received in the rx ring, as poll returns 1 each time
> >   something is written on the fd of the tun device
> > - the program gets stuck in rx_drop() [1], more precisely in:
> >
> >         ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> >         while (ret != rcvd) {
> >                 if (ret < 0)
> >                         exit_with_error(-ret);
> >                 if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
> >                         ret = poll(fds, num_socks, opt_timeout);
> >                 ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> >         }
> >
> >   where xsk_ring_prod__reserve keeps returning 0.
> 
> Which kernel version are you running? If my memory serves me right, in
> versions prior to 5.6, the update of the global state that signifies
> that there is space available in the fill ring was updated in a lazy
> manner. If you are not using the latest kernel, could you please try
> it? Maybe it could give us some hints on what is going on.

I was using a 5.6.0 kernel. I just tested the latest 5.6.2 and I keep
experiencing the same behaviour.

> Also have to say that the sample program is quite simplistic. If you
> cannot reserve some entries in the fill ring at some point, you should
> just go ahead and do something else (receive for example) and come
> back later and try to do the same thing. It is not critical to always
> be able to fill it again, even though it is good practice in a high
> performance situation to keep it as full as possible to minimize the
> risk of packet loss.

Makes sense, thanks! I'll have a look at updating that logic.

I just tried another XSK example program (the one in the xdp-tutorial repo)
which does something slightly different then the xdpsock_user one: it uses
xsk_prod_nb_free() to (as I understand it) determine if it's possible to reserve
and then submit descriptors in the fq ring [1]. With this logic I'm able to
receive packets succesfully from the tun interface.

> Note that there is not zero-copy support for TUN, but there is XDP
> support so copy mode and XDP_DRV should work.

Ack

> Also note that I have
> never tried TUN with AF_XDP, so you can have stumbled upon something
> new.

Makes sense, not sure at this point if this should be considered a bug of the
tun driver or if other drivers may exibit the same behaviour. In the latter case
I'd be happy to help updating the sample if you think it's worth it
(once I understand a bit more how the whole thing works :P).

Next I'll check if the TX path works correctly with tun, and eventually follow
up with my findings.

Thanks,
Gilberto

[1] https://github.com/xdp-project/xdp-tutorial/blob/cc0f4fbaabff9c149e5981beb71f7b52f02a6391/advanced03-AF_XDP/af_xdp_user.c#L345-L368
