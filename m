Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:38174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfF2RxH (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 29 Jun 2019 13:53:07 -0400
Date: Sat, 29 Jun 2019 10:53:06 -0700 (PDT)
Message-Id: <20190629.105306.762888643756822083.davem@davemloft.net>
Subject: Re: [PATCH net-next] xdp: xdp_umem: fix umem pages mapping for
 32bits systems
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com>
References: <20190626155911.13574-1-ivan.khoronzhuk@linaro.org>
        <CAJ+HfNid3PntipAJHuPR-tQudf+E6UQK6mPDHdc0O=wCUSjEEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: bjorn.topel@gmail.com
Cc: ivan.khoronzhuk@linaro.org, bjorn.topel@intel.com, magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org

From: Björn Töpel <bjorn.topel@gmail.com>
Date: Wed, 26 Jun 2019 22:50:23 +0200

> On Wed, 26 Jun 2019 at 17:59, Ivan Khoronzhuk
> <ivan.khoronzhuk@linaro.org> wrote:
>>
>> Use kmap instead of page_address as it's not always in low memory.
>>
> 
> Ah, some 32-bit love. :-) Thanks for working on this!
> 
> For future patches, please base AF_XDP patches on the bpf/bpf-next
> tree instead of net/net-next.
> 
> Acked-by: Björn Töpel <bjorn.topel@intel.com>

Alexei and Daniel, I'll let you guys take this one.

Thanks.
