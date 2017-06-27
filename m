Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52492 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbdF0V4D (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 27 Jun 2017 17:56:03 -0400
Message-ID: <5952D471.1050101@iogearbox.net>
Date: Tue, 27 Jun 2017 23:56:01 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: Calculating a hash from a eBPF program?
References: <1498596345.14503.1.camel@coverfire.com>
In-Reply-To: <1498596345.14503.1.camel@coverfire.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Dan Siemon <dan@coverfire.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

On 06/27/2017 10:45 PM, Dan Siemon wrote:
> [This isn't strictly an XDP question, I'm using cls_bpf but I don't
> know of a better place to ask]
>
> Is there a way to calculate a hash of a struct or other data from
> within an eBPF program? I need to build a classifier that can hash a
> flow encapsulated in protocols like PPPoE or GTP-U. Basically like
> cls_flow's use of jhash2 but at a different offset. I looked at the
> helpers in bpf.h but don't see anything helpful there.

Why no implement it inside the BPF prog like it's done here [1]
(the example is XDP but cls_bpf should work just as well)?

There's also a bpf_set_hash(struct __sk_buff *skb, u32 hash)
helper (net-next) for cls_bpf, where you can then use the jhash
result and set it as skb->hash.

   [1] http://lingrok.org/xref/linux-net-next/tools/testing/selftests/bpf/test_l4lb.c#26

> Thanks.
>
