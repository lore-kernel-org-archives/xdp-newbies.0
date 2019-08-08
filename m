Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42621 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404263AbfHHRVU (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 8 Aug 2019 13:21:20 -0400
Received: by mail-ed1-f67.google.com with SMTP id v15so91710923eds.9
        for <xdp-newbies@vger.kernel.org>; Thu, 08 Aug 2019 10:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <20190807150010.1a58a1d2@carbon> <CAC1LvL29KS9CKcXYwR4EHeNo7++i4hYQuXfY5OLtbPFDVUO2mw@mail.gmail.com>
 <20190808112955.5a29c9e1@carbon>
In-Reply-To: <20190808112955.5a29c9e1@carbon>
From: Zvi Effron <zeffron@riotgames.com>
Date: Thu, 8 Aug 2019 12:21:06 -0500
Message-ID: <CAC1LvL2Z7VMykO0nK3mxN=RseYGEHgjD8=hKQz0EXWWN3c1QRA@mail.gmail.com>
Subject: Re: [bpf-next PATCH 0/3] bpf: improvements to xdp_fwd sample
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, Anton Protopopov <a.s.protopopov@gmail.com>, dsahern@gmail.com, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Thu, Aug 8, 2019 at 4:30 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> Another improvement from Toke, is that the bpf_redirect_map() helper,
> now also check if the redirect index is valid in the map.  If not, then
> it returns another value than XDP_REDIRECT.  You can choose the
> alternative return value yourself, via "flags" e.g. XDP_PASS.  Thus,
> you don't even need to check/validate devmap in your BPF-code, as it is
> part of the bpf_redirect_map() call now.
>
>  action = bpf_redirect_map(&map, &index, flags_as_xdp_value)
>
> The default flags used in most programs today is 0, which maps to
> XDP_ABORTED.  This is sort of a small UAPI change, but for the better.
> As today, the packet is dropped later, only diagnose/seen via
> tracepoint xdp:xdp_redirect_map_err.
>
That's great to hear, as I'd thought it already worked that way (minus
the flags to specify what the alternate action is).

Thanks for explaining!

--Zvi
