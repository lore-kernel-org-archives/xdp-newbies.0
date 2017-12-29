Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:41279 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdL2Qng (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 29 Dec 2017 11:43:36 -0500
Received: by mail-qk0-f174.google.com with SMTP id a8so15977267qkb.8
        for <xdp-newbies@vger.kernel.org>; Fri, 29 Dec 2017 08:43:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171229102959.3e3f6f73@redhat.com>
References: <CAM7NYTiM2CtPPm4u3Rr9G0zRZrpmZq_3Rcb0H3dyS1xFZ+LzMA@mail.gmail.com>
 <cc903869-4a06-6038-d17d-42daf3362969@gmail.com> <DE933F2D-F7BC-41E7-A297-FD006AA6E738@gmail.com>
 <20171229102959.3e3f6f73@redhat.com>
From: Tom Herbert <tom@herbertland.com>
Date: Fri, 29 Dec 2017 08:43:34 -0800
Message-ID: <CALx6S34TTvjbb6d7dSjutSRY2VvOHVe7CvQftmm=G4nQNMwfiA@mail.gmail.com>
Subject: Re: IP forwarding and eBPF
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, David Ahern <dsahern@gmail.com>, "MD I. Islam" <tamim@csebuet.org>, xdp-newbies@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>

On Fri, Dec 29, 2017 at 1:29 AM, Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
> On Thu, 28 Dec 2017 21:19:26 -0800
> Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>> On December 28, 2017 8:34:24 PM PST, David Ahern <dsahern@gmail.com> wrote:
>> >On 12/28/17 9:37 PM, MD I. Islam wrote:
>> >> Hi
>> >>
>> >> Is XDP designed for implementing packet forwarding? Is there an
>> >> example of ipv4 forwarding the kernel? I don't find any example in
>> >> samples/bpf/ directory.
>> >
>> >samples/bpf/xdp_router_ipv4_*.c
>> >
>> >I have a POC on using new helpers that allow BPF programs to leverage
>> >kernel FIB and neighbor tables:
>> >   https://github.com/dsahern/linux/commits/bpf/xdp-fwding-wip
>> >
>> >It shows a 400% increase in forwarding. A lot of issues need to be
>> >addressed, but it shows the intent.
>>
>> Nice! What would be uber cool is a NATP fastpath implemented using
>> XDP. Now that eBPF for ARM32 has landed it would enable a lot of
>> platforms.
>
> Yes, and we will get there.  Once the OpenWRT/LEDE drivers actually
> implement XDP support in their drivers ;-). And more drivers support
> XDP_REDIRECT.
>
> That said, I would not recommend (re)implementing a NAT fastpath in XDP.
> It is doable, but will require an advanced eBPF prog that keep state
> (via maps) etc.  For now I recommend falling back to Netfilter NAT for
> this purpose.  Pure routing (no NAT) on a embedded device could be
> accelerated a lot with this approach.
>
> Instead of trying to re-implementing everything in XDP, I instead want
> you/people to think about how XDP can cooperate with and
> software-offload part of the Linux network stack.
>  This is exactly what samples/bpf/xdp_router_ipv4_*.c and David Ahern
> is doing.  Notice that these solutions leverage the existing IPv4
> routing table for lookups, which means that all existing tools remains
> the same, while XDP can software-offload and accelerate the basic IPv4
> routing step.  It is important to limited the scope, IMHO advanced
> routing (e.g. with multiple route-tables, ToS match/routing etc) should
> fallback to the normal Linux network stack, and not be handled by XDP.
>
+1

The ability for XDP to access kernel tables is critical. This supports
the model that XDP is acceleration for mechanisms of the stack and we
don't want to have to have two tables, one for stack and one for XDP,
that contain redundant information require double memory usage as well
as more to manage.

Tom

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
