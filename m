Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43556 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbgBIJ62 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Sun, 9 Feb 2020 04:58:28 -0500
Received: by mail-ot1-f66.google.com with SMTP id p8so3483520oth.10
        for <xdp-newbies@vger.kernel.org>; Sun, 09 Feb 2020 01:58:26 -0800 (PST)
MIME-Version: 1.0
References: <1581068272-4615-1-git-send-email-magnus.karlsson@intel.com>
 <c5d6fd11-8696-e898-6f05-5fcc087c0065@mellanox.com> <95de5e86-8930-5655-62b9-ec60b9952440@iogearbox.net>
In-Reply-To: <95de5e86-8930-5655-62b9-ec60b9952440@iogearbox.net>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Sun, 9 Feb 2020 10:58:17 +0100
Message-ID: <CAJ8uoz2Qn496NX2Q49_Ct_r4b_NjouqhM8iz+c2yp8y9=e4wSg@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: publish global consumer pointers when NAPI is finsihed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Maxim Mikityanskiy <maximmi@mellanox.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Xdp <xdp-newbies@vger.kernel.org>, Ryan Goodfellow <rgoodfel@isi.edu>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>

On Fri, Feb 7, 2020 at 10:41 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/7/20 1:34 PM, Maxim Mikityanskiy wrote:
> > On 2020-02-07 11:37, Magnus Karlsson wrote:
> >> The commit 4b638f13bab4 ("xsk: Eliminate the RX batch size")
> >> introduced a much more lazy way of updating the global consumer
> >> pointers from the kernel side, by only doing so when running out of
> >> entries in the fill or Tx rings (the rings consumed by the
> >> kernel). This can result in a deadlock with the user application if
> >> the kernel requires more than one entry to proceed and the application
> >> cannot put these entries in the fill ring because the kernel has not
> >> updated the global consumer pointer since the ring is not empty.
> [...]
> >
> > Acked-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >
> > Is it intentional that you didn't send it to bpf and netdev mailing lists?
>
> Yep, please resend with Maxim's ACK to bpf + netdev in Cc. Thanks!

It was intentional, but maybe confusing. In the mail just before this
patch I suggested that this patch should be part of a patch set that
we send to bpf and netdev. The purpose of sending it was for you Maxim
to ok it, and you did with your ack :-). But I will repeat the other
questions from that mail here.

Does the Mellanox driver set the need_wakeup flag on Rx when it needs
more buffers in the fill ring to form its stride and the HW Rx ring is
empty? If yes, great. If not, please submit a patch for this.

I will produce a documentation patch that clarifies that when the
need_wakeup flag is set for the fill ring, the user need to put more
packets on the fill ring and wakeup the kernel. It is already
mentioned in the documentation, but I will make it more explicit.
