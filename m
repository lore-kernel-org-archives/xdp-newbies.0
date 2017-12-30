Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35803 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdL3V2O (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 30 Dec 2017 16:28:14 -0500
Received: by mail-pf0-f196.google.com with SMTP id j124so23373486pfc.2
        for <xdp-newbies@vger.kernel.org>; Sat, 30 Dec 2017 13:28:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cc903869-4a06-6038-d17d-42daf3362969@gmail.com>
References: <CAM7NYTiM2CtPPm4u3Rr9G0zRZrpmZq_3Rcb0H3dyS1xFZ+LzMA@mail.gmail.com>
 <cc903869-4a06-6038-d17d-42daf3362969@gmail.com>
From: "MD I. Islam" <tamim@csebuet.org>
Date: Sat, 30 Dec 2017 16:27:53 -0500
Message-ID: <CAM7NYThmvofbSJ78ovsaAUSd+gSVuunbvxYSVZV_eq2HG-0ptw@mail.gmail.com>
Subject: Re: IP forwarding and eBPF
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On Thu, Dec 28, 2017 at 11:34 PM, David Ahern <dsahern@gmail.com> wrote:
> On 12/28/17 9:37 PM, MD I. Islam wrote:
>> Hi
>>
>> Is XDP designed for implementing packet forwarding? Is there an
>> example of ipv4 forwarding the kernel? I don't find any example in
>> samples/bpf/ directory.
>
> samples/bpf/xdp_router_ipv4_*.c
>
> I have a POC on using new helpers that allow BPF programs to leverage
> kernel FIB and neighbor tables:
>    https://github.com/dsahern/linux/commits/bpf/xdp-fwding-wip
>
> It shows a 400% increase in forwarding. A lot of issues need to be
> addressed, but it shows the intent.

Thanks David! I see the intent. I understand the benefit of XDP
compared to sk_buff.

Could anyone explain why we need eBPF (in case I don't need to inject
a program from userspace)? Why we don't implement XDP forwarding logic
completely inside kernel? CETH [1] seems to be doing something like
that but the code is not open source right now. Is there any other
example like that? I'm planning to use XDP on a multi/many core CPU. I
would like to implement the forwarding logic in as kernel thread. Then
each CPU core (except one) would execute the kernel thread
independently (as DPDK). That's why, I was wondering if forwarding
logic can be implemented as a work_struct->func so that it can be
executed through work_queue. Looking forward to your suggestions.

1. https://www.slideshare.net/IOVisor/ceth-for-xdp-linux-meetup-santa-clara-july-2016
