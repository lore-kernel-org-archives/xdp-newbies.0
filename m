Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-db8eur05olkn2042.outbound.protection.outlook.com ([40.92.89.42]:40486
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726081AbgFJOsz (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Jun 2020 10:48:55 -0400
Subject: Re: Lightweight packet timestamping
References: <DB7PR08MB3130BDD01387627E7FAD775F9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130C02AB04133E07146F40D9E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <DB7PR08MB3130BA2C0F90E0819577C5289E890@DB7PR08MB3130.eurprd08.prod.outlook.com>
 <b712de09-fd35-1d5e-1842-31bb3b2e163d@gmail.com>
From: Federico Parola <fede.parola@hotmail.it>
Message-ID: <DB7PR08MB31304BCD517885F0E1C063F69E830@DB7PR08MB3130.eurprd08.prod.outlook.com>
Date: Wed, 10 Jun 2020 16:48:45 +0200
In-Reply-To: <b712de09-fd35-1d5e-1842-31bb3b2e163d@gmail.com>
Content-Language: en-US
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: xdp-newbies@vger.kernel.org


On 06/06/20 01:34, David Ahern wrote:
> On 6/4/20 7:30 AM, Federico Parola wrote:
>> Hello everybody,
>> I'm implementing a token bucket algorithm to apply rate limit to traffic and I need the timestamp of packets to update the bucket. To get this information I'm using the bpf_ktime_get_ns() helper but I've discovered it has a non negligible impact on performance. I've seen there is work in progress to make hardware timestamps available to XDP programs, but I don't know if this feature is already available. Is there a faster way to retrieve this information?
>> Thanks for your attention.
>>
> bpf_ktime_get_ns should be fairly light. What kind of performance loss
> are you seeing with it?
I've run some tests on a program forwarding packets between two 
interfaces and applying rate limit: using the bpf_ktime_get_ns() I can 
process up to 3.84 Mpps, if I replace the helper with a lookup on a map 
containing the current timestamp updated in user space I go up to 4.48 Mpps.
> XDP does not support access to h/w timestamps at the moment.

I see, I think I'll keep the map solution for now, since I don't need 
nanoseconds precision. Thank you.


Federico
