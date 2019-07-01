Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39804 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGANKy (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 1 Jul 2019 09:10:54 -0400
MIME-Version: 1.0
References: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
 <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com> <20190629.105306.762888643756822083.davem@davemloft.net>
In-Reply-To: <20190629.105306.762888643756822083.davem@davemloft.net>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Mon, 1 Jul 2019 15:10:40 +0200
Message-ID: <CAJ+HfNi3+hu+D=nJOrtC_xVzE442BoYo4mXqT28rGPG83Dr_sw@mail.gmail.com>
Subject: Re: [PATCH net-next] xdp: xdp_umem: fix umem pages mapping for 32bits systems
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: David Miller <davem@davemloft.net>, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, 29 Jun 2019 at 19:53, David Miller <davem@davemloft.net> wrote:
>
> From: Björn Töpel <bjorn.topel@gmail.com>
> Date: Wed, 26 Jun 2019 22:50:23 +0200
>
> > On Wed, 26 Jun 2019 at 17:59, Ivan Khoronzhuk
> > <ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> Use kmap instead of page_address as it's not always in low memory.
> >>
> >
> > Ah, some 32-bit love. :-) Thanks for working on this!
> >
> > For future patches, please base AF_XDP patches on the bpf/bpf-next
> > tree instead of net/net-next.
> >
> > Acked-by: Björn Töpel <bjorn.topel@intel.com>
>
> Alexei and Daniel, I'll let you guys take this one.
>
> Thanks.

Ivan, kbuild reported some build issues. Faulty, or not; Please have a
look at them.


Cheers,
Björn
