Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35240 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbeA0H2I (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Sat, 27 Jan 2018 02:28:08 -0500
Received: by mail-vk0-f48.google.com with SMTP id n132so1645850vke.2
        for <xdp-newbies@vger.kernel.org>; Fri, 26 Jan 2018 23:28:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC1LvL1Ap80X=S5WWcFXqjCAgWocxMrW95cZiYy-8_qk45dGWQ@mail.gmail.com>
References: <1517003922.24241.10.camel@regit.org> <CAC1LvL1Ap80X=S5WWcFXqjCAgWocxMrW95cZiYy-8_qk45dGWQ@mail.gmail.com>
From: Y Song <ys114321@gmail.com>
Date: Fri, 26 Jan 2018 23:27:27 -0800
Message-ID: <CAH3MdRWtFMbagXwZWYyFTP_pEb3k6bLX3ZZt_TfWBFHx2Z5mOg@mail.gmail.com>
Subject: Re: Limit on max_entries of CPU_ARRAY_MAP
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Zvi Effron <zeffron@riotgames.com>
Cc: Eric Leblond <eric@regit.org>, Xdp <xdp-newbies@vger.kernel.org>, Jesper Dangaard Brouer <brouer@redhat.com>

Right. Most if not all maps(as I did not check everyone) has a roughly
4GB limit on total map memory consumption per map.
The return error code will be -E2BIG.

On Fri, Jan 26, 2018 at 7:05 PM, Zvi Effron <zeffron@riotgames.com> wrote:
> Hello,
>
> There is a hard limit, I've run into it before. Assuming the error
> you're getting is E2BIG (which I believe indicates you've hit the
> limit), then it's possible to figure out how much space (and how many
> entries) are available for what you're storing by looking at the code
> from https://elixir.free-electrons.com/linux/latest/source/kernel/bpf/hashtab.c#L304
> through line 341 (if I've traced things through the kernel correctly).
>
> In my project, I worked around the limitation by using a map of maps.
> That allowed me multiply the storage available to me and significantly
> go past the limit (I ran out of memory well before I couldn't create
> the map do to limitations).
>
> Best,
> --Zvi
>
> On Fri, Jan 26, 2018 at 1:58 PM, Eric Leblond <eric@regit.org> wrote:
>> Hello,
>>
>> I've just finished the initial version of eBPF and XDP support in
>> Suricata [1] (thanks Jesper for the help) and among other eBPF features
>> the code is using CPU_ARRAY_MAP to store a flow table in Ipv4 and IPv6.
>>
>> The max_entries is set to 32768 in the code [2] but I did give a try to
>> higher value. On my 8 cores system, the allocation of the memory for
>> the IPv6 table failed between 2000000 and 3000000.
>>
>> Is there some kind of hard limit or a formula to compute the max ?
>>
>> How will evolve performances if we increase the max_entries ?
>>
>> Link:
>> [1]: https://github.com/OISF/suricata/pull/3193
>> [2]: https://github.com/OISF/suricata/pull/3193/files#diff-97ad4f31d96b
>> db666457562cea00a57aR85
>>
>> Best regards,
>> --
>> Eric Leblond <eric@regit.org>
>> Blog: https://home.regit.org/
