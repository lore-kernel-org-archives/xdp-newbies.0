Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732189AbgFWL1T (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 23 Jun 2020 07:27:19 -0400
MIME-Version: 1.0
References: <CAPydje97m+hG3_Cqg560uHoq8aKG9eDpTHA1eJC=hLuKtMf_vw@mail.gmail.com>
 <CAJ+HfNgi5wEwmFTgKpR1KemVm3p0FCPTd8V+BBWC6C59OO9O8Q@mail.gmail.com>
In-Reply-To: <CAJ+HfNgi5wEwmFTgKpR1KemVm3p0FCPTd8V+BBWC6C59OO9O8Q@mail.gmail.com>
From: Yahui Chen <goodluckwillcomesoon@gmail.com>
Date: Tue, 23 Jun 2020 19:27:06 +0800
Message-ID: <CAPydje-tiJ6F5i9=o9VLMJK0_j+KV5XGOok3Wq+okHdOS9k0Aw@mail.gmail.com>
Subject: Re: Talk about AF_XDP support multithread concurrently receive packet
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc: "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, Xdp <xdp-newbies@vger.kernel.org>

Hi Björn,
Thx for your clarification.

Lock-free queue may be a better choice, which almost does not impact
performance. The XDP mode is multi-producer/single-consumer for the
filling queue when receiving packets, and single-producer/multi-consumer
for the complete queue when sending packets.

So, the date structure for lock-free queue could be defined blow:

$ git diff xsk.h
diff --git a/src/xsk.h b/src/xsk.h
index 584f682..2e24bc8 100644
--- a/src/xsk.h
+++ b/src/xsk.h
@@ -23,20 +23,26 @@ extern "C" {
 #endif

 /* Do not access these members directly. Use the functions below. */
-#define DEFINE_XSK_RING(name) \
-struct name { \
-       __u32 cached_prod; \
-       __u32 cached_cons; \
-       __u32 mask; \
-       __u32 size; \
-       __u32 *producer; \
-       __u32 *consumer; \
-       void *ring; \
-       __u32 *flags; \
-}
-
-DEFINE_XSK_RING(xsk_ring_prod);
-DEFINE_XSK_RING(xsk_ring_cons);
+struct xsk_ring_prod{
+       __u32 cached_prod_head;
+       __u32 cached_prod_tail;
+       __u32 cached_cons;
+       __u32 size;
+       __u32 *producer;
+       __u32 *consumer;
+       void *ring;
+       __u32 *flags;
+};
+struct xsk_ring_cons{
+       __u32 cached_prod;
+       __u32 cached_cons_head;
+       __u32 cached_cons_tail;
+       __u32 size;
+       __u32 *producer;
+       __u32 *consumer;
+       void *ring;
+       __u32 *flags;
+};

The element mask, is equal `size - 1`, could be removed to remain the
structure size unchanged.

To sum up, it's possible to consider impelementing lock-free queue
function to support mc/sp and sc/mp.

Thx.


Björn Töpel <bjorn.topel@gmail.com> 于2020年6月23日周二 下午3:27写道：
>
> On Tue, 23 Jun 2020 at 08:21, Yahui Chen <goodluckwillcomesoon@gmail.com> wrote:
> >
> > I have make an issue for the libbpf in github, issue number 163.
> >
> > Andrii suggest me sending a mail here. So ,I paste out the content of the issue:
> >
>
> Yes, and the xdp-newsbies is an even better list for these kinds of
> discussions (added).
>
> > Currently, libbpf do not support concurrently receive pkts using AF_XDP.
> >
> > For example: I create 4 af_xdp sockets on nic's ring 0. Four sockets
> > receiving packets concurrently can't work correctly because the API of
> > cq `xsk_ring_prod__reserve` and `xsk_ring_prod__submit` don't support
> > concurrence.
> >
>
> In other words, you are using shared umem sockets. The 4 sockets can
> potentially receive packets from queue 0, depending on how the XDP
> program is done.
>
> > So, my question is why libbpf was designed non-concurrent mode, is the
> > limit of kernel or other reason? I want to change the code to support
> > concurrent receive pkts, therefore I want to find out whether this is
> > theoretically supported.
> >
>
> You are right that the AF_XDP functionality in libbpf is *not* by
> itself multi-process/thread safe, and this is deliberate. From the
> libbpf perspective we cannot know how a user will construct the
> application, and we don't want to penalize the single-thread/process
> case.
>
> It's entirely up to you to add explicit locking, if the
> single-producer/single-consumer queues are shared between
> threads/processes. Explicit synchronization is required using, say,
> POSIX mutexes.
>
> Does that clear things up?
>
>
> Cheers,
> Björn
>
> > Thx.
