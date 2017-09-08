Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:48297 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755564AbdIHPf2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 8 Sep 2017 11:35:28 -0400
Message-ID: <59B2B8BB.4050302@iogearbox.net>
Date: Fri, 08 Sep 2017 17:35:23 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
Subject: Re: Accessing userspace created persistent eBPF maps from kernel
 bpf restricted C
References: <CABUc5FF3Lx=7ECCT_bzxcbKHkXX1Vs66KJHabJExqTJ8Bz0VgA@mail.gmail.com> <CAC1LvL0kQqKJtqo-ea1qonvKVbKaUkhk=QUSBZCVhmoC+tbCZQ@mail.gmail.com> <CABUc5FHPNjdauR-0OuK=P=Uvx81puBZ+cjnX6sMXDZQguCaAiw@mail.gmail.com> <20170907.191216.97579557710446095.davem@davemloft.net> <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
In-Reply-To: <CABUc5FG9rfn2RYvp4Y12407PGMXPgA-XzibyTn5zqW4O2oSsOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Kiran T <kiran.lkml@gmail.com>, David Miller <davem@davemloft.net>
Cc: Zvi Effron <zeffron@riotgames.com>, xdp-newbies@vger.kernel.org

On 09/08/2017 07:28 AM, Kiran T wrote:
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

If I understand you correctly, you have a map that contains some
kind of filter policy that you check before proceeding. The map
that contains this data is pinned in user space, but not immediately
available at load time, and you want to be able to insert or also
potentially replace this map with a different map when you need to
change the policy. Is the assumption correct that the key/value
format of the policy would be the same and known a-priori, plus the
map types will also be the same?

If I didn't get this wrong, then just use a map in map that was
suggested earlier. So you have a BPF_TYPE_ARRAY_OF_MAPS that is
pinned as well, and when you need to replace the maps at runtime,
then you fetch the fd of the pinned BPF_TYPE_ARRAY_OF_MAPS map
and update it with the inner fd of the pinned map containing the
new policy data. That way, you don't need to reload the BPF program
(which would be atomic as well, though).

In the case where the map could change also in terms of format,
then probably best would be (if you don't want to reload the whole
program and have all contained in it) that you make a tail call
from the main program to a program that processes this specific
map and that program makes another tail call to a different program
that continues processing. So you have a flow where prog A calls
prog B which calls prog C, and prog B is replaceable atomically
during runtime. If there is some need to pass data from A to B
or B to C, then just use a per CPU map as a scratch buffer.
