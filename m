Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33973 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbfGHVZ5 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Mon, 8 Jul 2019 17:25:57 -0400
MIME-Version: 1.0
References: <CGME20190704142509eucas1p268eb9ca87bcc0bffb60891f88f3f6642@eucas1p2.samsung.com>
 <20190704142503.23501-1-i.maximets@samsung.com> <CAJ+HfNi2EdLwtq9SfccZBymDMv_cW5+vxB-JLqxyvYS_TG3ScA@mail.gmail.com>
In-Reply-To: <CAJ+HfNi2EdLwtq9SfccZBymDMv_cW5+vxB-JLqxyvYS_TG3ScA@mail.gmail.com>
From: William Tu <u9012063@gmail.com>
Date: Mon, 8 Jul 2019 14:25:20 -0700
Message-ID: <CALDO+SYaR+txmTq_xhaw1cD4v7svtE7BD3mOsBx-X=MEVeZzzA@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: fix possible cq entry leak
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc: Ilya Maximets <i.maximets@samsung.com>, Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Thu, Jul 4, 2019 at 11:49 PM Björn Töpel <bjorn.topel@gmail.com> wrote:
>
> On Thu, 4 Jul 2019 at 16:25, Ilya Maximets <i.maximets@samsung.com> wrote:
> >
> > Completion queue address reservation could not be undone.
> > In case of bad 'queue_id' or skb allocation failure, reserved entry
> > will be leaked reducing the total capacity of completion queue.
> >
> > Fix that by moving reservation to the point where failure is not
> > possible. Additionally, 'queue_id' checking moved out from the loop
> > since there is no point to check it there.
> >
>
> Good catch, Ilya! Thanks for the patch!
>
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
>
Thanks
Tested-by: William Tu <u9012063@gmail.com>
