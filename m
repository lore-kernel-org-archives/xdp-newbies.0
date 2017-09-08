Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36468 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753545AbdIHQma (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Sep 2017 12:42:30 -0400
Received: by mail-oi0-f49.google.com with SMTP id x190so17719472oix.3
        for <xdp-newbies@vger.kernel.org>; Fri, 08 Sep 2017 09:42:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC1LvL08Jgn839KPvfPqzyuJbVQTosiUsvuFqtCey=oKzef1PQ@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
 <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
 <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
 <20170907.191216.97579557710446095.davem@davemloft.net> <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
 <CAC1LvL08Jgn839KPvfPqzyuJbVQTosiUsvuFqtCey=oKzef1PQ@mail.gmail.com>
From: Kiran T <kiran.lkml@gmail.com>
Date: Fri, 8 Sep 2017 09:42:29 -0700
Message-ID: <CABUc5FEhfB1XwdLh+i3oF2HJLOxaGhEckfRgVA=sHmyfzidYWg@mail.gmail.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>, daniel@iogearbox.net, brouer@redhat.com
Cc: David Miller <davem@davemloft.net>, xdp-newbies@vger.kernel.org

On Thu, Sep 7, 2017 at 11:34 PM, Zvi Effron <zeffron@riotgames.com> wrote:
...
>
> I'm not sure entirely how, since I have only just started playing with
> this map type, but I suspect a workaround is possible with
> BPF_TYPE_ARRAY_OF_MAPS. My suspicion is that you could store the map
> you want to replace at index 0 in a pinned array of maps. The XDP
> program would load the map out of the array to use it.
>
> To change the map, have a userspace program load the new map, then set
> it as index 0 in the pinned array of maps. The next time the XDP
> program runs, it will pull the new map from index 0.
>

Well, I have to switch between maps based on an "entity switch" in the
producing the event.
The map type and format is fixed and pinned.  Say it could be one per
pid, if pid is the entity
switch.  /sys/bpf/pidno could be the pinned location.  Based on the
pid at the time of event,
I want to consult the map of that pid so I can
filter/aggregate/histogram events sent to user space.
The "entity switch" could be  major:minor:inode, or other such as well
(not easy to get from bpf now, but
you get the idea).  I can't have one or just a few maps because the
key value pairs will be
different for different entity switches.  I might not filter if
/sys/pid/pidno map is not present.

I guess this is not easy right now because of the way maps are
implemented right now,
with the verifier doing the magic fixup at the load time.  But as BPF
usage increases, these
kind of use cases will start popping up :)

Thanks for your suggestion (Zvi and Daniel).  I will explore
BPF_TYPE_ARRAY_OF_MAPS  if it
can fit this case.

Thanks,
Kiran
