Return-Path: <kal.conley@dectris.com>
MIME-Version: 1.0
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
 <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
 <20190902110818.2f6a8894@carbon> <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
 <CAHApi-k=9Szxm0QMD4N4PW9Lq8L4hW6e7VfyBePzrTgvKGRs5Q@mail.gmail.com> <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200618150347.ihtdvsfuurgfka7i@bsd-mbp.dhcp.thefacebook.com>
From: Kal Cutter Conley <kal.conley@dectris.com>
Date: Thu, 18 Jun 2020 19:31:36 +0200
Message-ID: <CAHApi-kkACFLs3YT+BR7DUrRSM-97Kh9O=9uG5uKWuVG5ytKKA@mail.gmail.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Content-Type: text/plain; charset="UTF-8"
List-ID: <xdp-newbies.vger.kernel.org>
To: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "brouer@redhat.com" <brouer@redhat.com>, Maxim Mikityanskiy <maximmi@mellanox.com>, "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, "toke.hoiland-jorgensen@kau.se" <toke.hoiland-jorgensen@kau.se>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Tariq Toukan <tariqt@mellanox.com>, "gospo@broadcom.com" <gospo@broadcom.com>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bjorn.topel@intel.com" <bjorn.topel@intel.com>

On Thu, Jun 18, 2020 at 5:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Sun, Jun 14, 2020 at 10:55:30AM +0200, Kal Cutter Conley wrote:
> > Hi Saeed,
> > Thanks for explaining the reasoning behind the special mlx5 queue
> > numbering with XDP zerocopy.
> >
> > We have a process using AF_XDP that also shares the network interface
> > with other processes on the system. ethtool rx flow classification
> > rules are used to route the traffic to the appropriate XSK queue
> > N..(2N-1). The issue is these queues are only valid as long they are
> > active (as far as I can tell). This means if my AF_XDP process dies
> > other processes no longer receive ingress traffic routed over queues
> > N..(2N-1) even though my XDP program is still loaded and would happily
> > always return XDP_PASS. Other drivers do not have this usability issue
> > because they use queues that are always valid. Is there a simple
> > workaround for this issue? It seems to me queues N..(2N-1) should
> > simply map to 0..(N-1) when they are not active?
>
> If your XDP program returns XDP_PASS, the packet should be delivered to
> the xsk socket.  If the application isn't running, where would it go?

XDP_PASS means the packet is passed to the normal network stack for
processing. XDP_REDIRECT means the packet should be delivered to the
xsk socket.

>
> I do agree that the usability of this can be improved.  What if the flow
> rules are inserted and removed along with queue creatioin/destruction?

The problem is the mlx5 driver allows flow rules to be set on
N..(2N-1) at any time; even when no XDP program is loaded. Given this
fact, it would be totally weird if they just suddenly disappeared the
first time the queues go inactive. That's why I suggested that they
just always map to queues 0..(N-1) when they are not active. This way,
at least it's less surprising. What do people think?

> Jonathan

Kal
