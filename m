Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725468AbfJUEE7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 21 Oct 2019 00:04:59 -0400
Date: Mon, 21 Oct 2019 06:04:44 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: How to debug XDP_REDIRECT errors
Message-ID: <20191021060444.297a7886@carbon>
In-Reply-To: <CAC1LvL3efhuf8dc-aQKepMND24drwVAHAzVs-4Np4CUTV8qOgQ@mail.gmail.com>
References: <CAC1LvL3efhuf8dc-aQKepMND24drwVAHAzVs-4Np4CUTV8qOgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, brouer@redhat.com

On Sun, 20 Oct 2019 16:07:13 -0500
Zvi Effron <zeffron@riotgames.com> wrote:

> Hello,
>=20
> I'm trying to get some additional performance out of XDP on the i40e
> driver (under kernel 5.0.7, Fedora 28) by adjusting the queues to be
> one per desired core. I have several cores isolated for network
> traffic, so I'm adjusting the queues to be one per isolated core (with
> IRQ adjustments to match) as opposed to the default of one per online
> core. I've noticed that when I adjust the number of queues down, I see
> packet loss proportional to the number of queues missing. For example,
> if I drop the queues from the default of 36 down to 34, I see ~6%
> packet loss.
>=20
> Using the trace_pipe, I've managed to confirm that my program is
> successfully calling bpf_redirect_map() for all of the packet (no
> losst). I found the xdp_monitor tutorial[1] and ran it, and it shows
> the loss showing up as XDP_REDIRECT errors (which I believe means the
> raw_tracepoint xdp:xdp_redirect_map_err).

I usually use standard perf-record:

 $ perf record -e xdp:xdp_redirect_map_err sleep 1

And then look at detailed results with:

 $ perf script

As this is a standard tracepoint, you can lookup docs for howto use
tracepoints.  To debug closer you likely want to extract other info,
and maybe aggregate.  I will recommend looking closer at bpftrace
tool[2].

[2] https://github.com/iovisor/bpftrace/blob/master/docs/tutorial_one_liner=
s.md


> At this point, I'm a bit stuck on how to proceed further to determine
> what is causing the redirect error and where the packet is being
> dropped.
>=20
> Any help in pointing me in the right direction for debugging
> techniques would be greatly appreciated.
>
> Thanks!
> --Zvi
>=20
> [1]: https://github.com/xdp-project/xdp-tutorial/blob/master/tracing02-xd=
p-monitor



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
