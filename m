Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:45228 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754885AbeAIRlk (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Jan 2018 12:41:40 -0500
Received: by mail-it0-f48.google.com with SMTP id x42so8968967ita.4
        for <xdp-newbies@vger.kernel.org>; Tue, 09 Jan 2018 09:41:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180109.121815.1887159110291802405.davem@davemloft.net>
References: <CALDO+SbE7bgqV96PqJg=1UZ6CiEGFGyJxkT-Nv=w0EuTON57mQ@mail.gmail.com>
 <20180108161209.7b872c50@xeon-e3> <CALDO+SbEjrrCAxVtq90W_b6K011Fv90GL9srea1+Bb6wUTBYPQ@mail.gmail.com>
 <20180109.121815.1887159110291802405.davem@davemloft.net>
From: William Tu <u9012063@gmail.com>
Date: Tue, 9 Jan 2018 09:40:59 -0800
Message-ID: <CALDO+SZfAi=9xL6vHwS_zXy+P8HVUQMnE0joEB5ib8zChmL2uQ@mail.gmail.com>
Subject: Re: Generic XDP and veth
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: Stephen Hemminger <stephen@networkplumber.org>, Daniel Borkmann <daniel@iogearbox.net>, Matteo Bertrone <matteo.bertrone@polito.it>, Xdp <xdp-newbies@vger.kernel.org>

On Tue, Jan 9, 2018 at 9:18 AM, David Miller <davem@davemloft.net> wrote:
> From: William Tu <u9012063@gmail.com>
> Date: Tue, 9 Jan 2018 09:08:08 -0800
>
>> But that means I should at lease see the first TCP SYN from my BPF
>> program, and only the later retries get dropped. However, I didn't
>> any. Maybe I still missing something?
>
> The first SYN will be a clone too.
>
> Every packet TCP might have to retransmit will be cloned.

I see, thank you.
Just to clarify, this test_xdp_redirect.sh won't work for TCP because
it uses veth peer, so we receive a skb_cloned TCP packets. I assume
the normal use case, which attaches non-veth device, the XDP generic
can process the packet.

Any reason XDP generic skips the skb_cloned packet? I search previous
patches mention
v4: - Do not perform generic XDP on reinjected packets (DaveM)
but didn't see discussion.

Thanks!
William
