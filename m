Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:34658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbeAIRSR (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Tue, 9 Jan 2018 12:18:17 -0500
Date: Tue, 09 Jan 2018 12:18:15 -0500 (EST)
Message-Id: <20180109.121815.1887159110291802405.davem@davemloft.net>
Subject: Re: Generic XDP and veth
From: David Miller <davem@davemloft.net>
In-Reply-To: <CALDO+SbEjrrCAxVtq90W_b6K011Fv90GL9srea1+Bb6wUTBYPQ@mail.gmail.com>
References: <CALDO+SbE7bgqV96PqJg=1UZ6CiEGFGyJxkT-Nv=w0EuTON57mQ@mail.gmail.com>
        <20180108161209.7b872c50@xeon-e3>
        <CALDO+SbEjrrCAxVtq90W_b6K011Fv90GL9srea1+Bb6wUTBYPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: u9012063@gmail.com
Cc: stephen@networkplumber.org, daniel@iogearbox.net, matteo.bertrone@polito.it, xdp-newbies@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Tue, 9 Jan 2018 09:08:08 -0800

> But that means I should at lease see the first TCP SYN from my BPF
> program, and only the later retries get dropped. However, I didn't
> any. Maybe I still missing something?

The first SYN will be a clone too.

Every packet TCP might have to retransmit will be cloned.
