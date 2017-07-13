Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51094 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753136AbdGMUk4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 13 Jul 2017 16:40:56 -0400
Date: Thu, 13 Jul 2017 13:40:53 -0700 (PDT)
Message-Id: <20170713.134053.1483450494416252217.davem@davemloft.net>
Subject: Re: XDP for Kernel by-pass?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be>
References: <1667638588.29757437.1499974457843.JavaMail.zimbra@ulg.ac.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: tom.barbette@ulg.ac.be
Cc: xdp-newbies@vger.kernel.org

From: tom.barbette@ulg.ac.be
Date: Thu, 13 Jul 2017 21:34:17 +0200 (CEST)

> Can XDP be used for "skbuff bypass"? Like a rx_handler but closer to
> the driver? I'm not very familiar with eBPF, could it be used to
> pass the kernel to any kernel module or userspace application?

Absolutely not.

> It looks to me that bpf_func in struct bpf_prog could be any
> function that we could use to deviate XDP and use it for that
> purpose. Correct?

The list of functions and data that a bpf program can access is
extremely strictly controlled.

Only specific "BPF helper" functions can be invoked, and only specific
pieces of data can be accessed in very strictly controlled ways.

It is specifically designed to not be a bypass facility, but rather
a mechanism by which one can implement arbitrary policy and software
programmable networking.

Things like the OVS switching plane, or a bridge, or whatever
forwarding facility you can imagine, can be fully implemented with
eBPF and the latest work being done by John Fastabend.

It is not necessary to access "arbitrary kernel modules and data"
in order to facilitate this.
