Return-Path: <brouer@redhat.com>
Date: Fri, 26 Jan 2018 09:50:21 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [Bloat] one big bump in the wire for latency monitoring
Message-ID: <20180126095021.4d7de9aa@redhat.com>
In-Reply-To: <877es51t6y.fsf@toke.dk>
References: <CAA93jw7+7=nFUix39nP4caGJjwGPkBM6SLzM1zCX+hetdho=mQ@mail.gmail.com>
	<877es51t6y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
List-ID: <xdp-newbies.vger.kernel.org>
To: Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc: Dave Taht <dave.taht@gmail.com>, bloat <bloat@lists.bufferbloat.net>, brouer@redhat.com, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On Thu, 25 Jan 2018 23:15:17 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> wrote:

> Dave Taht <dave.taht@gmail.com> writes:
>=20
> > https://blog.apnic.net/2018/01/22/ruru-real-time-wide-area-tcp-latency-=
monitoring/ =20
>=20
> Neat! The packet tapping part could probably be implemented in XDP to
> avoid the DPDK space heater... ;)

I was thinking the exact same thing ;-)

It should be fairly simple to write a XDP/eBPF program, that timestamp
via bpf_ktime_get_ns() and queue the events via a perf ring-buffer via
bpf_perf_event_output() (the only kernel example is [1]). And a
userspace side tool[2] that reads these perf_event's.

Cc. xdp-newbies@vger.kernel.org hoping someone want to give it a go?

[1] https://github.com/torvalds/linux/blob/master/samples/bpf/trace_output_=
kern.c
[2] https://github.com/torvalds/linux/blob/master/samples/bpf/trace_output_=
user.c
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
