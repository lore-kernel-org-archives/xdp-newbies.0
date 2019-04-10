Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55318 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729534AbfDJLFX (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Wed, 10 Apr 2019 07:05:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id o25so2122765wmf.5
        for <xdp-newbies@vger.kernel.org>; Wed, 10 Apr 2019 04:05:22 -0700 (PDT)
Subject: Re: [PATCH] net:bridge:always disable auto-tuning when the user
 specified MTU
References: <20190410023208.25435-1-huangruiPPP@gmail.com>
 <20190409193911.2d68a64d@shemminger-XPS-13-9360>
 <87y34ijgil.fsf@mellanox.com>
From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b8c233dd-2ade-2305-47c6-731396a6f591@cumulusnetworks.com>
Date: Wed, 10 Apr 2019 14:05:19 +0300
MIME-Version: 1.0
In-Reply-To: <87y34ijgil.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Petr Machata <petrm@mellanox.com>, Stephen Hemminger <stephen@networkplumber.org>
Cc: Huang Rui <huangruippp@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>, "hawk@kernel.org" <hawk@kernel.org>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kafai@fb.com" <kafai@fb.com>, "songliubraving@fb.com" <songliubraving@fb.com>, "yhs@fb.com" <yhs@fb.com>, Jiri Pirko <jiri@mellanox.com>, "ecree@solarflare.com" <ecree@solarflare.com>, Ido Schimmel <idosch@mellanox.com>, "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>, "amritha.nambiar@intel.com" <amritha.nambiar@intel.com>, Li Rongqing <lirongqing@baidu.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>, "bridge@lists.linux-foundation.org" <bridge@lists.linux-foundation.org>

On 10/04/2019 13:34, Petr Machata wrote:
> 
> Stephen Hemminger <stephen@networkplumber.org> writes:
> 
>> On Wed, 10 Apr 2019 02:32:08 +0000
>> Huang Rui <huangruippp@gmail.com> wrote:
>>
>>> For example.
>>> My purpose is to create a bridge br0 and join eth0 into br0.
>>> if we use this following way, the auto-tuning flag will not be disabled.
>>>
>>> If eth0's mtu is 1200
>>> step 1.brctl addbr br0
>>> step 2.brctl addif br0 eth0
>>> step 3.ifconfig br0 mtu 1200
>>> step 4.ifconfig eth0 mtu 1500
>>>
>>> Result:
>>> br0's MTU: 1500, eth0's MTU: 1500
>>>
>>> Expected:
>>> br0's MTU: 1200, eth0's MTU: 1500
>>>
>>> I have specified br0's MTU,  but auto-min policy works. So the MTU is
>>> not the result what we expected.
>>> As expected, if i have specified bridge's MTU, it will set the flag:
>>> BROPT_MTU_SET_BY_USER in net_bridge_opts disabled and auto-min/max
>>> policy will not work.But in this case, because the dev_set_mtu return
>>> early, the BROPT_MTU_SET_BY_USER flag will not be disabled and
>>> auto-min/max policy will still work.
>>>
>>> Signed-off-by: Huang Rui <huangruiPPP@gmail.com>
>>
>> A bridge like this going to drop frames.
>> A frame received with MTU of 1200 will get dropped.
> 
> That's true even if above you set br0's MTU to 1201, but then the
> auto-tuning is disabled as expected. The problem is that setting MTU to
> 1200 is perceived as a non-change, whereas it should instead be
> perceived as a signal that the user takes over the MTU management.
> 
>> The proper way to do this is to change MTU of both interfaces to match.

The only problem is a lot of the network configuration software these days
sets the MTU by default and that would lead to disabling auto-tune by default.
And since you haven't received a notification it means nothing has changed,
but in this case state has changed for the bridge quietly. It could break setups
which rely on the auto-tune and it would do it quietly which won't be easy to debug.

Also as I said in my previously, I really don't like adding bridge-specific
code in there. Another more ambitious approach would be to maybe always pass the
value to the drivers and let them deal with it, that would require going through all
ndo_change_mtu users and also would still not solve the problem of not sending
a notification when there has been a state change (the bridge no longer auto-tunes).
Thus the bridge will probably have to emit *some* notification by itself.

Perhaps this should've been a bridge option from the start instead of automatic
decision but it's late for that now.

Thanks,
 Nik
