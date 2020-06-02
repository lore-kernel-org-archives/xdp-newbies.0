Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726000AbgFBQBt (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 2 Jun 2020 12:01:49 -0400
Received: by mail-ej1-f70.google.com with SMTP id r11so672995ejd.1
        for <xdp-newbies@vger.kernel.org>; Tue, 02 Jun 2020 09:01:44 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP_REDIRECT with xsks_map and dev_map
In-Reply-To: <CA+Jwd2z4_tGfh9wS_CJQL36O_vYyv5knXkm6=A+UvNNtojEcrw@mail.gmail.com>
References: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com> <87d06hzvr8.fsf@toke.dk> <CA+Jwd2z4_tGfh9wS_CJQL36O_vYyv5knXkm6=A+UvNNtojEcrw@mail.gmail.com>
Date: Tue, 02 Jun 2020 18:01:40 +0200
Message-ID: <877dwpmp7f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: maharishi bhargava <bhargavamaharishi@gmail.com>
Cc: xdp-newbies@vger.kernel.org

maharishi bhargava <bhargavamaharishi@gmail.com> writes:

> On Tue 2 Jun, 2020, 14:31 Toke Høiland-Jørgensen, <toke@redhat.com> wrote:
>>
>> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>>
>> > Hi, in my XDP program, I want to redirect some packets using AF_XDP
>> > and redirect other packets directly from driver space.
>> > Redirection through AF_XDP works fine, but redirection through dev map
>> > stops after some packets are processed.
>>
>> Do you mean it stops even if you are *only* redirecting to a devmap, or
>> if you are first redirecting a few packets to AF_XDP, then to devmap?
>>
>> Also, which driver(s) are the physical NICs you're redirecting to/from
>> using, and which kernel version are you on?
>>
>> -Toke
>
>
>
> Currently, I'm trying to redirect packets only using devmap. But also
> have code for redirection using AF_XDP(only when a given condition is
> satisfied). A DPDK program is running in userspace which will receive
> packets from AF_XDP.

Right, so it's just devmap redirect that breaks. What do you mean
'redirection stops', exactly? How are you seeing this? Does xdp_monitor
(from samples/bpf) report any exceptions?

-Toke
