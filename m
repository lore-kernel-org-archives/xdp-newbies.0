Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:44538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752762AbdIHGLg (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Sep 2017 02:11:36 -0400
Date: Thu, 07 Sep 2017 23:11:30 -0700 (PDT)
Message-Id: <20170907.231130.1212330819578021120.davem@davemloft.net>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel
 bpf restricted C
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
References: <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
        <20170907.191216.97579557710446095.davem@davemloft.net>
        <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: kiran.lkml@gmail.com
Cc: zeffron@riotgames.com, xdp-newbies@vger.kernel.org

From: Kiran T <kiran.lkml@gmail.com>
Date: Thu, 7 Sep 2017 22:28:32 -0700

> On Thu, Sep 7, 2017 at 7:12 PM, David Miller <davem@davemloft.net> wrote:
> ...
>>
>> Pinning is so that an unload of a BPF program doesn't cause it's maps
>> to go away.
>>
>> It's designed so that things like statistics can be persistent across
>> BPF program loads.
>>
>> So you can load and unload a BPF program multiple times, and you won't
>> lose the statistic increments done by earlier instances.
> 
> I understand.
> However, I have a use case where  data used to filter perf events can
> change and can
> be loaded as a full map,  much after the bpf program is loaded.  The
> map will be pinned,
> but the bpf program currently has no way to access this map. Can this use case
> be addressed?

The BPF program has to know the type of the map and what it looks
like at compile time.  So what you are suggesting seems to be
impossible.
