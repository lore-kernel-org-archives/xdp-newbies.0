Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from lb.pantheon.sk ([46.229.239.20]:41249 "EHLO lb.pantheon.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfJCGRF (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 3 Oct 2019 02:17:05 -0400
From: =?iso-8859-2?Q?J=FAlius_Milan?= <Julius.Milan@pantheon.tech>
Subject: RE: xdpsock problem testing multiple queues
Date: Thu, 3 Oct 2019 06:17:00 +0000
Message-ID: <b3c1c0fb82ba4f65b71958130fd7f70c@pantheon.tech>
References: <ccfd36d0372547099b96ea494e2c6369@pantheon.tech>
        <CAJ+HfNh58fN=BU5ADzTs=vbCD1j5fs0i1EKhAQQdByjiVHz4BQ@mail.gmail.com>
 <20191002182755.00000657@gmail.com>
In-Reply-To: <20191002182755.00000657@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>, =?iso-8859-2?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc: Xdp <xdp-newbies@vger.kernel.org>, Magnus Karlsson <magnus.karlsson@gmail.com>, =?iso-8859-2?Q?Marek_Z=E1vodsk=FD?= <marek.zavodsky@pantheon.tech>

Many Thanks folks

>On Wed, 2 Oct 2019 15:52:04 +0200
>Björn Töpel <bjorn.topel@gmail.com> wrote:
>
>>On Wed, 2 Oct 2019 at 14:11, Július Milan <Julius.Milan@pantheon.tech> wrote:
>>>
>>> Hi all
>>>
>>> We are trying to test multiple RX queues with sample program xdpsock from kernel on vmware virtual machine with 2 queues.
>>> The driver on the NIC is:
>>> # ethtool -i ens192
>>> driver: vmxnet3
>>> version: 1.4.16.0-k-NAPI
>>>
>>> NIC has 2 queues, I can check it by ethtool -S.
>>>
>>> But when I try to use queue 1, I am getting following:
>>> # ./xdpsock -i ens192 -q 1
>>> /home/jmilan/ws/pt-xdp/linux/samples/bpf/xdpsock_user.c:xsk_configure_socket:315: errno: 1/"Operation not permitted"
>>>
>>> Any ideas what the problem could be? Maybe vmxnet3 driver does not support some necessary operations related to queues?
>>>
>>
>> XDP support is missing for that driver, but the XDP_SKB/generic mode 
>> is available, and should work.
>>
>> Can you run the xdp1 application in the samples directory, to rule out 
>> that you can run XDP.
>
> Xdp1 should work fine but I think the reason for a reported failure is because
> Vmxnet3 driver doesn't expose the {set,get}_channels ethtool API (at least I don't see it?) which is used by libbpf's xsk part for querying the underlying driver how many queues does it has and use that info for creating that many entries in XSKMAP.
>
> So in that case you're limited to use queue 0 because the XSKMAP map has only single entry.
>
> Maciej
>
>>
>>
>> Björn
>>
>>> Best Regards
>>> Július
