Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:40672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751780AbdIHCMT (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 7 Sep 2017 22:12:19 -0400
Date: Thu, 07 Sep 2017 19:12:16 -0700 (PDT)
Message-Id: <20170907.191216.97579557710446095.davem@davemloft.net>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel
 bpf restricted C
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
        <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
        <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: kiran.lkml@gmail.com
Cc: zeffron@riotgames.com, xdp-newbies@vger.kernel.org

From: Kiran T <kiran.lkml@gmail.com>
Date: Thu, 7 Sep 2017 17:46:47 -0700

> If maps can be made persistent from userspace, but the kernel side
> bpf can't quite access it, it doesn't make much sense :(

Pinning is so that an unload of a BPF program doesn't cause it's maps
to go away.

It's designed so that things like statistics can be persistent across
BPF program loads.

So you can load and unload a BPF program multiple times, and you won't
lose the statistic increments done by earlier instances.
