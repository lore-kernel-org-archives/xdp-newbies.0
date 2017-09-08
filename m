Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35747 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753206AbdIHGeo (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Sep 2017 02:34:44 -0400
Received: by mail-pf0-f182.google.com with SMTP id g13so3187736pfm.2
        for <xdp-newbies@vger.kernel.org>; Thu, 07 Sep 2017 23:34:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
 <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
 <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
 <20170907.191216.97579557710446095.davem@davemloft.net> <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Thu, 7 Sep 2017 23:34:43 -0700
Message-ID: <CAC1LvL08Jgn839KPvfPqzyuJbVQTosiUsvuFqtCey=oKzef1PQ@mail.gmail.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kiran T <kiran.lkml@gmail.com>
Cc: David Miller <davem@davemloft.net>, xdp-newbies@vger.kernel.org

> However, I have a use case where  data used to filter perf events can
> change and can
> be loaded as a full map,  much after the bpf program is loaded.  The
> map will be pinned,
> but the bpf program currently has no way to access this map. Can this use case
> be addressed?

I'm not sure entirely how, since I have only just started playing with
this map type, but I suspect a workaround is possible with
BPF_TYPE_ARRAY_OF_MAPS. My suspicion is that you could store the map
you want to replace at index 0 in a pinned array of maps. The XDP
program would load the map out of the array to use it.

To change the map, have a userspace program load the new map, then set
it as index 0 in the pinned array of maps. The next time the XDP
program runs, it will pull the new map from index 0.

Maybe that will work for you?
--Zvi
