Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34583 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755563AbdIHRhC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Sep 2017 13:37:02 -0400
Received: by mail-pg0-f51.google.com with SMTP id q68so5916686pgq.1
        for <xdp-newbies@vger.kernel.org>; Fri, 08 Sep 2017 10:37:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABUc5FEhfB1XwdLh+i3oF2HJLOxaGhEckfRgVA=sHmyfzidYWg@mail.gmail.com>
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com>
 <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com>
 <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com>
 <20170907.191216.97579557710446095.davem@davemloft.net> <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
 <CAC1LvL08Jgn839KPvfPqzyuJbVQTosiUsvuFqtCey=oKzef1PQ@mail.gmail.com> <CABUc5FEhfB1XwdLh+i3oF2HJLOxaGhEckfRgVA=sHmyfzidYWg@mail.gmail.com>
From: Zvi Effron <zeffron@riotgames.com>
Date: Fri, 8 Sep 2017 10:37:00 -0700
Message-ID: <CAC1LvL2q6JNGaLH3oLTtBvz9S7482xsOECExPp-R1Kt0NNrPbg@mail.gmail.com>
Subject: Re: Accessing userspace created persistent eBPF maps from kernel bpf
 restricted C
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kiran T <kiran.lkml@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, brouer@redhat.com, David Miller <davem@davemloft.net>, xdp-newbies@vger.kernel.org

> Well, I have to switch between maps based on an "entity switch" in the
> producing the event.
> The map type and format is fixed and pinned.  Say it could be one per
> pid, if pid is the entity
> switch.  /sys/bpf/pidno could be the pinned location.  Based on the
> pid at the time of event,
> I want to consult the map of that pid so I can
> filter/aggregate/histogram events sent to user space.
> The "entity switch" could be  major:minor:inode, or other such as well
> (not easy to get from bpf now, but
> you get the idea).  I can't have one or just a few maps because the
> key value pairs will be
> different for different entity switches.  I might not filter if
> /sys/pid/pidno map is not present.

> Thanks for your suggestion (Zvi and Daniel).  I will explore
> BPF_TYPE_ARRAY_OF_MAPS  if it
> can fit this case.

It sounds like BPF_TYPE_HASH_OF_MAPS might be more of what you need,
then. It's the same as BPF_TYPE_ARRAY_OF_MAPS, only it allows for a
key instead of an index. You could use the major:minor:inode or
whatever as the key, and then your problem becomes how the eBPF
program can calculate the key.

Good luck!
--Zvi
