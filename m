Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36286 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfFYWXg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 18:23:36 -0400
MIME-Version: 1.0
References: <20190625023137.29272-1-yuehaibing@huawei.com> <20190625112104.6654a048@carbon>
In-Reply-To: <20190625112104.6654a048@carbon>
From: Song Liu <liu.song.a23@gmail.com>
Date: Tue, 25 Jun 2019 15:23:24 -0700
Message-ID: <CAPhsuW7e8KLooD_ASwWE_dbJwNTcs5sqR66LTWxR-cH3SBzSJw@mail.gmail.com>
Subject: Re: [PATCH net-next] xdp: Make __mem_id_disconnect static
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: YueHaibing <yuehaibing@huawei.com>, "David S . Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, John Fastabend <john.fastabend@gmail.com>, open list <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, xdp-newbies@vger.kernel.org, bpf <bpf@vger.kernel.org>

On Tue, Jun 25, 2019 at 4:52 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Tue, 25 Jun 2019 10:31:37 +0800
> YueHaibing <yuehaibing@huawei.com> wrote:
>
> > Fix sparse warning:
> >
> > net/core/xdp.c:88:6: warning:
> >  symbol '__mem_id_disconnect' was not declared. Should it be static?
>
> I didn't declare it static as I didn't want it to get inlined.  As
> during development I was using kprobes to inspect this function.  In
> the end I added a tracepoint in this function as kprobes was not enough
> to capture the state needed.
>
> So, I guess we can declare it static.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I think the rule is, non-static function must be declared in a header.

Acked-by: Song Liu <songliubraving@fb.com>

>
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  net/core/xdp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index b29d7b5..829377c 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
> >       kfree(xa);
> >  }
> >
> > -bool __mem_id_disconnect(int id, bool force)
> > +static bool __mem_id_disconnect(int id, bool force)
> >  {
> >       struct xdp_mem_allocator *xa;
> >       bool safe_to_remove = true;
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
