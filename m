Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38106 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfGDRL7 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 4 Jul 2019 13:11:59 -0400
Received: by mail-lf1-f66.google.com with SMTP id h28so344364lfj.5
        for <xdp-newbies@vger.kernel.org>; Thu, 04 Jul 2019 10:11:57 -0700 (PDT)
Date: Thu, 4 Jul 2019 20:11:41 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [PATCH v6 net-next 1/5] xdp: allow same allocator usage
Message-ID: <20190704171135.GB2923@khorivan>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
 <20190703101903.8411-2-ivan.khoronzhuk@linaro.org>
 <20190703194013.02842e42@carbon>
 <20190704102239.GA3406@khorivan>
 <20190704144144.5edd18eb@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190704144144.5edd18eb@carbon>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org, netdev@vger.kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com, john.fastabend@gmail.com

On Thu, Jul 04, 2019 at 02:41:44PM +0200, Jesper Dangaard Brouer wrote:
>On Thu, 4 Jul 2019 13:22:40 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> On Wed, Jul 03, 2019 at 07:40:13PM +0200, Jesper Dangaard Brouer wrote:
>> >On Wed,  3 Jul 2019 13:18:59 +0300
>> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>> >
>> >> First of all, it is an absolute requirement that each RX-queue have
>> >> their own page_pool object/allocator. And this change is intendant
>> >> to handle special case, where a single RX-queue can receive packets
>> >> from two different net_devices.
>> >>
>> >> In order to protect against using same allocator for 2 different rx
>> >> queues, add queue_index to xdp_mem_allocator to catch the obvious
>> >> mistake where queue_index mismatch, as proposed by Jesper Dangaard
>> >> Brouer.
>> >>
>> >> Adding this on xdp allocator level allows drivers with such dependency
>> >> change the allocators w/o modifications.
>> >>
>> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> >> ---
>> >>  include/net/xdp_priv.h |  2 ++
>> >>  net/core/xdp.c         | 55 ++++++++++++++++++++++++++++++++++++++++++
>> >>  2 files changed, 57 insertions(+)
>> >>
>> >> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
>> >> index 6a8cba6ea79a..9858a4057842 100644
>> >> --- a/include/net/xdp_priv.h
>> >> +++ b/include/net/xdp_priv.h
>> >> @@ -18,6 +18,8 @@ struct xdp_mem_allocator {
>> >>  	struct rcu_head rcu;
>> >>  	struct delayed_work defer_wq;
>> >>  	unsigned long defer_warn;
>> >> +	unsigned long refcnt;
>> >> +	u32 queue_index;
>> >>  };
>> >
>> >I don't like this approach, because I think we need to extend struct
>> >xdp_mem_allocator with a net_device pointer, for doing dev_hold(), to
>> >correctly handle lifetime issues. (As I tried to explain previously).
>> >This will be much harder after this change, which is why I proposed the
>> >other patch.
>> My concern comes not from zero also.
>> It's partly continuation of not answered questions from here:
>> https://lwn.net/ml/netdev/20190625122822.GC6485@khorivan/
>>
>> "For me it's important to know only if it means that alloc.count is
>> freed at first call of __mem_id_disconnect() while shutdown.
>> The workqueue for the rest is connected only with ring cache protected
>> by ring lock and not supposed that alloc.count can be changed while
>> workqueue tries to shutdonwn the pool."
>
>Yes.  The alloc.count is only freed on first call.  I considered
>changing the shutdown API, to have two shutdown calls, where the call
>used from the work-queue will not have the loop emptying alloc.count,
>but instead have a WARN_ON(alloc.count), as it MUST be empty (once is
>code running from work-queue).
>
>> So patch you propose to leave works only because of luck, because fast
>> cache is cleared before workqueue is scheduled and no races between two
>> workqueues for fast cache later. I'm not really against this patch, but
>> I have to try smth better.
>
>It is not "luck".  It does the correct thing as we never enter the
>while loop in __page_pool_request_shutdown() from a work-queue, but it
>is not obvious from the code.  The not-so-nice thing is that two
>work-queue shutdowns will be racing with each-other, in the multi
>netdev use-case, but access to the ptr_ring is safe/locked.

So, having this, and being prudent to generic code changes, lets roll back
to idea from v.4:
https://lkml.org/lkml/2019/6/25/996
but use changes from following patch, reintroducing page destroy:
https://www.spinics.net/lists/netdev/msg583145.html
with appropriate small modifications for cpsw.

In case of some issue connected with it (not supposed), or two/more
allocators used by cpsw, or one more driver having such multi ndev
capabilities (supposed), would be nice to use this link as reference
and it can be base for similar modifications.

Unless Jesper disagrees with this ofc.

I will send v7 soon after verification is completed.

-- 
Regards,
Ivan Khoronzhuk
