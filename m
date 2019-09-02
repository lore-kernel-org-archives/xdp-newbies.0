Return-Path: <brouer@redhat.com>
MIME-Version: 1.0
Date: Mon, 2 Sep 2019 11:08:18 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Message-ID: <20190902110818.2f6a8894@carbon>
In-Reply-To: <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
	<CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
List-ID: <xdp-newbies.vger.kernel.org>
To: Kal Cutter Conley <kal.conley@dectris.com>
Cc: brouer@redhat.com, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Maxim Mikityanskiy <maximmi@mellanox.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= <toke.hoiland-jorgensen@kau.se>, Andy Gospodarek <gospo@broadcom.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Sun, 1 Sep 2019 18:47:15 +0200
Kal Cutter Conley <kal.conley@dectris.com> wrote:

> Hi,
> I figured out the problem. Let me document the issue here for others
> and hopefully start a discussion.
> 
> The mlx5 driver uses special queue ids for ZC. If N is the number of
> configured queues, then for XDP_ZEROCOPY the queue ids start at N. So
> queue ids [0..N) can only be used with XDP_COPY and queue ids [N..2N)
> can only be used with XDP_ZEROCOPY.

Thanks for the followup and explanation on how mlx5 AF_XDP queue
implementation is different from other vendors.


> sudo ethtool -L eth0 combined 16
> sudo samples/bpf/xdpsock -r -i eth0 -c -q 0   # OK
> sudo samples/bpf/xdpsock -r -i eth0 -z -q 0   # ERROR
> sudo samples/bpf/xdpsock -r -i eth0 -c -q 16  # ERROR
> sudo samples/bpf/xdpsock -r -i eth0 -z -q 16  # OK
> 
> Why was this done? To use zerocopy if available and fallback on copy
> mode normally you would set sxdp_flags=0. However, here this is no
> longer possible. To support this driver, you have to first try binding
> with XDP_ZEROCOPY and the special queue id, then if that fails, you
> have to try binding again with a normal queue id. Peculiarities like
> this complicate the XDP user api. Maybe someone can explain the
> benefits?

Thanks for complaining, it is actually valuable. It really illustrate
the kernel need to improve in this area, which is what our talk[1] at
LPC2019 (Sep 10) is about.

Title: "Making Networking Queues a First Class Citizen in the Kernel"
 [1] https://linuxplumbersconf.org/event/4/contributions/462/

As you can see, several vendors are actually involved. Kudos to Magnus
for taking initiative here!  It's unfortunately not solved "tomorrow",
as first we have to agree this is needed (facility to register queues),
then agree on API and get commitment from vendors, as this requires
drivers changes.  There is a long road ahead, but I think it will be
worthwhile in the end, as effective use of dedicated hardware queues
(both RX and TX) is key to performance.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer



> On Wed, Aug 7, 2019 at 2:49 PM Kal Cutter Conley <kal.conley@dectris.com> wrote:
> >
> > Hello,
> > I am testing the mlx5e driver with AF_XDP. When I specify
> > XDP_ZEROCOPY, bind() always returns EINVAL. I observe the same problem
> > with the xdpsock sample:
> >
> > sudo samples/bpf/xdpsock -r -i dcb1-port1 -z
> > samples/bpf/xdpsock_user.c:xsk_configure_socket:322: errno:
> > 22/"Invalid argument"
> >
> > Without XDP_ZEROCOPY, everything works as expected. Is this a known
> > issue/limitation? I expected this to be supported looking at the
> > code/commit history.
> >
> > Thanks,
> > Kal  
