Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21351 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgFJVJl (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 17:09:41 -0400
Received: by mail-ej1-f70.google.com with SMTP id p27so1682866ejn.5
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Jun 2020 14:09:37 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: Lightweight packet timestamping
In-Reply-To: <DB7PR08MB31304BCD517885F0E1C063F69E830@DB7PR08MB3130.eurprd08.prod.outlook.com>
References: <DB7PR08MB3130BDD01387627E7FAD775F9E890@DB7PR08MB3130.eurprd08.prod.outlook.com> <DB7PR08MB3130C02AB04133E07146F40D9E890@DB7PR08MB3130.eurprd08.prod.outlook.com> <DB7PR08MB3130BA2C0F90E0819577C5289E890@DB7PR08MB3130.eurprd08.prod.outlook.com> <b712de09-fd35-1d5e-1842-31bb3b2e163d@gmail.com> <DB7PR08MB31304BCD517885F0E1C063F69E830@DB7PR08MB3130.eurprd08.prod.outlook.com>
Date: Wed, 10 Jun 2020 23:09:34 +0200
Message-ID: <87d0667hm9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Federico Parola <fede.parola@hotmail.it>, xdp-newbies@vger.kernel.org

Federico Parola <fede.parola@hotmail.it> writes:

> On 06/06/20 01:34, David Ahern wrote:
>> On 6/4/20 7:30 AM, Federico Parola wrote:
>>> Hello everybody,
>>> I'm implementing a token bucket algorithm to apply rate limit to traffic and I need the timestamp of packets to update the bucket. To get this information I'm using the bpf_ktime_get_ns() helper but I've discovered it has a non negligible impact on performance. I've seen there is work in progress to make hardware timestamps available to XDP programs, but I don't know if this feature is already available. Is there a faster way to retrieve this information?
>>> Thanks for your attention.
>>>
>> bpf_ktime_get_ns should be fairly light. What kind of performance loss
>> are you seeing with it?
> I've run some tests on a program forwarding packets between two 
> interfaces and applying rate limit: using the bpf_ktime_get_ns() I can 
> process up to 3.84 Mpps, if I replace the helper with a lookup on a map 
> containing the current timestamp updated in user space I go up to 4.48
> Mpps.

Can you share more details on the platform you're running this on? I.e.,
CPU and chipset details, network driver, etc.

-Toke
