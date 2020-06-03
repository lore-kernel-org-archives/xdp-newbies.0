Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24497 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725882AbgFCKtb (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 3 Jun 2020 06:49:31 -0400
Received: by mail-ed1-f70.google.com with SMTP id s14so892804edr.7
        for <xdp-newbies@vger.kernel.org>; Wed, 03 Jun 2020 03:49:28 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: XDP_REDIRECT with xsks_map and dev_map
In-Reply-To: <CA+Jwd2xnb8Nuc6Y2V=04fBa2bXfaMy1FPyK8CsFnOkqyxrtEwg@mail.gmail.com>
References: <CA+Jwd2y5Pjh+QMrH9vjBtHhvG2EC1MCfm-A2Pq2hjRPEvJ1J1Q@mail.gmail.com> <87d06hzvr8.fsf@toke.dk> <CA+Jwd2z4_tGfh9wS_CJQL36O_vYyv5knXkm6=A+UvNNtojEcrw@mail.gmail.com> <877dwpmp7f.fsf@toke.dk> <CA+Jwd2xnb8Nuc6Y2V=04fBa2bXfaMy1FPyK8CsFnOkqyxrtEwg@mail.gmail.com>
Date: Wed, 03 Jun 2020 12:49:25 +0200
Message-ID: <87lfl4l8zu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Transfer-Encoding: 8bit
To: maharishi bhargava <bhargavamaharishi@gmail.com>
Cc: xdp-newbies@vger.kernel.org

maharishi bhargava <bhargavamaharishi@gmail.com> writes:

> On Tue, Jun 2, 2020 at 9:31 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>>
>> > On Tue 2 Jun, 2020, 14:31 Toke Høiland-Jørgensen, <toke@redhat.com> wrote:
>> >>
>> >> maharishi bhargava <bhargavamaharishi@gmail.com> writes:
>> >>
>> >> > Hi, in my XDP program, I want to redirect some packets using AF_XDP
>> >> > and redirect other packets directly from driver space.
>> >> > Redirection through AF_XDP works fine, but redirection through dev map
>> >> > stops after some packets are processed.
>> >>
>> >> Do you mean it stops even if you are *only* redirecting to a devmap, or
>> >> if you are first redirecting a few packets to AF_XDP, then to devmap?
>> >>
>> >> Also, which driver(s) are the physical NICs you're redirecting to/from
>> >> using, and which kernel version are you on?
>> >>
>> >> -Toke
>> >
>> >
>> >
>> > Currently, I'm trying to redirect packets only using devmap. But also
>> > have code for redirection using AF_XDP(only when a given condition is
>> > satisfied). A DPDK program is running in userspace which will receive
>> > packets from AF_XDP.
>>
>> Right, so it's just devmap redirect that breaks. What do you mean
>> 'redirection stops', exactly? How are you seeing this? Does xdp_monitor
>> (from samples/bpf) report any exceptions?
>>
>> -Toke
>>
> So, In my setup, there are three systems, Let's Assume A, B, C. System
> B is acting as a forwarder between A and C. So I can see the number of
> packets received at system C. To be specific, only 1024 packets are
> received. If I remove the xsks_map part from the code and don't run
> DPDK in userspace. This problem does not occur. Also if I forward all
> the packets using AF_XDP, there is no such issue.

I thought you said you were seeing the problem when only redirecting to
a devmap? So why does the xsk_map code impact this? I think you may have
to share some code...

Also, what does xdp_monitor say?

-Toke
