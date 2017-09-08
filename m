Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33377 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdIHF2e (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Sep 2017 01:28:34 -0400
Received: by mail-oi0-f46.google.com with SMTP id r20so9346380oie.0
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 22:28:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170907.191216.97579557710446095.davem@davemloft.net>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
 <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
 <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com> <20170907.191216.97579557710446095.davem@davemloft.net>
From: Kiran T <kiran.lkml@gmail.com>
Date: Thu, 7 Sep 2017 22:28:32 -0700
Message-ID: <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: David Miller <davem@davemloft.net>
Cc: Zvi Effron <zeffron@riotgames.com>, xdp-newbies@vger.kernel.org

On Thu, Sep 7, 2017 at 7:12 PM, David Miller <davem@davemloft.net> wrote:
...
>
> Pinning is so that an unload of a BPF program doesn't cause it's maps
> to go away.
>
> It's designed so that things like statistics can be persistent across
> BPF program loads.
>
> So you can load and unload a BPF program multiple times, and you won't
> lose the statistic increments done by earlier instances.

I understand.
However, I have a use case where  data used to filter perf events can
change and can
be loaded as a full map,  much after the bpf program is loaded.  The
map will be pinned,
but the bpf program currently has no way to access this map. Can this use case
be addressed?

Thanks,
Kiran
