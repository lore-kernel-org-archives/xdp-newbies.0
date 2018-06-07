Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53638 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753004AbeFGNZL (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 7 Jun 2018 09:25:11 -0400
Subject: Re: Is it possible to read from a dynamic offset in a packet?
References: <CAC1LvL21L=Zo2_5NQhyDVr8ciPwyExMhuAO2-7MQ97OPuV5y9A@mail.gmail.com>
From: Edward Cree <ecree@solarflare.com>
Message-ID: <8e8268eb-5a36-a260-2c4c-5db61b4f9db7@solarflare.com>
Date: Thu, 7 Jun 2018 14:24:57 +0100
MIME-Version: 1.0
In-Reply-To: <CAC1LvL21L=Zo2_5NQhyDVr8ciPwyExMhuAO2-7MQ97OPuV5y9A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>, Xdp <xdp-newbies@vger.kernel.org>

On 06/06/18 23:22, Zvi Effron wrote:
> Hi XDPeople!
>
> I've been having great success with reading data from fixed offsets in
> a packet/ethernet frame. But every time I try to read from a dynamic
> offset (e.g. read the last byte in the packet by using the packet
> length in the IP/UDP headers). It looks like once I add a register to
> a packet pointer, the range is reset to 0, and no amount of
> comparisons will restore a range.
>
> Looking through the verifier code, I believe I found where the range
> is getting set to 0
> (https://elixir.bootlin.com/linux/latest/source/kernel/bpf/verifier.c#L2695),
> and it looks like the risk of overflow
> (https://elixir.bootlin.com/linux/latest/source/kernel/bpf/verifier.c#L3267)
> is why the range doesn't get updated by later comparisons.
>
> Is there a way to do a read from a packet at a dynamic offset? If not,
> is that something that could potentially be added to the verifier? It
> feels like `if (packet_start <= packet_start + offset && packet_end >
> packet_start + offset)` is something that should be verifiable as
> safe, even with potential overflow in `packet_start + offset`?
>
> Thank you!
> --Zvi
I think that to make this work you need to bound the dynamic offset
 before you add it to the packet pointer.  So for instance if you read
 a packet length from the IP header, that's a u16 (so max. 0xffff), and
 it's then added to the offset of L4 (probably 14+20=34), giving a max.
 larger than MAX_PACKET_OFF.

So you need to do something like
  if (offset < 0xffff && packet_start + offset < packet_end)
 because the verifier isn't smart enough to learn anything from an
  if (ptr_to_packet <= ptr_to_packet + offset)
 check.  The trouble with the latter is that it's a piece of state that
 belongs both to the packet-pointer (which in the general case could be
 variably-offset already) and to the offset, so you'd need n² storage to
 record which (pointer, offset) pairs had been determined not to overflow.

HTH,
-Ed
