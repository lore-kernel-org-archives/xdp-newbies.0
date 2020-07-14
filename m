Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from qrelay68.mxroute.com ([172.82.139.68]:38107 "EHLO
        qrelay68.mxroute.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgGNQEC (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 14 Jul 2020 12:04:02 -0400
Received: from filter003.mxroute.com ([168.235.111.26] 168-235-111-26.cloud.ramnode.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by qrelay68.mxroute.com (ZoneMTA) with ESMTPA id 1734e0cf4d4000de81.001
 for <xdp-newbies@vger.kernel.org>;
 Tue, 14 Jul 2020 15:58:58 +0000
Received: from ocean.mxroute.com (ocean.mxroute.com [195.201.59.214])
        by filter003.mxroute.com (Postfix) with ESMTPS id C879E6269D
        for <xdp-newbies@vger.kernel.org>; Tue, 14 Jul 2020 15:58:57 +0000 (UTC)
Subject: Re: XDP Software Issue - Payload Matching
References: <9f91026d-e3da-ff7c-b2dd-a4a795e6975b@gflclan.com>
 <878shyg3e9.fsf@toke.dk> <bbf21c58-09b3-b80f-11ab-548b229b9bdb@gflclan.com>
 <87ftc5ut0q.fsf@toke.dk> <edbf300d-a687-7652-d702-d58be09fd541@gflclan.com>
 <874ksjuca6.fsf@toke.dk> <a8acdb19-2d7d-43d6-67a7-3ad926ae27c4@gflclan.com>
 <87tv08j96h.fsf@toke.dk>
From: Christian Deacon <gamemann@gflclan.com>
Message-ID: <4581875c-d5af-3da5-bf01-ce3e404c94dc@gflclan.com>
Date: Tue, 14 Jul 2020 10:58:55 -0500
MIME-Version: 1.0
In-Reply-To: <87tv08j96h.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, xdp-newbies@vger.kernel.org

Hey Toke,


I apologize for the long delay on this. A lot has been going on recently!


I attempted to match payload data using the packet's payload as the BPF 
map key. Unfortunately, I didn't have any success with this. I stored my 
findings here from last month:


https://github.com/gamemann/XDP-Dynamic-Payload-Matching#section-methodfour-fail


I'd assume I may be missing something here, though.


I saw another XDP mailing list thread pop up recently regarding matching 
TCP payload data. I believe this may be what they're trying to achieve 
(being able to match dynamic payload data with XDP).


I was wondering if you had any other ideas on how we can match packet 
payload data against a BPF map.


Thank you for your time!


On 5/22/2020 10:12 AM, Toke Høiland-Jørgensen wrote:
> Christian Deacon <gamemann@gflclan.com> writes:
>
>> Hey Toke,
>>
>> I apologize for the delay on this. I've been working on a couple other
>> XDP/BPF projects recently.
>>
>> Thank you for the information you provided!
>>
>> Do you know of any open-source projects/examples that uses the method
>> you're suggesting to compare packet data without using for/while loops?
>> I haven't tried implementing the code yet, but I'm not entirely sure how
>> I am going to do so.
> Well, having a map that uses IP addresses as lookup key is kinda the
> same, I suppose, it's just a very limited part of the payload that's
> being used as the key. But other than that, no, please consider this a
> completely off-the-top-of-my-head idea with no warranties, implied or
> otherwise :)
>
> -Toke
>
