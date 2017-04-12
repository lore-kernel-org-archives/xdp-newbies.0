Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:36574 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754599AbdDLTyW (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 12 Apr 2017 15:54:22 -0400
Received: by mail-pg0-f49.google.com with SMTP id g2so19419930pge.3
        for <xdp-newbies@vger.kernel.org>; Wed, 12 Apr 2017 12:54:22 -0700 (PDT)
Subject: Re: [PATCH v3 net-next RFC] Generic XDP
References: <20170412.145415.1441440342830198148.davem@davemloft.net>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <0861d2c9-a5ec-f40e-b849-f6421938b357@cumulusnetworks.com>
Date: Wed, 12 Apr 2017 13:54:20 -0600
MIME-Version: 1.0
In-Reply-To: <20170412.145415.1441440342830198148.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc: xdp-newbies@vger.kernel.org

On 4/12/17 12:54 PM, David Miller wrote:
> 
> This provides a generic SKB based non-optimized XDP path which is used
> if either the driver lacks a specific XDP implementation, or the user
> requests it via a new IFLA_XDP_FLAGS value named XDP_FLAGS_SKB_MODE.
> 
> It is arguable that perhaps I should have required something like
> this as part of the initial XDP feature merge.
> 
> I believe this is critical for two reasons:
> 
> 1) Accessibility.  More people can play with XDP with less
>    dependencies.  Yes I know we have XDP support in virtio_net, but
>    that just creates another depedency for learning how to use this
>    facility.
> 
>    I wrote this to make life easier for the XDP newbies.
> 
> 2) As a model for what the expected semantics are.  If there is a pure
>    generic core implementation, it serves as a semantic example for
>    driver folks adding XDP support.
> 
> This is just a rough draft and is untested.


packet passed to xdp seems to be messed up. Using samples/bpf/xdp1*.c as
an example:

Current with virtio-net:
# xdp1 3
proto 0:          0 pkt/s
proto 6:          2 pkt/s
proto 17:       1610 pkt/s
proto 17:      22785 pkt/s

Using the skb-mode:

# xdp1 3 skb-mode
proto 0:          2 pkt/s
proto 0:      10880 pkt/s
proto 0:      29990 pkt/s
proto 0:      16972 pkt/s


If I change ipproto in samples/bpf/xdp1_kern.c:

        if (h_proto == htons(ETH_P_IP))
                ipproto = parse_ipv4(data, nh_off, data_end);
        else if (h_proto == htons(ETH_P_IPV6))
                ipproto = parse_ipv6(data, nh_off, data_end);
        else
                ipproto = 63;

I get:

# xdp1 3 skb-mode
proto 63:       6538 pkt/s
proto 63:      23679 pkt/s
proto 63:      29974 pkt/s
proto 63:      29599 pkt/s

which suggests h_proto is goofed up with skb-mode.
