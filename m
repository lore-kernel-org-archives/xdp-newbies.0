Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from forward106o.mail.yandex.net ([37.140.190.187]:33368 "EHLO
        forward106o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388473AbfIJOcF (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 10 Sep 2019 10:32:05 -0400
Subject: Re: bidirectional: => AF_XDP , <= XDP_REDIRECT
References: <d52b5b48-06cf-42dc-180d-896601cf3efb@yandex.ru>
 <87imq0ut8l.fsf@toke.dk>
From: Ilya Goslhtein <ilejn@yandex.ru>
Message-ID: <e83a6f5d-785e-d3c7-6bd8-63d972973427@yandex.ru>
Date: Tue, 10 Sep 2019 17:32:01 +0300
MIME-Version: 1.0
In-Reply-To: <87imq0ut8l.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>, xdp-newbies@vger.kernel.org

Hello Toke,

thanks for the response.

I do not think that it is the case.

The interface I am trying to share is outgoing for xdpbridge and 
incoming for xdp_bridge_map.

xdpbridge does not load xdp program for outgoing interface (while loads 
for incoming).

xdp_bridge_map loads dummy XDP program for outgoing redirect, while it 
is Ok if it is already exists.


It seems that if I use different queues for incoming and outgoing 
packets, everything is Ok, while I am not 100% sure yet. Does it look 
realistic?



On 10.09.2019 17:21, Toke Høiland-Jørgensen wrote:
> Ilya Goslhtein <ilejn@yandex.ru> writes:
>
>> Hello,
>>
>> I am trying to use a network interface to
>> (1) send packets via AF_XDP
>> (2) receive packets and redirect to another interface via xdp_redirect_map
>>
>> Basically, I am making xdpbridge https://github.com/ilejn/xdpbridge.
>>    bidirectional. My goal is to process packets in one direction in
>> kernelspace (xdp_redirect_map) and to pass packets in opposite direction
>> via userspace (recieve via AF_XDP then send via AF_XDP, rings are not
>> shared, so I perform memcpy).
>>
>> For test purposes I ran two applications: my xdpbridge and
>> xdp_redirect_map bpf sample.
>>
>> It does not work. Only few packets are received, then the thing stops.
>> Redirecting works until xdpbridge does 'bind' against the interface.
> This is because the AF_XDP application loads another XDP program on the
> interface that redirects the traffic into the socket. It is possible to
> write an XDP program that can do both (i.e., for each packet, decide
> whether to redirect it into the AF_XDP socket, or to another interface),
> but obviously none of the example programs know how to do this, so they
> end up stepping on each other's toes...
>
> -Toke

-- 
Best regards,
Ilya Golshtein
