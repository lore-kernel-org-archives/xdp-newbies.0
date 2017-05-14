Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:40472 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbdENMs6 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 14 May 2017 08:48:58 -0400
Message-ID: <59185235.8060005@iogearbox.net>
Date: Sun, 14 May 2017 14:48:53 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: Contextually speaking...
References: <20170513.183628.2041405131228393819.davem@davemloft.net> <CAFkxUYUspEE2T1cvENKg30MM1OuAccWvS+gnn4uCwDy2R2LRjw@mail.gmail.com>
In-Reply-To: <CAFkxUYUspEE2T1cvENKg30MM1OuAccWvS+gnn4uCwDy2R2LRjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Vetoshkin Nikita <nikita.vetoshkin@gmail.com>
Cc: David Miller <davem@davemloft.net>, xdp-newbies@vger.kernel.org

On 05/14/2017 09:19 AM, Vetoshkin Nikita wrote:
> As I understand from a C compiler point of view ->data and ->data_end
> are just arbitrary pointers embedded in a struct. Where does this
> semantics arises from? I.e. how does eBPF verifier knows that data
> ends where data_end points to?

The verifier only needs to match on data/data_end and makes sure the
program code making use of this is within their bounds. It doesn't
need to know the actual address at verification time. We do this, so
that read/write access to the packet can happen efficiently without
needing to call a helper function to perform the same (and without
having to perform a check on every single access), adding data/data_end
into the context also allows to do all this without changing BPF JIT
compilers. The actual address for data/data_end is filled into the
xdp_buff context structure shortly before the BPF program gets
executed in the driver.

Best,
Daniel
