Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:53920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759075AbdENPxA (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sun, 14 May 2017 11:53:00 -0400
Date: Sun, 14 May 2017 11:52:59 -0400 (EDT)
Message-Id: <20170514.115259.2132129698949658762.davem@davemloft.net>
Subject: Re: Contextually speaking...
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAFkxUYVNTPxaO02AsV-ur3cgXoK-diZLxF9LMOjZupw0j67h9Q@mail.gmail.com>
References: <20170513.183628.2041405131228393819.davem@davemloft.net>
        <CAFkxUYVNTPxaO02AsV-ur3cgXoK-diZLxF9LMOjZupw0j67h9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: nikita.vetoshkin@gmail.com
Cc: xdp-newbies@vger.kernel.org

From: Vetoshkin Nikita <nikita.vetoshkin@gmail.com>
Date: Sun, 14 May 2017 07:16:45 +0000

> As I understand from a C compiler point of view ->data and ->data_end are
> just arbitrary pointers embedded in a struct. Where does this semantics
> arises from? I.e. how does eBPF verifier knows that data ends where
> data_end points to?

Please do not top-post.

When the program runs, the invocation point sets ->data to skb->data
and ->data_end to "skb->data + skb->len" or something similar.

The kernel is in full control of the values set there in the context,
and that's why the verifier may assume these properties.  The verifier
executes in the kernel where the semantics are guaranteed.
