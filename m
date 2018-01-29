Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:34761 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbeA2T1A (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 29 Jan 2018 14:27:00 -0500
Received: by mail-ua0-f174.google.com with SMTP id d1so5462199uak.1
        for <xdp-newbies@vger.kernel.org>; Mon, 29 Jan 2018 11:26:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC1LvL0UYWbmSbNKww_aO-QyrJ9MhZg_kTu-9GgzUU=87irQtQ@mail.gmail.com>
References: <1517003922.24241.10.camel@regit.org> <CAC1LvL1Ap80X=S5WWcFXqjCAgWocxMrW95cZiYy-8_qk45dGWQ@mail.gmail.com>
 <CAH3MdRWtFMbagXwZWYyFTP_pEb3k6bLX3ZZt_TfWBFHx2Z5mOg@mail.gmail.com> <CAC1LvL0UYWbmSbNKww_aO-QyrJ9MhZg_kTu-9GgzUU=87irQtQ@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Mon, 29 Jan 2018 11:26:18 -0800
Message-ID: <CAH3MdRVB5b3SDV7Qj0MdrZ-s5PChMeFOUtOcZS0jEnRr1G7+Og@mail.gmail.com>
Subject: Re: Limit on max_entries of CPU_ARRAY_MAP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: Eric Leblond <eric@regit.org>, Xdp <xdp-newbies@vger.kernel.org>, Jesper Dangaard Brouer <brouer@redhat.com>

On Mon, Jan 29, 2018 at 11:00 AM, Zvi Effron <zeffron@riotgames.com> wrote:
> Would it make sense to increase that limit for 64-bit systems? All of
> the comments on why that limit exists that I saw mentioned that
> userspace wouldn't be able to access all of the elements if it were
> bigger. But on a 64-bit system, shouldn't userspace be able to access
> more than 4GB?

Checking the git log history, it looks like if you try to allocate more than 4GB
in one shot in kernel through kmalloc. kmalloc could at least have warnings, and
not sure whether there are any other side effect or not.

commit 01b3f52157ff5a47d6d8d796f396a4b34a53c61d
Author: Alexei Starovoitov <ast@kernel.org>
Date:   Sun Nov 29 16:59:35 2015 -0800

    bpf: fix allocation warnings in bpf maps and integer overflow

    For large map->value_size the user space can trigger memory
allocation warnings like:
    WARNING: CPU: 2 PID: 11122 at mm/page_alloc.c:2989
    __alloc_pages_nodemask+0x695/0x14e0()
    Call Trace:
     [<     inline     >] __dump_stack lib/dump_stack.c:15
     [<ffffffff82743b56>] dump_stack+0x68/0x92 lib/dump_stack.c:50
     [<ffffffff81244ec9>] warn_slowpath_common+0xd9/0x140 kernel/panic.c:460
     [<ffffffff812450f9>] warn_slowpath_null+0x29/0x30 kernel/panic.c:493
     [<     inline     >] __alloc_pages_slowpath mm/page_alloc.c:2989
......

Some internal counting for # of hashtab buckets are u32 and hence try to avoid
overflow on these counters. But I presume this can be changed if there is no
other limiting factors.

>
> --Zvi
>
> On Fri, Jan 26, 2018 at 11:27 PM, Y Song <ys114321@gmail.com> wrote:
>> Right. Most if not all maps(as I did not check everyone) has a roughly
>> 4GB limit on total map memory consumption per map.
>> The return error code will be -E2BIG.
>>
>> On Fri, Jan 26, 2018 at 7:05 PM, Zvi Effron <zeffron@riotgames.com> wrote:
>>> Hello,
>>>
>>> There is a hard limit, I've run into it before. Assuming the error
>>> you're getting is E2BIG (which I believe indicates you've hit the
>>> limit), then it's possible to figure out how much space (and how many
>>> entries) are available for what you're storing by looking at the code
>>> from https://elixir.free-electrons.com/linux/latest/source/kernel/bpf/hashtab.c#L304
>>> through line 341 (if I've traced things through the kernel correctly).
>>>
>>> In my project, I worked around the limitation by using a map of maps.
>>> That allowed me multiply the storage available to me and significantly
>>> go past the limit (I ran out of memory well before I couldn't create
>>> the map do to limitations).
>>>
>>> Best,
>>> --Zvi
>>>
>>> On Fri, Jan 26, 2018 at 1:58 PM, Eric Leblond <eric@regit.org> wrote:
>>>> Hello,
>>>>
>>>> I've just finished the initial version of eBPF and XDP support in
>>>> Suricata [1] (thanks Jesper for the help) and among other eBPF features
>>>> the code is using CPU_ARRAY_MAP to store a flow table in Ipv4 and IPv6.
>>>>
>>>> The max_entries is set to 32768 in the code [2] but I did give a try to
>>>> higher value. On my 8 cores system, the allocation of the memory for
>>>> the IPv6 table failed between 2000000 and 3000000.
>>>>
>>>> Is there some kind of hard limit or a formula to compute the max ?
>>>>
>>>> How will evolve performances if we increase the max_entries ?
>>>>
>>>> Link:
>>>> [1]: https://github.com/OISF/suricata/pull/3193
>>>> [2]: https://github.com/OISF/suricata/pull/3193/files#diff-97ad4f31d96b
>>>> db666457562cea00a57aR85
>>>>
>>>> Best regards,
>>>> --
>>>> Eric Leblond <eric@regit.org>
>>>> Blog: https://home.regit.org/
