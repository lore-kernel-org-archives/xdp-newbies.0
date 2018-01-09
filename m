Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:35276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeAIRwE (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Jan 2018 12:52:04 -0500
Date: Tue, 09 Jan 2018 12:52:03 -0500 (EST)
Message-Id: <20180109.125203.789715719632293985.davem@davemloft.net>
Subject: Re: Generic XDP and veth
From: David Miller <davem@davemloft.net>
In-Reply-To: <CALDO+SZfAi=9xL6vHwS_zXy+P8HVUQMnE0joEB5ib8zChmL2uQ@mail.gmail.com>
References: <CALDO+SbEjrrCAxVtq90W_b6K011Fv90GL9srea1+Bb6wUTBYPQ@mail.gmail.com>
        <20180109.121815.1887159110291802405.davem@davemloft.net>
        <CALDO+SZfAi=9xL6vHwS_zXy+P8HVUQMnE0joEB5ib8zChmL2uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: u9012063@gmail.com
Cc: stephen@networkplumber.org, daniel@iogearbox.net, matteo.bertrone@polito.it, xdp-newbies@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Tue, 9 Jan 2018 09:40:59 -0800

> Any reason XDP generic skips the skb_cloned packet? I search previous
> patches mention
> v4: - Do not perform generic XDP on reinjected packets (DaveM)
> but didn't see discussion.

We wanted to avoid re-running XDP on packets re-injected during input
packet processing.

The physical outermost XDP device would never see such packets.

I guess we have to decide whether to remove that restriction or not.
If we do, we have to copy the packet when it is cloned because cloned
packets cannot be modified and XDP programs can modify packet data.
