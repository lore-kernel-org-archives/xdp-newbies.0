Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21532 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbfLFNEi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 6 Dec 2019 08:04:38 -0500
From: "Eelco Chaudron" <echaudro@redhat.com>
Subject: Re: Trying the bpf trace a bpf xdp program
Date: Fri, 06 Dec 2019 14:04:07 +0100
Message-ID: <78D7857B-82E4-42BC-85E1-E3D7C97BF840@redhat.com>
In-Reply-To: <CAH3MdRXr+3mUfrd8MPH-mDdNwD1szXRhz07s2C4dVQ0EkzDaAg@mail.gmail.com>
References: <E53E0693-1C3A-4B47-B205-DC8E5DAF3619@redhat.com>
 <CAADnVQKkLtG-QCZwxx-Bpz8-goh-_mSTtUSzpb_oTv9a-qLizg@mail.gmail.com>
 <3AC9D2B7-9D2F-4286-80A2-1721B51B62CF@redhat.com>
 <CAADnVQJKSnoMVpQ3F86zBhFyo8WQ0vi65Z4QDtopLRrpK4yB8Q@mail.gmail.com>
 <4BBF99E4-9554-44F7-8505-D4B8416554C4@redhat.com>
 <d588c894-a4e0-8b99-72a9-4429b27091df@fb.com>
 <056E9F5E-4FDD-4636-A43A-EC98A06E84D3@redhat.com>
 <aa59532b-34a9-7887-f550-ef2859f0c9f1@fb.com>
 <B7E0062E-37ED-46E6-AE64-EE3E2A0294EA@redhat.com>
 <7062345a-1060-89f6-0c02-eef2fe0d835a@fb.com>
 <b8d80047-3bc1-5393-76a1-7517cb2b7280@fb.com>
 <E08A0006-E254-492C-92AB-408B58E456C0@redhat.com>
 <F8CFD537-7907-4259-9C91-4649F799216B@redhat.com>
 <CAH3MdRXr+3mUfrd8MPH-mDdNwD1szXRhz07s2C4dVQ0EkzDaAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Y Song <ys114321@gmail.com>
Cc: Yonghong Song <yhs@fb.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Xdp <xdp-newbies@vger.kernel.org>, bpf <bpf@vger.kernel.org>



On 5 Dec 2019, at 18:35, Y Song wrote:

> On Thu, Dec 5, 2019 at 4:41 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:

>
> It is a little tricky. The below change can make verifier happy. I did
> not test it so not sure whether produces correct result or not.
>
> ==========
> struct xdp_rxq_info {
>         __u32 queue_index;
> } __attribute__((preserve_access_index));
>
> struct xdp_buff {
>         struct xdp_rxq_info *rxq;
> } __attribute__((preserve_access_index));
>
> BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
>             struct xdp_buff *, ctx, int, ret)
> {
>    __u32 rx_queue;
>
>    rx_queue = ctx->rxq->queue_index;
>    bpf_debug("fexit: queue = %u, ret = %d\n", rx_queue, ret);
>
>    return 0;
> }
> ==========
>
> In the above, I am using newly added clang attribute 
> "__preserve_access_index"
> (in llvm-project trunk since Nov. 13) to make code
> a little bit cleaner. The old way as in selftests fexit_bpf2bpf.c
> should work too.
>
> Basically, the argument for fexit function should be types actually
> passing to the jited function.
> For user visible 'xdp_md`. the jited function will receive `xdp_buff`.
> The access for each field
> sometimes is not one-to-one mapping. You need to check kernel code to
> find the correct
> way. We probably should make this part better to improve user 
> experience.
>

Thanks the hint that it should be the jitted arguments solved it… And 
you quick example worked, just in case some one else is playing with it, 
here is my working example:

// SPDX-License-Identifier: GPL-2.0
#include <linux/bpf.h>
#include "bpf_helpers.h"
#include "bpf_trace_helpers.h"

#define bpf_debug(fmt, ...)                \
{                                          \
     char __fmt[] = fmt;                    \
     bpf_trace_printk(__fmt, sizeof(__fmt), \
                      ##__VA_ARGS__);       \
}

struct net_device {
     /* Structure does not need to contain all entries,
      * as "preserve_access_index" will use BTF to fix this... */
     int                    ifindex;
} __attribute__((preserve_access_index));

struct xdp_rxq_info {
     /* Structure does not need to contain all entries,
      * as "preserve_access_index" will use BTF to fix this... */
     struct net_device *dev;
     __u32 queue_index;
} __attribute__((preserve_access_index));

struct xdp_buff {
     void *data;
     void *data_end;
     void *data_meta;
     void *data_hard_start;
     unsigned long handle;
     struct xdp_rxq_info *rxq;
} __attribute__((preserve_access_index));


BPF_TRACE_1("fentry/xdp_prog_simple", trace_on_entry,
             struct xdp_buff *, xdp)
{
     bpf_debug("fentry: [ifindex = %u, queue =  %u]\n",
               xdp->rxq->dev->ifindex, xdp->rxq->queue_index);
     return 0;
}


BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
             struct xdp_buff*, xdp, int, ret)
{
     bpf_debug("fexit: [ifindex = %u, queue =  %u, ret = %d]\n",
               xdp->rxq->dev->ifindex, xdp->rxq->queue_index, ret);

     return 0;
}

char _license[] SEC("license") = "GPL";
