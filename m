Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43936 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCQsw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Wed, 3 Jul 2019 12:48:52 -0400
MIME-Version: 1.0
References: <CGME20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77@eucas1p2.samsung.com>
 <20190703120916.19973-1-i.maximets@samsung.com> <CAJ8uoz1Wr+bJrO+HNtSD5b79ych-pNg7BxFiHVhzaMSGGAdqLA@mail.gmail.com>
In-Reply-To: <CAJ8uoz1Wr+bJrO+HNtSD5b79ych-pNg7BxFiHVhzaMSGGAdqLA@mail.gmail.com>
From: William Tu <u9012063@gmail.com>
Date: Wed, 3 Jul 2019 09:48:09 -0700
Message-ID: <CALDO+SYj79zCV9A85OSbMFBQeor_z=ZT305HEoK3YWtCZLeR-A@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xdp: fix race on generic receive path
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Ilya Maximets <i.maximets@samsung.com>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Wed, Jul 3, 2019 at 6:20 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Jul 3, 2019 at 2:09 PM Ilya Maximets <i.maximets@samsung.com> wrote:
> >
> > Unlike driver mode, generic xdp receive could be triggered
> > by different threads on different CPU cores at the same time
> > leading to the fill and rx queue breakage. For example, this
> > could happen while sending packets from two processes to the
> > first interface of veth pair while the second part of it is
> > open with AF_XDP socket.
> >
> > Need to take a lock for each generic receive to avoid race.
>
> I measured the performance degradation of rxdrop on my local machine
> and it went from 2.19 to 2.08, so roughly a 5% drop. I think we can
> live with this in XDP_SKB mode. If we at some later point in time need
> to boost performance in this mode, let us look at it then from a
> broader perspective and find the most low hanging fruit.
>
> Thanks Ilya for this fix.
>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> > Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> > Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> > ---

Tested on my machine and works ok.
Tested-by: William Tu <u9012063@gmail.com>
