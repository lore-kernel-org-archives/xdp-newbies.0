Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35232 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgA0Py4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 27 Jan 2020 10:54:56 -0500
Received: by mail-oi1-f193.google.com with SMTP id b18so3144803oie.2
        for <xdp-newbies@vger.kernel.org>; Mon, 27 Jan 2020 07:54:56 -0800 (PST)
MIME-Version: 1.0
References: <CAJ8uoz1FcfDYa1PaQuY-Yk+keEX5FT6+q2H2eLTce6DxcQjuiA@mail.gmail.com>
 <20200113151159.GB68570@smtp.ads.isi.edu> <CAJ8uoz1Ax5CAfO4wfo0Pj+jieeRN+gj0s2LpeeJ53uTorFP0ng@mail.gmail.com>
 <20200114205250.GA85903@smtp.ads.isi.edu> <20200115014137.GA105434@smtp.ads.isi.edu>
 <CAJ8uoz2VTXAT9ryF9Ls2JjacEw0Bc23t9w2jDEoMdA0dRc6Aaw@mail.gmail.com>
 <CAJ8uoz1Nf+Fsg40tfdnMenFiCjRBJN9maY9rVo--trt+Uwkqwg@mail.gmail.com>
 <20200116020414.GA46831@smtp.ads.isi.edu> <CAJ8uoz0yqYTq+OOK8p0XRcWyMkfnJ1ZT7hUew9w3FuHr=4K-QQ@mail.gmail.com>
 <4c03813d-5edf-7e9e-8905-31902b5acb71@mellanox.com> <20200122214352.GA13201@smtp.ads.isi.edu>
 <b1b9342b-b9e5-f576-c06c-3a43dcf2b189@mellanox.com>
In-Reply-To: <b1b9342b-b9e5-f576-c06c-3a43dcf2b189@mellanox.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 27 Jan 2020 16:54:44 +0100
Message-ID: <CAJ8uoz1wuCmPehXNX2_OddF2YC=2mNaFZC4f+6j9VkmSTSPaQQ@mail.gmail.com>
Subject: Re: zero-copy between interfaces
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Maxim Mikityanskiy <maximmi@mellanox.com>
Cc: Ryan Goodfellow <rgoodfel@isi.edu>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>

On Mon, Jan 27, 2020 at 3:01 PM Maxim Mikityanskiy <maximmi@mellanox.com> w=
rote:
>
> On 2020-01-22 23:43, Ryan Goodfellow wrote:
> > On Tue, Jan 21, 2020 at 01:40:50PM +0000, Maxim Mikityanskiy wrote:
> >>>> I've posted output from the program in debugging mode here
> >>>>
> >>>> - https://gitlab.com/mergetb/tech/network-emulation/kernel/snippets/=
1930375
> >>>>
> >>>> Yes, you are correct in that forwarding works for a brief period and=
 then stops.
> >>>> I've noticed that the number of packets that are forwarded is equal =
to the size
> >>>> of the producer/consumer descriptor rings. I've posted two ping trac=
es from a
> >>>> client ping that shows this.
> >>>>
> >>>> - https://gitlab.com/mergetb/tech/network-emulation/kernel/snippets/=
1930376
> >>>> - https://gitlab.com/mergetb/tech/network-emulation/kernel/snippets/=
1930377
> >>
> >> These snippets are not available.
> >
> > Apologies, I had the wrong permissions set. They should be available no=
w.
> >
> >>
> >>>>
> >>>> I've also noticed that when the forwarding stops, the CPU usage for =
the proc
> >>>> running the program is pegged, which is not the norm for this progra=
m as it uses
> >>>> a poll call with a timeout on the xsk fd.
> >>
> >> This information led me to a guess what may be happening. On the RX
> >> side, mlx5e allocates pages in bulks for performance reasons and to
> >> leverage hardware features targeted to performance. In AF_XDP mode,
> >> bulking of frames is also used (on x86, the bulk size is 64 with
> >> striding RQ enabled, and 8 otherwise, however, it's implementation
> >> details that might change later). If you don't put enough frames to XS=
K
> >> Fill Ring, the driver will be demanding more frames and return from
> >> poll() immediately. Basically, in the application, you should put as
> >> many frames to the Fill Ring as you can. Please check if that could be
> >> the root cause of your issue.
> >
> > The code in this application makes an effort to relenish the fill ring =
as fast
> > as possible. The basic loop of the application is to first check if the=
re are
> > any descriptors to be consumed from the completion queue or any descrip=
tors that
> > can be added to the fill queue, and only then to move on to moving pack=
ets
> > through the rx and tx rings.
> >
> > https://gitlab.com/mergetb/tech/network-emulation/kernel/blob/v5.5-moa/=
samples/bpf/xdpsock_multidev.c#L452-474
>
> I reproduced your issue and did my investigation, and here is what I foun=
d:
>
> 1. Commit df0ae6f78a45 (that you found during bisect) introduces an
> important behavioral change (which I thought was not that important).
> xskq_nb_avail used to return min(entries, dcnt), but after the change it
> just returns entries, which may be as big as the ring size.
>
> 2. xskq_peek_addr updates q->ring->consumer only when q->cons_tail
> catches up with q->cons_head. So, before that patch and one previous
> patch, cons_head - cons_tail was not more than 16, so the consumer index
> was updated periodically. Now consumer is updated only when the whole
> ring is exhausted.
>
> 3. The application can't replenish the fill ring if the consumer index
> doesn't move. As a consequence, refilling the descriptors by the
> application can't happen in parallel with using them by the driver. It
> should have some performance penalty and possibly even lead to packet
> drops, because the driver uses all the descriptors and only then
> advances the consumer index, and then it has to wait until the
> application refills the ring, busy-looping and losing packets.

