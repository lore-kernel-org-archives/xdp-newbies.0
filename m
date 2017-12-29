Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:39959 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdL2Rqw (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 29 Dec 2017 12:46:52 -0500
Received: by mail-oi0-f65.google.com with SMTP id w125so29124372oie.7
        for <xdp-newbies@vger.kernel.org>; Fri, 29 Dec 2017 09:46:52 -0800 (PST)
Date: Fri, 29 Dec 2017 09:46:46 -0800
In-Reply-To: <20171229102959.3e3f6f73@redhat.com>
References: <CAM7NYTiM2CtPPm4u3Rr9G0zRZrpmZq_3Rcb0H3dyS1xFZ+LzMA@mail.gmail.com> <cc903869-4a06-6038-d17d-42daf3362969@gmail.com> <DE933F2D-F7BC-41E7-A297-FD006AA6E738@gmail.com> <20171229102959.3e3f6f73@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: IP forwarding and eBPF
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4C355750-27BB-41A6-89CB-DC859A91944A@gmail.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, "MD I. Islam" <tamim@csebuet.org>, xdp-newbies@vger.kernel.org, Tom Herbert <tom@herbertland.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>

On December 29, 2017 1:29:59 AM PST, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>On Thu, 28 Dec 2017 21:19:26 -0800
>Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>> On December 28, 2017 8:34:24 PM PST, David Ahern <dsahern@gmail.com>
>wrote:
>> >On 12/28/17 9:37 PM, MD I. Islam wrote:  
>> >> Hi
>> >> 
>> >> Is XDP designed for implementing packet forwarding? Is there an
>> >> example of ipv4 forwarding the kernel? I don't find any example in
>> >> samples/bpf/ directory.  
>> >
>> >samples/bpf/xdp_router_ipv4_*.c
>> >
>> >I have a POC on using new helpers that allow BPF programs to
>leverage
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
>Yes, and we will get there.  Once the OpenWRT/LEDE drivers actually
>implement XDP support in their drivers ;-). And more drivers support
>XDP_REDIRECT.
>
>That said, I would not recommend (re)implementing a NAT fastpath in
>XDP.
>It is doable, but will require an advanced eBPF prog that keep state
>(via maps) etc.  For now I recommend falling back to Netfilter NAT for
>this purpose.  Pure routing (no NAT) on a embedded device could be
>accelerated a lot with this approach.
>
>Instead of trying to re-implementing everything in XDP, I instead want
>you/people to think about how XDP can cooperate with and
>software-offload part of the Linux network stack.
> This is exactly what samples/bpf/xdp_router_ipv4_*.c and David Ahern
>is doing.  Notice that these solutions leverage the existing IPv4
>routing table for lookups, which means that all existing tools remains
>the same, while XDP can software-offload and accelerate the basic IPv4
>routing step.  It is important to limited the scope, IMHO advanced
>routing (e.g. with multiple route-tables, ToS match/routing etc) should
>fallback to the normal Linux network stack, and not be handled by XDP.

Sure, I am not thinking about reimplementing everything, just trying to leverage XDP where and when it makes sense to avoid lots of cache trashing per packet on devices that already pathologically suffer from small I and D cache sizes. The goal would be to leverage the existing nefilter infrastructure and use it, not replace it or supplement it.

With Pablo's latest flow offload work, I would be expecting the higher end devices that feature HW NATP to be finally supported, but there are still lower end devices for which none of that exists, and where a SW fastpath using XDP would be great to have, for routing and not just that.

Thanks

-- 
Florian
