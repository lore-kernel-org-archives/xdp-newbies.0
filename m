Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45701 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUuF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 25 Jun 2019 16:50:05 -0400
MIME-Version: 1.0
References: <20190625182352.13918-1-natechancellor@gmail.com> <34F07894-FDE7-44F8-B7F2-E2003D550AD2@gmail.com>
In-Reply-To: <34F07894-FDE7-44F8-B7F2-E2003D550AD2@gmail.com>
From: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date: Tue, 25 Jun 2019 22:49:52 +0200
Message-ID: <CAJ+HfNjKHG2dmu_juCJE5Xjo4HR4wqfk=yNPSAz8i7YbEWq6uw@mail.gmail.com>
Subject: Re: [PATCH] xsk: Properly terminate assignment in xskq_produce_flush_desc
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jakub Kicinski <jakub.kicinski@netronome.com>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Huckleberry <nhuck@google.com>

On Tue, 25 Jun 2019 at 22:04, Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 25 Jun 2019, at 11:23, Nathan Chancellor wrote:
>
> > Clang warns:
> >
> > In file included from net/xdp/xsk_queue.c:10:
> > net/xdp/xsk_queue.h:292:2: warning: expression result unused
> > [-Wunused-value]
> >         WRITE_ONCE(q->ring->producer, q->prod_tail);
> >         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > include/linux/compiler.h:284:6: note: expanded from macro 'WRITE_ONCE'
> >         __u.__val;                                      \
> >         ~~~ ^~~~~
> > 1 warning generated.
> >
> > The q->prod_tail assignment has a comma at the end, not a semi-colon.
> > Fix that so clang no longer warns and everything works as expected.
> >
> > Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/544
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>
> Nice find.
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>

Yikes. Yes, nice find, indeed.

Acked-by: Björn Töpel <bjorn.topel@intel.com>

The broader question is "Why does it work at all?", which is an "oh no" moment.

The problematic functions are xsk_flush() and xsk_generic_rcv, where
xskq_produce_flush_desc() is inlined. On the test machine, the GCC
version is:

$ gcc --version
gcc (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

I when I diff the output, both .lst and .o:

$ diff -u old.lst new.lst
--- old.lst     2019-06-25 22:10:57.709591605 +0200
+++ new.lst     2019-06-25 22:10:35.301359865 +0200
@@ -2480,7 +2480,7 @@
     1566:      48 8b 87 e0 02 00 00    mov    0x2e0(%rdi),%rax
 {
     156d:      48 89 e5                mov    %rsp,%rbp
-       q->prod_tail = q->prod_head,
+       q->prod_tail = q->prod_head;
     1570:      8b 50 18                mov    0x18(%rax),%edx
     1573:      89 50 1c                mov    %edx,0x1c(%rax)
        WRITE_ONCE(q->ring->producer, q->prod_tail);
@@ -2649,7 +2649,7 @@
     16fb:      83 40 24 01             addl   $0x1,0x24(%rax)
        xskq_produce_flush_desc(xs->rx);
     16ff:      49 8b 86 e0 02 00 00    mov    0x2e0(%r14),%rax
-       q->prod_tail = q->prod_head,
+       q->prod_tail = q->prod_head;
     1706:      8b 50 18                mov    0x18(%rax),%edx
        xs->sk.sk_data_ready(&xs->sk);
     1709:      4c 89 f7                mov    %r14,%rdi

$ diff -u <(gdb -batch -ex 'file old.o' -ex 'disassemble xsk_flush')
<(gdb -batch -ex 'file new.o' -ex 'disassemble xsk_flush') && echo
"Whew"
Whew

$ diff -u <(gdb -batch -ex 'file old.o' -ex 'disassemble
xsk_generic_rcv') <(gdb -batch -ex 'file new.o' -ex 'disassemble
xsk_generic_rcv') && echo "Whew"
Whew

struct xsk_queue {
        u64                        chunk_mask;           /*     0   0x8 */
        u64                        size;                 /*   0x8   0x8 */
        u32                        ring_mask;            /*  0x10   0x4 */
        u32                        nentries;             /*  0x14   0x4 */
        u32                        prod_head;            /*  0x18   0x4 */
        u32                        prod_tail;            /*  0x1c   0x4 */
        u32                        cons_head;            /*  0x20   0x4 */
        u32                        cons_tail;            /*  0x24   0x4 */
        struct xdp_ring *          ring;                 /*  0x28   0x8 */
        u64                        invalid_descs;        /*  0x30   0x8 */

        /* size: 56, cachelines: 1, members: 10 */
        /* last cacheline: 56 bytes */
};

So, it appears that the generated code is equal, both in xsk_flush()
and xsk_generic_rcv() where flush was inlined. I'll be digging into
more GCC versions, and observe the generated code.

Regardless, this was a really good find. Thank you very much! Clang is
added to my kernel build workflow from now on...


Björn



>
> > ---
> >  net/xdp/xsk_queue.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > index 88b9ae24658d..cba4a640d5e8 100644
> > --- a/net/xdp/xsk_queue.h
> > +++ b/net/xdp/xsk_queue.h
> > @@ -288,7 +288,7 @@ static inline void xskq_produce_flush_desc(struct
> > xsk_queue *q)
> >       /* Order producer and data */
> >       smp_wmb(); /* B, matches C */
> >
> > -     q->prod_tail = q->prod_head,
> > +     q->prod_tail = q->prod_head;
> >       WRITE_ONCE(q->ring->producer, q->prod_tail);
> >  }
> >
> > --
> > 2.22.0