This will happen if user space always fills up the whole ring, which
might or might not happen all depending on the app. With that said, it
might provide better performance to update it once in a while. It
might also be the case that we will get better performance with the
new scheme if we only fill half the fill ring. I will look into this
and see what I get.

> 4. As mlx5e allocates frames in batches, the consequences are even more
> severe: it's a deadlock where the driver waits for the application, and
> vice versa. The driver never reaches the point where cons_tail gets
> equal to cons_head. E.g., if cons_tail + 3 =3D=3D cons_head, and the batc=
h
> size requested by the driver is 8, the driver won't peek anything from
> the fill ring waiting for difference between cons_tail and cons_head to
> increase to be at least 8. On the other hand, the application can't put
> anything to the ring, because it still thinks that the consumer index is
> 0. As cons_tail never reaches cons_head, the consumer index doesn't get
> updated, hence the deadlock.

Good thing that you detected this. Maybe I should get a Mellanox card
:-). This is different from how we implemented Intel's drivers that
just work on any batch size. If it gets 3 packets back, it will use
those. How do you deal with the case when the application just puts a
single buffer in the fill ring and wants to receive a single packet?
Why does the Mellanox driver need a specific batch size? This is just
for my understanding so we can find a good solution.

> So, in my vision, the decision to remove RX_BATCH_SIZE and periodic
> updates of the consumer index was wrong. It totally breaks mlx5e, that
> does batching, and it will affect the performance of any driver, because
> the application can't refill the ring until it gets completely empty and
> the driver starts waiting for frames. I suggest that periodic updates of
> the consumer index should be readded to xskq_cons_peek_addr.

The reason I wanted to remove RX_BATCH_SIZE is that application
developers complained about it giving rise to counter intuitive
behavior in user space. I will try to dig out the complaints and the
explanations Bj=C3=B6rn and I had to send which it seemed that users really
should not have to care about. It should just work. I also do not like
to have arbitrary constants like this. Why 16? Would much prefer not
having to deal with this, unless of course it horribly breaks
something or gives rise to worse performance. Might still be the case
here, but if not, I would like to remove it.

Thanks: Magnus

> Magnus, what do you think of the suggestion above?
>
> Thanks,
> Max
>
> >>
> >> I tracked this issue in our internal bug tracker in case we need to
> >> perform actual debugging of mlx5e. I'm looking forward to your feedbac=
k
> >> on my assumption above.
> >>
> >>>> The hardware I am using is a Mellanox ConnectX4 2x100G card (MCX416A=
-CCAT)
> >>>> running the mlx5 driver.
> >>
> >> This one should run without striding RQ, please verify it with ethtool
> >> --show-priv-flags (the flag name is rx_striding_rq).
> >
> > I do not remember changing this option, so whatever the default is, is =
what it
> > was running with. I am traveling this week and do not have access to th=
ese
> > systems, but will ensure that this flag is set properly when I get back=
.
> >
>
